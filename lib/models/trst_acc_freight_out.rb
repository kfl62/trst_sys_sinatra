# encoding: utf-8
=begin
#FreightOut model (Accounting)
=end

class TrstAccFreightOut
  include Mongoid::Document
  include Mongoid::Timestamps

  field :id_date,       :type => Date
  field :id_stats,      :type => String
  field :um,            :type => String,    :default => "kg"
  field :pu,            :type => Float,     :default => 0.00
  field :pu_invoice,    :type => Float,     :default => 0.00
  field :qu,            :type => Float,     :default => 0.00
  field :val,           :type => Float,     :default => 0.00

  belongs_to :doc,     :class_name => "TrstAccDeliveryNote",  :inverse_of => :freights
  belongs_to :freight, :class_name => "TrstAccFreight",       :inverse_of => :outs

  before_update   :update_self

  class << self
    # @todo
    def daily(d)
      where(:id_date => DateTime.strptime("#{d}","%F").to_time)
    end
    # @todo
    def monthly(m)
      y = Date.today.year
      m = m.to_i
      mb = DateTime.new(y, m)
      me = DateTime.new(y, m + 1)
      where(:id_date.gte => mb.to_time, :id_date.lt => me.to_time)
    end
    # @todo
    def by_id_stats_and_pu(key)
      id_stats, pu = key.split('_')
      where(:id_stats => id_stats)
    end
    # @todo
    def pn(pn)
      where(:doc_id.in => TrstAccExpenditure.pn(pn).map{|e| e.id})
    end
    # @todo
    def query_value_hash(m)
      monthly(m).each_with_object({}) do |f,h|
        k = "#{f.freight.id_stats}"
        h[k].nil? ? h[k] = [f.freight.id_stats,f.qu] : h[k][1] += f.qu
      end
    end
  end

  protected
  # @todo
  def update_self
    self.id_date = doc.id_date
    self.id_stats = freight.id_stats
    self.val = (pu_invoice * qu).round(2)
  end

end
