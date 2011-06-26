# encoding: utf-8
=begin
#Expenditure model (Accounting)
=end

class TrstAccExpenditure
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        :type => String
  field :id_date,     :type => Date,      :default => Date.today

  has_many   :freights,   :class_name => "TrstAccFreightOut", :inverse_of => :doc
  belongs_to :client,     :class_name => "TrstPartners",      :inverse_of => :apps
end