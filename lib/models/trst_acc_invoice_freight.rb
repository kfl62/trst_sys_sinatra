# encoding: utf-8
=begin
#InvoiceFreights (Accounting)
=end

class TrstAccInvoiceFreight
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        :type => String
  field :um,          :type => String,    :default => "kg"
  field :id_stats,    :type => String
  field :pu,          :type => Float,     :default => 0.00
  field :qu,          :type => Float,     :default => 0.00

  embedded_in :invoice,   :class_name => "TrstAccInvoice", :inverse_of => :freights
end
