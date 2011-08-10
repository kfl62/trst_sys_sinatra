# encoding: utf-8
=begin
#Expenditure model (Accounting)
=end

class TrstAccDeliveryNote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,          :type => String
  field :id_date,       :type => Date
  field :id_main_doc,   :type => String
  field :id_delegate_c, :type => String
  field :id_delegate_t, :type => String
  field :id_platte,     :type => String

  alias :file_name :name

  has_many   :freights,   :class_name => "TrstAccFreightOut", :inverse_of => :doc
  belongs_to :client,     :class_name => "TrstPartner",       :inverse_of => :delivery_notes
  belongs_to :transporter,:class_name => "TrstPartner",       :inverse_of => :delivery_pprss
  belongs_to :unit,       :class_name => "TrstFirmUnit",      :inverse_of => :delivery_notes

  before_create :increment_name_date
  after_destroy :destroy_freights

  class << self
    # @todo
    def pos(slg)
      where(:unit_id => TrstFirm.unit_id_by_unit_slug(slg)).asc(:name)
    end
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
      me = DateTime.new(year, month.to_i + 1)
      where(:id_date.gte => mb.to_time, :id_date.lt => me.to_time).asc(:name)
    end
    # @todo
    def by_unit_id(u)
      where(:unit_id => u).asc(:name)
    end
    # @todo
    def to_txt
      all.each{|dn| p "#{dn.name} --- #{dn.id_main_doc} --- #{dn.id_date.to_s}"}
    end
  end

  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.unit_id) rescue nil
  end
  # @todo
  def delegate_transp
    TrstPartner.find(transporter_id).delegates.find(id_delegate_t) rescue TrstPartner.find(transporter_id).delegates.first
  end
  # @todo
  def delegate_client
    TrstPartner.find(client_id).delegates.find(id_delegate_c) rescue TrstPartner.find(client_id).delegates.first
  end
  # @todo
  def pdf_template
    'pdf'
  end

  protected
  # @todo
  def increment_name_date
    if TrstAccDeliveryNote.by_unit_id(unit_id).last.freights.empty?
      TrstAccDeliveryNote.by_unit_id(unit_id).last.destroy
    end unless TrstAccDeliveryNote.by_unit_id(unit_id).last.nil?
    self.name = TrstAccDeliveryNote.where(:unit_id => unit_id).asc(:name).last.name.next rescue "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}_AEA3_001"
    self.id_main_doc = "#{TrstFirm.first.name[0][0..2].upcase}-" rescue "#{unit.firm.name[0][0..2].upcase}-"
    self.id_date = Date.today
  end
  # @todo
  def destroy_freights
    self.freights.destroy_all
  end
end
