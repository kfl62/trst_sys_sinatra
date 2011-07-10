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

  scope :pos,     ->(slg) { where(:unit_id => TrstFirm.unit_id_by_unit_slug(slg))}
  scope :monthly, ->(m)   { where(:id_month => m) }

  after_destroy :destroy_freights
  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.unit_id) rescue nil
  end
  # @todo
  def qu_by_freight_id(id)
    freights.where(:freight_id => id).first.qu rescue 0.00
  end
  # @todo
  def freights_for_table
    TrstAccFreight.asc(:name).map{|f| [f.id, f.name, f.um, qu_by_freight_id(f.id)]}
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
