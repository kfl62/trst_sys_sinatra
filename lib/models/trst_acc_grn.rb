# encoding: utf-8
=begin
#Goods received note (Accounting)
=end

class TrstAccGrn
  include Mongoid::Document
  include Mongoid::Timestamps

  field   :name,                  :type => String
  field   :id_date,               :type => Date
  field   :id_intern,             :type => Boolean,   :default => false
  field   :main_doc_type,         :type => String
  field   :main_doc_name,         :type => String
  field   :main_doc_date,         :type => Date
  field   :main_doc_plat,         :type => String
  field   :main_doc_paym,         :type => String
  field   :sum_003,               :type => Float,     :default => 0.00
  field   :sum_100,               :type => Float,     :default => 0.00
  field   :sum_out,               :type => Float,     :default => 0.00
  field   :sum_pay,               :type => Float,     :default => 0.00

  alias :file_name :name

  has_many    :freights,      :class_name => "TrstAccFreightIn",    :inverse_of => :doc_grn
  has_many    :delivery_notes,:class_name => "TrstAccDeliveryNote", :inverse_of => :doc_grn
  belongs_to  :supplier,      :class_name => "TrstPartner",         :inverse_of => :grns
  belongs_to  :delegate,      :class_name => "TrstPartnerDelegate", :inverse_of => :grns
  belongs_to  :unit,          :class_name => "TrstFirmUnit",        :inverse_of => :grns
  belongs_to  :signed_by,     :class_name => "TrstUser",            :inverse_of => :grns

  before_create  :increment_name_date
  before_destroy :destroy_freights

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
      me = m.to_i == 12 ? DateTime.new(y + 1, 1) : DateTime.new(y, m + 1)
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
     # todo
    def nin(nin = true)
      where(:id_intern => !nin)
    end
    # @todo
    def to_txt
      all.each{|grn| p "#{grn.name} --- #{grn.id_date.to_s} --- #{grn.supplier.name[1]}"}
    end
  end # Class methods

  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.unit_id) rescue nil
  end
  # @todo
  def delegate
    TrstPartner.find(self.supplier_id).delegates.find(self.delegate_id)
  end
  # @todo
  def pdf_template
    'pdf'
  end
  # @todo
  def freights_list
    self.freights.asc(:id_stats).each_with_object([]) do |f,r|
      r << "#{f.freight.name}: #{"%.2f" % f.qu} kg ( #{"%.2f" % f.pu} )"
    end
  end
  # @todo
  def i18n_hash
    {
      supplier: supplier.name[2],
      doc_name: main_doc_name, doc_date: main_doc_date,
      delegate: delegate.name, platte: main_doc_plat.upcase,
      signed_by: signed_by.name
    }
  end
  # @todo
  def update_delivery_notes(add = true)
    self.delivery_notes.each do |dn|
      dn.update_attribute(:charged, add)
    end
  end

  protected
  # @todo
  def increment_name_date
    if TrstAccGrn.by_unit_id(unit_id).last.freights.empty?
      TrstAccGrn.by_unit_id(unit_id).last.destroy
    end unless TrstAccGrn.by_unit_id(unit_id).last.nil?
    self.name = TrstAccGrn.by_unit_id(unit_id).asc(:name).last.name.next rescue "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}_NIR_001"
    self.id_date = Date.today
    self.id_intern = true if supplier.firm
  end
  # @todo
  def destroy_freights
    self.update_delivery_notes(false)
    self.freights.destroy_all
  end
end
