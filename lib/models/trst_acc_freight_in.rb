# encoding: utf-8
=begin
#FreightIn model (Accounting)
=end

class TrstAccFreightIn
  include Mongoid::Document
  include Mongoid::Timestamps

  field :um,          :type => String,    :default => "kg"
  field :pu,          :type => Float,     :default => 0.00
  field :qu,          :type => Float,     :default => 0.00

  belongs_to :doc,     :class_name => "TrstAccExpenditure",   :inverse_of => :freights
  belongs_to :freight, :class_name => "TrstAccFreight",       :inverse_of => :ins
end
