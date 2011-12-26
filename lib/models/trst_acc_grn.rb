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

  alias :file_name :name

  has_many    :freights,      :class_name => "TrstAccFreightIn",    :inverse_of => :doc_grn
  has_many    :delivery_notes,:class_name => "TrstAccDeliveryNote", :inverse_of => :doc_grn
  belongs_to  :supplier,      :class_name => "TrstPartner",         :inverse_of => :grns
  belongs_to  :delegate,      :class_name => "TrstPartnerDelegate", :inverse_of => :grns
  belongs_to  :unit,          :class_name => "TrstFirmUnit",        :inverse_of => :grns
  belongs_to  :signed_by,     :class_name => "TrstUser",            :inverse_of => :grns

  before_create :increment_name_date
  before_destroy :destroy_freights

  class << self
    # @todo
    def daily(day = nil)
      day ||= Date.today.to_s
      where(:id_date => DateTime.strptime("#{day}","%F").to_time).asc(:name)
    end
    # @todo
    def monthly(month = nil)
      y = Date.today.year
      m = month.nil? ? Date.today.month : month.to_i
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
    def intern(firm = true)
      where(:client_id.in => TrstPartner.intern(firm).collect{|p| p.id})
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
