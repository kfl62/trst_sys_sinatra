# encoding: utf-8
=begin
#Money cache model (Accounting)
=end

class TrstAccCache
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :id_date,       :type => Date,      :default => Date.new(Time.now.year,Time.now.month,Time.now.day)
  field :money_in,      :type => Float,     :default => 0.00
  field :money_out,     :type => Float,     :default => 0.00
  field :money_stock,   :type => Float,     :default => 0.00
  field :expl,          :type => String,    :default => ""

  belongs_to :unit,       :class_name => "TrstFirmUnit",      :inverse_of => :dps

  class << self
    # @todo
    def daily(day)
      crit = where(:id_date => DateTime.strptime("#{day}","%F").to_time)
      [crit.sum(:money_in),crit.sum(:money_out),crit.sum(:money_stock)]
    end
    # @todo
    def pos(slg)
      slg = slg.upcase
      where(:unit_id => TrstFirm.unit_id_by_unit_slug(slg))
    end
  end # Class methods


end
