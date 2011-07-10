# encoding: utf-8
=begin
#FreightStock model (Accounting)
=end

class TrstAccFreightStock
  include Mongoid::Document
  include Mongoid::Timestamps

  field :id_month,      :type => Integer
  field :qu,            :type => Float,     :default => 0.00
  field :expl,          :type => String,    :default => "Calculated"

  belongs_to :doc,     :class_name => "TrstAccStock",     :inverse_of => :freights
  belongs_to :freight, :class_name => "TrstAccFreight",   :inverse_of => :stocks

  before_save   :update_month

  scope :monthly, ->(m) { where(:id_month => m) }

  protected
  # @todo
  def update_month
    self.id_month = doc.id_month
  end
end
