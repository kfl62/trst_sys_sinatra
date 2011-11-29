# encoding: utf-8
=begin
#FreightIn model (Accounting)
=end

class TrstAccFreightIn
  include Mongoid::Document
  include Mongoid::Timestamps

  field :id_date,     :type => Date
  field :id_stats,    :type => String
  field :um,          :type => String,    :default => "kg"
  field :pu,          :type => Float,     :default => 0.00
  field :qu,          :type => Float,     :default => 0.00
  field :val,         :type => Float,     :default => 0.00

  belongs_to :doc_exp, :class_name => "TrstAccExpenditure",   :inverse_of => :freights
  belongs_to :doc_grn, :class_name => "TrstAccGrn",           :inverse_of => :freights
  belongs_to :freight, :class_name => "TrstAccFreight",       :inverse_of => :ins

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
    def keys
      all.each_with_object([]){|f,k| k << "#{f.id_stats}_#{"%05.2f" % f.pu}"}.uniq!.sort!
    end
    # @todo
    def by_id_stats_and_pu(key)
      id_stats, pu = key.split('_')
      where(:id_stats => id_stats).and(:pu => pu.to_f)
    end
    # @todo
    def pn(pn)
      where(:doc_exp_id.in => TrstAccExpenditure.pn(pn).map{|e| e.id})
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

  # @todod
  def doc
    doc_exp_id.nil? ? doc_grn : doc_exp
  end

  protected
  # @todo
  def update_self
    self.id_date = doc_exp.nil? ?  doc_grn.id_date : doc_exp.id_date
    self.id_stats = freight.id_stats
    self.val = (pu * qu).round(2)
  end

end
