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
  field :pu_other,    :type => Array,         :default => []
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
          fs << {:id => f.id,:um => f.um,:stock => f.stock(month), :label => f.name}
        else
          fs << {:id => f.id,:um => f.um,:pu => f.pu,:p03 => f.p03,:label => f.name}
        end
      end
      {:identifier => "id",:items => fs}
    end
    # @todo
    def pos(s)
      where(:unit_id => TrstFirm.unit_id_by_unit_slug(s)).asc(:name)
    end
    # @todo
    def by_unit_id(u)
      where(:unit_id => u).asc(:name)
    end
    # @todo
    def by_id_stats(ids)
      where(:id_stats => ids).asc(:unit_id)
    end
    # @todo
    def query(m = nil)
      today = Date.today
      month = m.nil? ? today.month : m.to_i
      retval = []
      asc(:name).each do |f|
        stk = f.stocks.monthly(month).sum(:qu) || 0
        f_in  = f.ins.monthly(month).sum(:qu) || 0
        f_out = f.outs.monthly(month).sum(:qu) || 0
        retval << [f.id, f.name, stk.round(2), f_in.round(2), f_out.round(2), (stk + f_in - f_out).round(2)]
      end
      retval
    end
    # @todo
    def query_value(m = nil)
      today = Date.today
      month = m.nil? ? today.month : m.to_i
      stk_start, ins, outs, stk_end = {}, {}, {}, {}
      asc(:name).each do |fr|
        stk_start_t = fr.stocks.monthly(month).each_with_object({}) do |f,h|
          k = "#{f.freight.name}_#{"%05.2f" % f.pu}"
          h[k] = [f.freight.id.to_s, f.freight.name, f.pu, f.qu, (f.pu * f.qu).round(2)]
        end
        stk_start.merge! stk_start_t
        ins_t = fr.ins.monthly(month).each_with_object({}) do |f,h|
          k = "#{f.freight.name}_#{"%05.2f" % f.pu}"
          if h[k].nil?
            h[k] = [f.freight.id.to_s, f.freight.name, f.pu, f.qu, (f.pu * f.qu).round(2)]
          else
            h[k][3] += f.qu
            h[k][4] += (f.pu * f.qu).round(2)
          end
        end
        ins.merge! ins_t
        if month == Date.today.month
          outs_t = fr.outs.monthly(month).each_with_object({}) do |f,h|
            k = "#{f.freight.id.to_s}"
            h[k].nil? ? h[k] = [f.freight.id.to_s,f.qu] : h[k][1] += f.qu
          end
          outs.merge! outs_t
        end
        stk_end_t = fr.stocks.monthly(month + 1).each_with_object({}) do |f,h|
          k = "#{f.freight.name}_#{"%05.2f" % f.pu}"
          h[k] = [f.freight.id.to_s, f.freight.name, f.pu, f.qu, (f.pu * f.qu).round(2)]
        end
        stk_end.merge! stk_end_t
      end
      retval = (stk_start.keys | ins.keys).sort.each_with_object({}) do |k,h|
        stk_start[k].nil? ? h[k] = (ins[k][0..2] + [0.0,0.0] + ins[k][2..-1]) : h[k] = stk_start[k] + [0.0,0.0]
        h[k][5..-1] = ins[k][3..-1] unless ins[k].nil?
      end
      retval.values.each{|v|
        last_in = find(v[0]).ins.monthly(month).last || find(v[0]).stocks.monthly(month).last
        v[10] = v[2] == last_in.pu ? 1 : 0
      }
      retval.each_pair do |k,v|
        if stk_end[k].nil? && (stk_start || ins)
          if outs[v[0]]
            tmp = retval.select{|k,v1| v1[0] == outs[v[0]][0]}.each.sort_by{|k,v2| v2[10]}.each_with_object({}){|a,h| h[a[0]] = a[1]}
            tmp.each_pair do |k,tv|
              if tv[10] == 1
                tv[7] = outs[v[0]][1]
                tv[8] = tv[3] + tv[5] - tv[7]
              else
                if tv[7].nil?
                  if tv[3] + tv[5] < outs[v[0]][1]
                    tv[7] = tv[3] + tv[5]
                    tv[8] = tv[3] + tv[5] - tv[7]
                    outs[v[0]][1] -= tv[7]
                  else
                    tv[7] = outs[v[0]][1]
                    tv[8] = tv[3] + tv[5] - tv[7]
                    outs[v[0]][1] = 0
                  end
                else
                  # if tv[3] + tv[5] < outs[v[0]][1]
                  #   tv[7] = tv[3] + tv[5]
                  #   tv[8] = tv[3] + tv[5] - tv[7]
                  #   outs[v[0]][1] -= tv[7]
                  # else
                  #   tv[7] = outs[v[0]][1]
                  #   tv[8] = tv[3] + tv[5] - tv[7]
                  #   outs[v[0]][1] = 0
                  # end
                end
              end
            end
            retval.merge! tmp
          else
            v[7] = v[3] + v[5]
            v[8] = v[3] + v[5] - v[7]
          end
        else
          v[7] = v[3] + v[5] - stk_end[k][3]
          v[8] = stk_end[k][3]
        end
      end
      retval.values.each{|v| v[9] = (v[2] * v[8]).round(2)}
      retval
    end
     # @todo
    def stats(m = nil)
      retval, part, tot_stk, tot_ins, tot_out, tot_end = [], [], 0, 0, 0, 0
      today = Date.today
      month = m.nil? ? today.month : m.to_i
      stats_for = all.map{|f| [f.name, f.id_stats]}.uniq.sort
      stats_for.each_with_index do |ids,i|
        part[i] = []
        TrstFirm.unit_ids.each do |u|
          f = by_unit_id(u).by_id_stats(ids[1]).first
          if f
            pos_stk = f.stocks.monthly(month).sum(:qu) || 0
            pos_ins = f.ins.monthly(month).sum(:qu) || 0
            pos_out = f.outs.monthly(month).sum(:qu) || 0
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
        retval << [ids[0], tot_stk.round(2), tot_ins.round(2), tot_out.round(2), tot_end.round(2), part[i]].flatten
        tot_stk, tot_ins, tot_out, tot_end = 0, 0, 0, 0
      end
      retval
    end
    # @todo
    def stats_freight(id, m = nil)
      f = find(id)
      today = Date.today
      year  = today.year
      month = m.nil? ? today.month : m.to_i
      days_in_month = (Date.new(year, 12, 31) << (12-month)).day
      final = f.stocks.monthly(month).sum(:qu) || 0
      retval, tot_ins, tot_out = [], 0, 0
      (1..days_in_month).each do |i|
        day = Date.new(year,month,i).to_s
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
    # @todo
    def inventory(m = nil)
      today = Date.today
      year  = today.year
      month = m.nil? ? today.month : m.to_i
      data = Hash.new
      asc(:name).each do |fgt|
        fgt.stocks.monthly(m).each do |s|
          key = "stock_#{s.freight.name}_#{s.pu*100}"
          unless s.pu && s.qu == 0
            if data[key].nil?
              data[key] = [s.pu, s.qu, (s.pu * s.qu).round(2)]
            else
              data[key][1] += s.qu
              data[key][3] += (s.pu * s.qu).round(2)
            end
          end
        end
        fgt.ins.monthly(m).each do |f|
          key = "#{f.freight.name}_#{f.pu*100}"
          if data[key].nil?
            data[key] = [f.freight.name, f.um, f.qu, f.pu, (f.pu * f.qu).round(2)]
          else
            data[key][2] += f.qu
            data[key][4] += (f.pu * f.qu).round(2)
          end
        end
      end
      data
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
  def stock(month = nil)
    f_stk = stocks.monthly(month).sum(:qu) || 0
    f_ins = ins.monthly(month).sum(:qu) || 0
    f_out = outs.monthly(month).sum(:qu) || 0
    f_stk + f_ins - f_out
  end
  # @todo
  def table_data
    [
      {:css => "normal",:name => "name",:label => I18n.t("trst_acc_freight.name"),:value => name},
      {:css => "normal",:name => "um",:label => I18n.t("trst_acc_freight.um"),:value => um},
      {:css => "integer",:name => "pu",:label => I18n.t("trst_acc_freight.pu"),:value => pu},
      {:css => "boolean",:name => "p03",:label => I18n.t("trst_acc_freight.p03"),:value => p03},
      {:css => "admin",:name => "descript,",:label => I18n.t("trst_acc_freight.cod"),:value => descript[0]},
      {:css => "admin",:name => "id_stats",:label => I18n.t("trst_acc_freight.id_stats"),:value => id_stats}
    ]
  end
end
