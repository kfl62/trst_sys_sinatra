# encoding: utf-8
=begin
#FreightIn model (Accounting)
=end

class TrstAccFreightIn
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        :type => String,    :default => "Name"
  field :um,          :type => String,    :default => "kg"
  field :quantity,    :type => Float,     :default => 0.00
  field :unit_price,  :type => Float,     :default => 0.00

  belongs_to :doc,     :class_name => "TrstAccExpenditure",    :inverse_of => :freights
end
