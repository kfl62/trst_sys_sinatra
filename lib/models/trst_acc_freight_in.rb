# encoding: utf-8
=begin
#FreightIn model (Accounting)
=end

class TrstAccFreightIn
  include Mongoid::Document
  include Mongoid::Timestamps

  field :id_date,     :type => Date
  field :id_stats,    :type => String
  field :id_intern,   :type => Boolean,   :default => false
  field :um,          :type => String,    :default => "kg"
  field :pu,          :type => Float,     :default => 0.00
  field :qu,          :type => Float,     :default => 0.00
  field :val,         :type => Float,     :default => 0.00

  belongs_to :doc_exp, :class_name => "TrstAccExpenditure",   :inverse_of => :freights
  belongs_to :doc_grn, :class_name => "TrstAccGrn",           :inverse_of => :freights
  belongs_to :freight, :class_name => "TrstAccFreight",       :inverse_of => :ins

  before_update   :update_self
  before_update   :handle_stock_add
  before_destroy  :handle_stock_remove

  class << self
    # @todo
    def daily(y = nil, m = nil, d = nil)
      y,m,d = y.split('-').map{|s| s.to_i} if y.is_a? String
      y ||= Date.today.year
      m ||= Date.today.month
      d ||= Date.today.mday
      where(:id_date => Time.utc(y,m,d)).asc(:name)
    end
    # @todo
    def monthly(y = nil, m = nil)
      y ||= Date.today.year
      m ||= Date.today.month
      mb = DateTime.new(y, m)
      me = m == 12 ? DateTime.new(y + 1, 1) : DateTime.new(y, m + 1)
      where(:id_date.gte => mb.to_time, :id_date.lt => me.to_time)
    end
    # @todo
    def nin(nin = true)
      where(:id_intern => !nin)
    end
    # @todo
    # @todo
    def keys(with_pu = true)
      if with_pu
        all.each_with_object([]){|f,k| k << "#{f.id_stats}_#{"%05.2f" % f.pu}"}.uniq.sort!
      else
        all.each_with_object([]){|f,k| k << "#{f.id_stats}"}.uniq.sort!
      end
    end
    # @todo
    def by_id_stats_and_pu(key)
      id_stats, pu = key.split('_')
      if pu
        where(:id_stats => id_stats).and(:pu => pu.to_f)
      else
        where(:id_stats => id_stats)
      end
    end
    # @todo
    def pn(pn)
      where(:doc_exp_id.in => TrstAccExpenditure.pn(pn).map{|e| e.id})
    end
    # @todo
    def query_value_hash(y,m)
      monthly(y,m).each_with_object({}) do |f,h|
        k = "#{f.id_stats}_#{"%05.2f" % f.pu}"
        if h[k].nil?
          h[k] = [f.id_stats, f.freight.name, f.pu, f.qu, (f.pu * f.qu).round(2)]
        else
          h[k][3] += f.qu
          h[k][4] += (f.pu * f.qu).round(2)
        end
      end
    end
    # @todo
    def sum_qu(y,m)
      monthly(y,m).sum(:qu) || 0
    end
  end

  # @todod
  def doc
    doc_exp_id.nil? ? doc_grn : doc_exp
  end
  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.doc.unit_id)
  end

  protected
  # @todo
  def update_self
    self.id_date   = doc_exp.nil? ? doc_grn.id_date : doc_exp.id_date
    self.id_intern = true if doc.id_intern
    self.val = (pu * qu).round(2)
  end
  # @todo
  def handle_stock_add
    if id_date.month == Date.today.month
      stck = unit.current_stock
      f = stck.freights.find_or_create_by(:id_stats => id_stats, :pu => pu)
      f.freight_id = freight.id
      f.qu  += qu
      f.save
    end
  end
  # @todo
  def handle_stock_remove
    if id_date.month == Date.today.month
      stck = unit.current_stock
      f = stck.freights.find_or_create_by(:id_stats => id_stats, :pu => pu)
      f.freight_id = freight.id
      f.qu -= qu
      f.save
    end
  end

end
