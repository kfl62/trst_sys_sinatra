# encoding: utf-8
=begin
#FreightStock model (Accounting)
=end

class TrstAccFreightStock
  include Mongoid::Document
  include Mongoid::Timestamps

  field :id_date,       :type => Date
  field :id_stats,      :type => String
  field :um,            :type => String,    :default => "kg"
  field :pu,            :type => Float,     :default => 0.00
  field :qu,            :type => Float,     :default => 0.00
  field :val,           :type => Float,     :default => 0.00

  belongs_to :doc,     :class_name => "TrstAccStock",     :inverse_of => :freights
  belongs_to :freight, :class_name => "TrstAccFreight",   :inverse_of => :stocks

  before_update   :update_self

  class << self
    # @todo
    def monthly(y = nil, m = nil)
      y ||= Date.today.year
      m ||= Date.today.month
      where(:id_date => Date.new(y,m,1))
    end
    # @todo
    def keys
      all.each_with_object([]){|f,k| k << "#{f.id_stats}_#{"%05.2f" % f.pu}"}.uniq.sort!
    end
    # @todo
    def by_id_stats_and_pu(key)
      id_stats, pu = key.split('_')
      where(:id_stats => id_stats).and(:pu => pu.to_f)
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
  end

  protected
  # @todo
  def update_self
    self.id_date = doc.id_date
    self.id_stats = freight.id_stats
    self.val = (pu * qu).round(2)
  end
end
