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

  has_many   :freights,   :class_name => "TrstAccFreightIn",  :inverse_of => :doc
  belongs_to :client,     :class_name => "TrstPartnersPf",    :inverse_of => :apps

  before_create :increment_name
  # @todo
  def id_sr
    name.split('-')[0]
  end
  # @todo
  def id_nr
    name.split('-')[1]
  end

  protected
  # @todo
  def increment_name
    self.name = TrstAccExpenditure.last.name.next rescue "DIR_CB52-000001"
  end
end