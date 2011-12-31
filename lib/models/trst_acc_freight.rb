# encoding: utf-8
=begin
#Freight model (Accounting)
=end

class TrstAccFreight
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        :type => String,        :default => "Freight"
  field :um,          :type => String,        :default => "kg"
  field :pu,          :type => Float,         :default => 0.00
  field :p03,         :type => Boolean,       :default => true
  field :category,    :type => String,        :default => "Category"
  field :descript,    :type => Array,         :default => []
  field :pu_retro,    :type => Float,         :default => 0.00
  field :id_stats,    :type => String

  has_many :ins,      :class_name => "TrstAccFreightIn",    :inverse_of => :freight
  has_many :outs,     :class_name => "TrstAccFreightOut",   :inverse_of => :freight
  has_many :stocks,   :class_name => "TrstAccFreightStock", :inverse_of => :freight
  belongs_to :unit,   :class_name => "TrstFirmUnit",        :inverse_of => :freights

  class << self
    # @todo
    def auto_search(unit=nil, stock=nil)
      unit ||= TrstFirm.unit_id_by_unit_slug("AF01")
      fs = []
      where(:unit_id => unit).asc(:name).each do |f|
        if stock
          dn = TrstAccDeliveryNote.by_unit_id(unit).last
          month = dn.id_date.month
          fs << {:id => f.id,:um => f.um,:stock => f.stock(month),:id_stats => f.id_stats, :label => f.name}
        else
          fs << {:id => f.id,:um => f.um,:pu => f.pu,:pu_retro => f.pu_retro,:p03 => f.p03,:id_stats => f.id_stats,:label => f.name}
        end
      end
      {:identifier => "id",:items => fs}
    end
    # @todo
    def pos(s)
      where(:unit_id => TrstFirm.unit_id_by_unit_slug(s)).asc(:id_stats)
    end
    # @todo
    def by_unit_id(u)
      where(:unit_id => u).asc(:id_stats)
    end
    # @todo
    def by_id_stats(ids)
      where(:id_stats => ids).asc(:unit_id)
    end
    # @todo
    def query(y = nil, m = nil)
      y ||= Date.today.year
      m ||= Date.today.month
      retval = []
      asc(:id_stats).each do |f|
        stk = f.stocks.monthly(y,m).sum(:qu) || 0
        f_in  = f.ins.monthly(y,m).sum(:qu) || 0
        f_out = f.outs.monthly(y,m).sum(:qu) || 0
        retval << [f.id, f.name, stk.round(2), f_in.round(2), f_out.round(2), (stk + f_in - f_out).round(2)]
      end
      retval
    end
    # @todo
    def query_value(y = nil, m = nil)
      y ||= Date.today.year
      m ||= Date.today.month
      month_next =  m == 12 ? 1 : m + 1
      stk_start, ins, outs, stk_end = {}, {}, {}, {}
      asc(:id_stats).each do |fr|
        stk_start.merge!(fr.stocks.query_value_hash(y,m)){|k,o,n| k = [ n[0], n[1], n[2], o[3].nil? ? n[3] : o[3] + n[3], o[4].nil? ? n[4] : o[4] + n[4] ]}
        ins.merge!(fr.ins.query_value_hash(y,m)){|k,o,n| k = [ n[0], n[1], n[2], o[3].nil? ? n[3] : o[3] + n[3], o[4].nil? ? n[4] : o[4] + n[4] ]}
        if m == Date.today.month || fr.stocks.query_value_hash(y,month_next).empty?
          outs.merge!(fr.outs.query_value_hash(y,m)){|k,o,n| k = [ n[0], o[1].nil? ? n[1] : o[1] + n[1] ]}
        else
          stk_end.merge!(fr.stocks.query_value_hash(y,month_next)){|k,o,n| k = [ n[0], n[1], n[2], o[3].nil? ? n[3] : o[3] + n[3], o[4].nil? ? n[4] : o[4] + n[4] ]}
        end
      end
      retval = (stk_start.keys | ins.keys).sort.each_with_object({}) do |k,h|
        stk_start[k].nil? ? h[k] = (ins[k][0..2] + [0.0,0.0] + ins[k][2..-1]) : h[k] = stk_start[k] + [0.0,0.0]
        h[k][5..-1] = ins[k][3..-1] unless ins[k].nil?
      end
      retval.values.each{|v|
        last_in = where(:id_stats  => v[0])[0].ins.monthly(y,m).last || where(:id_stats => v[0])[0].stocks.monthly(y,m).last
        v[10] = v[2] == last_in.pu ? 1 : 0
      }
      retval = handle_query_values(retval,stk_start,ins,outs,stk_end)
      retval = sum_query_values(retval)
    end
    # @todo
    def stats(y = nil, m = nil)
      retval, part, tot_stk, tot_ins, tot_out, tot_end = [], [], 0, 0, 0, 0
      y ||= Date.today.year
      m ||= Date.today.month
      stats_for = all.map{|f| [f.id_stats, f.name]}.uniq.sort
      stats_for.each_with_index do |ids,i|
        part[i] = []
        TrstFirm.unit_ids.each do |u|
          f = by_unit_id(u).by_id_stats(ids[0]).first
          if f
            pos_stk = f.stocks.monthly(y,m).sum(:qu) || 0
            pos_ins = f.ins.monthly(y,m).sum(:qu) || 0
            pos_out = f.outs.monthly(y,m).sum(:qu) || 0
            pos_end = pos_stk.round(2) + pos_ins.round(2) - pos_out.round(2)
            tot_stk += pos_stk.round(2)
            tot_ins += pos_ins.round(2)
            tot_out += pos_out.round(2)
            tot_end += pos_end.round(2)
            part[i] << pos_end.round(2)
          else
            part[i] << 0
          end
        end
        retval << [ids[1], tot_stk.round(2), tot_ins.round(2), tot_out.round(2), tot_end.round(2), part[i]].flatten
        tot_stk, tot_ins, tot_out, tot_end = 0, 0, 0, 0
      end
      retval
    end
    # @todo
    def stats_freight(id, y = nil, m = nil)
      f = find(id)
      y ||= Date.today.year
      m ||= Date.today.month
      days_in_month = (Date.new(y, 12, 31) << (12-m)).day
      final = f.stocks.monthly(y,m).sum(:qu) || 0
      retval, tot_ins, tot_out = [], 0, 0
      (1..days_in_month).each do |i|
        day = Date.new(y,m,i).to_s
        f_ins = f.ins.daily(day).sum(:qu) || 0
        f_out = f.outs.daily(day).sum(:qu) || 0
        final = final + f_ins - f_out
        tot_ins += f_ins
        tot_out += f_out
        retval << [day.to_s, f_ins, f_out, final] unless (f_ins == 0 && f_out ==0)
      end
      retval << ["", tot_ins, tot_out, final]
      retval
    end

  end # Class methods

  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.unit_id)
  end
  # @todo
  def col_name
    ary = name.split(" ")
    case ary.length
     when 1
       ary[0][0..3].upcase
     when 2
       ary[0][0..1].upcase + ary[1][0..1].upcase
     when 3
       ary[0][0..1].upcase + ary[1][0].upcase + ary[2][0].upcase
     else
       "ERR"
     end
  end
  # @todo
  def expenditure_pdf_name
    ary = name.split(" ")
    case ary.length
    when 1
      ary[0].titleize
    when 2
      [ary[0][0..2],'.',ary[1]].join[0..7]
    else
      "Error"
    end
  end
  # @todo
  def stock(y = nil, m = nil)
    f_stk = stocks.monthly(y,m).sum(:qu) || 0
    f_ins = ins.monthly(y,m).sum(:qu) || 0
    f_out = outs.monthly(y,m).sum(:qu) || 0
    f_stk + f_ins - f_out
  end
  # @todo
  def table_data
    [
      {:css => "normal",:name => "name",:label => I18n.t("trst_acc_freight.name"),:value => name},
      {:css => "normal",:name => "um",:label => I18n.t("trst_acc_freight.um"),:value => um},
      {:css => "integer",:name => "pu",:label => I18n.t("trst_acc_freight.pu"),:value => pu},
      {:css => "accountancy.retro",:name => "pu_retro",:label => I18n.t("trst_acc_freight.pu_retro"),:value => pu_retro},
      {:css => "boolean",:name => "p03",:label => I18n.t("trst_acc_freight.p03"),:value => p03},
      {:css => "admin",:name => "descript,",:label => I18n.t("trst_acc_freight.cod"),:value => descript[0]},
      {:css => "admin",:name => "id_stats",:label => I18n.t("trst_acc_freight.id_stats"),:value => id_stats}
    ]
  end

  protected
  # @todo
  def self.handle_query_values(values,stk_start,ins,outs,stk_end)
    values.each_pair do |k,v|
      if stk_end[k].nil? && stk_end.empty?
        outs_key = k.split('_')[0]
        if outs[outs_key]
          tmp = values.select{|k,v1| v1[0] == outs[v[0]][0]}.each.sort_by{|k,v2| v2[10]}.each_with_object({}){|a,h| h[a[0]] = a[1]}
          tmp.each_pair do |k,tv|
            if tv[7].nil?
              if tv[10] == 0
                if tv[3] + tv[5] < outs[v[0]][1]
                  tv[7] = tv[3] + tv[5]
                  tv[8] = tv[3] + tv[5] - tv[7]
                  outs[v[0]][1] -= tv[7]
                else
                  tv[7] = outs[v[0]][1]
                  tv[8] = tv[3] + tv[5] - tv[7]
                  outs[v[0]][1] -= tv[7]
                end
              end
            end
            if tv[10] == 1
              tv[7] = outs[v[0]][1]
              tv[8] = tv[3] + tv[5] - tv[7]
            end
          end
          values.merge! tmp
        else
          v[7] = 0
          v[8] = v[3] + v[5] - v[7]
        end
      else
        if stk_end[k].nil?
          v[7] = v[3] + v[5]
          v[8] = 0.0
        else
          v[7] = v[3] + v[5] - stk_end[k][3]
          v[8] = stk_end[k][3]
        end
      end
      v[9] = (v[2] * v[8]).round(2)
    end
    values
  end
  # @todo
  def self.sum_query_values(values)
    values.merge!({"TOTAL" => ["TOTAL","Total (RON)",0,0,0,0,0,0,0,0,0]})
    values.each_pair do |k,v|
      unless k == "TOTAL"
        values["TOTAL"][4] += v[4]
        values["TOTAL"][6] += v[6]
        values["TOTAL"][9] += v[9]
      end
    end
    values
  end
end
