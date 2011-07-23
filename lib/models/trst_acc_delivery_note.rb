# encoding: utf-8
=begin
#Expenditure model (Accounting)
=end

class TrstAccDeliveryNote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,          :type => String
  field :id_date,       :type => Date,      :default => Date.today
  field :id_main_doc,   :type => String
  field :id_delegate_c, :type => String
  field :id_delegate_t, :type => String
  field :id_platte,     :type => String

  alias :file_name :name

  has_many   :freights,   :class_name => "TrstAccFreightOut", :inverse_of => :doc
  belongs_to :client,     :class_name => "TrstPartner",       :inverse_of => :delivery_notes
  belongs_to :transporter,:class_name => "TrstPartner",       :inverse_of => :delivery_pprss
  belongs_to :unit,       :class_name => "TrstFirmUnit",      :inverse_of => :delivery_notes

  before_create :increment_name
  after_destroy :destroy_freights

  scope :daily, ->(day) { where(:id_date => DateTime.strptime("#{day}","%F").to_time) }
  scope :pos,   ->(slg) { where(:unit_id => TrstFirm.unit_id_by_unit_slug(slg)) }

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
  def id_sr
    name.split('-')[0]
  end
  # @todo
  def id_nr
    name.split('-')[1]
  end
  # @todo
  def pdf_template
    'pdf'
  end

  protected
  # @todo
  def increment_name
    self.name = TrstAccDeliveryNote.where(:unit_id => unit_id).asc(:name).last.name.next rescue "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}_AEA3_001"
    self.id_main_doc = "#{TrstFirm.first.name[0][0..2].upcase}-" rescue "#{unit.firm.name[0][0..2].upcase}-"
  end
  # @todo
  def destroy_freights
    self.freights.destroy_all
  end
end
