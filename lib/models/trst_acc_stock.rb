# encoding: utf-8
=begin
#Expenditure model (Accounting)
=end

class TrstAccStock
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        :type => String,    :default => "Stock_unit_month"
  field :id_month,    :type => Integer,   :default => Date.today.month
  field :expl,        :type => String,    :default => "Stock initial"

  has_many   :freights,   :class_name => "TrstAccFreightStock", :inverse_of => :doc
  belongs_to :unit,       :class_name => "TrstFirmUnit",        :inverse_of => :stocks

  after_create :freights_init
  after_destroy :destroy_freights
  class << self
    # @todo
    def pos(slg)
      where(:unit_id => TrstFirm.unit_id_by_unit_slug(slg))
    end
    # @todo
    def monthly(month = nil)
      month ||= Date.today.month
      where(:id_month => month.to_i)
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
  def freights_sort_by_name
    freights.sort{|a,b| (a.freight.name rescue "Error...") <=> (b.freight.name rescue "Error...")}
  end
  protected
  # @todo
  def freights_init
    TrstAccFreight.by_unit_id(self.unit_id).asc(:name).each do |f|
      self.freights << TrstAccFreightStock.create(:doc_id => self.id, :freight_id => f.id, :um => f.um, :pu => f.pu)
    end
  end
  # @todo
  def destroy_freights
    self.freights.destroy_all
  end

end
