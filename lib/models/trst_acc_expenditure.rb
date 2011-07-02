# encoding: utf-8
=begin
#Expenditure model (Accounting)
=end

class TrstAccExpenditure
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        :type => String
  field :id_date,     :type => Date,      :default => Date.today
  field :sum_003,     :type => Float,     :default => 0.00
  field :sum_016,     :type => Float,     :default => 0.00
  field :sum_100,     :type => Float,     :default => 0.00
  field :sum_out,     :type => Float,     :default => 0.00

  alias :file_name :name

  scope :daily, ->(day) { where(:id_date => DateTime.strptime("#{day}","%F").to_time)}
  scope :pos,   ->(slg) { where(:unit_id => TrstFirm.unit_id_by_unit_slug(slg))}


  has_many   :freights,   :class_name => "TrstAccFreightIn",  :inverse_of => :doc
  belongs_to :client,     :class_name => "TrstPartnersPf",    :inverse_of => :apps
  belongs_to :unit,       :class_name => "TrstFirmUnit",      :inverse_of => :apps

  before_create :increment_name
  after_destroy :destroy_freights

  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.unit_id) rescue nil
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
    self.name = TrstAccExpenditure.last.name.next rescue "DIR_CB25-000001"
  end
  # @todo
  def destroy_freights
    self.freights.destroy_all
  end
end
