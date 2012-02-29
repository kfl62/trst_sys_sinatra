# encoding: utf-8
=begin
#FreightOut model (Accounting)
=end

class TrstAccFreightOut
  include Mongoid::Document
  include Mongoid::Timestamps

  field :id_date,       :type => Date
  field :id_stats,      :type => String
  field :id_intern,     :type => Boolean,   :default => false
  field :um,            :type => String,    :default => "kg"
  field :pu,            :type => Float,     :default => 0.00
  field :pu_invoice,    :type => Float,     :default => 0.00
  field :qu,            :type => Float,     :default => 0.00
  field :val,           :type => Float,     :default => 0.00
  field :val_invoice,   :type => Float,     :default => 0.00

  belongs_to :doc,     :class_name => "TrstAccDeliveryNote",  :inverse_of => :freights
  belongs_to :freight, :class_name => "TrstAccFreight",       :inverse_of => :outs

  before_create   :update_self
  before_update   :handle_stock_remove
  before_destroy  :handle_stock_add

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
      where(:doc_id.in => TrstAccExpenditure.pn(pn).map{|e| e.id})
    end
    # @todo
    def query_value_hash(y,m)
      monthly(y,m).each_with_object({}) do |f,h|
        k = "#{f.id_stats}"
        h[k].nil? ? h[k] = [f.id_stats,f.qu] : h[k][1] += f.qu
      end
    end
    # @todo
    def sum_qu(y,m)
      monthly(y,m).sum(:qu) || 0
    end
  end # Class methods
  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.doc.unit_id)
  end

  protected
  # @todo
  def update_self
    self.id_date   = doc.id_date
    self.val = (pu * qu).round(2)
    self.id_intern = true if doc.id_intern
  end
  # @todo
  def handle_stock_remove
    if id_date.month == Date.today.month
      stck = unit.current_stock
    else
      stck  = unit.monthly_stock(id_date.year,id_date.month)
      cstk  = unit.current_stock
    end
    out = self.qu
    last_pu = freight.ins.last.pu == 0 ? freight.pu : freight.ins.last.pu
    fs   = stck.freights.where(:id_stats => id_stats)
    csfs = cstk.freights.where(:id_stats => id_stats)
    if fs.count == 1
      f   = fs.first
      csf = csfs.where(:pu => f.pu).first
      f.qu   -= qu
      csf.qu -= qu
      self.pu = f.pu
      f.save
      csf.save
    else
      sk = fs.asc(:pu).collect{|f| f.pu}
      sk.delete(last_pu).nil? ? sk : sk.push(last_pu)
      sk.delete(0).nil? ? sk : sk.push(0) if unit.main?
      sk.each do |spu|
        f   = fs.where(:pu => spu).first
        csf = csfs.where(:pu => f.pu).first
        if out > f.qu
          self.class.create(:id_stats => f.id_stats,:freight_id => f.freight.id, :pu => f.pu, :qu => f.qu, :doc_id => doc_id) unless f.qu == 0
          out -= f.qu unless out == 0
          f.qu   = 0
          csf.qu = 0
          f.save
          csf.save
        else
          self.class.create(:id_stats => f.id_stats,:freight_id => f.freight.id, :pu => f.pu, :qu => out, :doc_id => doc_id) unless out == 0
          f.qu   -= out
          csf.qu -= out
          out = 0
          f.save
          csf.save
        end
      end
      self.delete
    end
  end
  # @todo
  def handle_stock_add
    to_handle = (id_date.month == Date.today.month) ? [unit.current_stock] : [unit.current_stock, unit.monthly_stock(id_date.year,id_date.month)]
    to_handle.each do |stck|
      f = stck.freights.find_or_create_by(:id_stats => id_stats, :pu => pu)
      f.freight_id = freight.id
      f.qu += qu
      f.save
    end
  end
end
