# encoding: utf-8
=begin
#Expenditure model (Accounting)
=end

class TrstAccStock
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        :type => String,    :default => "Stock_unit_month"
  field :id_month,    :type => Integer,   :default => Date.today.month
  field :expl,        :type => String,    :default => "Monthly"

  has_many   :freights,   :class_name => "TrstAccFreightStock", :inverse_of => :doc
  belongs_to :unit,       :class_name => "TrstFirmUnit",        :inverse_of => :stocks

  after_destroy :destroy_freights
  class << self
    # @todo
    def pos(slg)
      where(:unit_id => TrstFirm.unit_id_by_unit_slug(slg))
    end
    # @todo
    def monthly(m)
      m = m.to_i
      where(:id_month => m)
    end
    # @todo
    def by_unit_id(u)
      where(:unit_id => u).asc(:name)
    end
  end # Class methods
  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.unit_id) rescue nil
  end
  # @todo
  def qu_by_freight_id(id)
    freights.where(:freight_id => id).first.qu rescue 0.00
  end
  # @todo
  def freights_for_table(u)
    TrstAccFreight.by_unit_id(u).asc(:name).map{|f| [f.id, f.name, f.um, qu_by_freight_id(f.id)]}
  end
  # @todo
  def stocks_for_table
    # code here
  end
  protected
  # @todo
  def destroy_freights
    self.freights.destroy_all
  end

end
