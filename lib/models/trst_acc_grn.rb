# encoding: utf-8
=begin
#Goods received note (Accounting)
=end

class TrstAccGrn
  include Mongoid::Document
  include Mongoid::Timestamps

  field   :name,                  :type => String
  field   :id_date,               :type => Date
  field   :main_doc_type,         :type => String
  field   :main_doc_name,         :type => String
  field   :main_doc_date,         :type => Date
  field   :main_doc_plat,         :type => String
  field   :main_doc_paym,         :type => String
  field   :sum_003,               :type => Float,     :default => 0.00
  field   :sum_100,               :type => Float,     :default => 0.00
  field   :sum_out,               :type => Float,     :default => 0.00
  field   :sum_pay,               :type => Float,     :default => 0.00

  has_many    :freights,    :class_name => "TrstAccFreightIn",    :inverse_of => :doc
  belongs_to  :supplier,    :class_name => "TrstPartner",         :inverse_of => :qrns
  has_one     :delegate,    :class_name => "TrstPartnerDelegate", :inverse_of => :grns
  belongs_to  :unit,        :class_name => "TrstFirmUnit",        :inverse_of => :grns

  before_create :increment_name_date
  after_destroy :destroy_freights

  class << self
    # @todo
    def daily(day = nil)
      day ||= Date.today.to_s
      where(:id_date => DateTime.strptime("#{day}","%F").to_time).asc(:name)
    end
    # @todo
    def monthly(month = nil)
      year = Date.today.year
      month ||= Date.today.month
      mb = DateTime.new(year, month.to_i)
      me = DateTime.new(year, month.to_i+ 1)
      where(:id_date.gte => mb.to_time, :id_date.lt => me.to_time).asc(:name)
    end
    # @todo
    def pos(slg)
      where(:unit_id => TrstFirm.unit_id_by_unit_slug(slg)).asc(:name)
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
  def delegate
    TrstPartner.find(supplier_id).delegates.find(delegate_id)
  end
  protected
  # @todo
  def increment_name_date
    if TrstAccGrn.by_unit_id(unit_id).last.freights.empty?
      TrstAccGrn.by_unit_id(unit_id).last.destroy
    end unless TrstAccGrn.by_unit_id(unit_id).last.nil?
    self.name = TrstAccGrn.by_unit_id(unit_id).asc(:name).last.name.next rescue "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}_NIR_001"
    self.id_date = Date.today
  end
  # @todo
  def destroy_freights
    self.freights.destroy_all
  end
end
