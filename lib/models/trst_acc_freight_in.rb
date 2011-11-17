# encoding: utf-8
=begin
#FreightIn model (Accounting)
=end

class TrstAccFreightIn
  include Mongoid::Document
  include Mongoid::Timestamps

  field :id_date,     :type => Date
  field :um,          :type => String,    :default => "kg"
  field :pu,          :type => Float,     :default => 0.00
  field :qu,          :type => Float,     :default => 0.00

  belongs_to :doc,     :class_name => "TrstAccExpenditure",   :inverse_of => :freights
  belongs_to :freight, :class_name => "TrstAccFreight",       :inverse_of => :ins

  before_save   :update_date

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
    def pn(pn)
      where(:doc_id.in => TrstAccExpenditure.pn(pn).map{|e| e.id})
    end
    # @todod
    def query_value_hash(m)
      monthly(m).each_with_object({}) do |f,h|
        k = "#{f.freight.id_stats}_#{"%05.2f" % f.pu}"
        if h[k].nil?
          h[k] = [f.freight.id_stats, f.freight.name, f.pu, f.qu, (f.pu * f.qu).round(2)]
        else
          h[k][3] += f.qu
          h[k][4] += (f.pu * f.qu).round(2)
        end
      end
    end
  end

  protected
  # @todo
  def update_date
    self.id_date = doc.id_date
  end

end
