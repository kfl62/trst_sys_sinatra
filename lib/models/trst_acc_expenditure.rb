# encoding: utf-8
=begin
#Expenditure model (Accounting)
=end

class TrstAccExpenditure
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        :type => String,    :default => "DIR_CB25-000000"
  field :id_date,     :type => Time,      :default => Time.now()
  field :sum_003,     :type => Float,     :default => 0.00
  field :sum_016,     :type => Float,     :default => 0.00
  field :sum_100,     :type => Float,     :default => 0.00

  has_many   :freights,   :class_name => "TrstAccFreightIn",  :inverse_of => :doc
  belongs_to :client,     :class_name => "TrstPartnersPf",    :inverse_of => :apps
  # @todo
  def id_sr
    name.split('-')[0]
  end
  # @todo
  def id_nr
    name.split('-')[1]
  end

end
