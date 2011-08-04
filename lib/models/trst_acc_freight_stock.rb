# encoding: utf-8
=begin
#FreightStock model (Accounting)
=end

class TrstAccFreightStock
  include Mongoid::Document
  include Mongoid::Timestamps

  field :id_month,      :type => Integer
  field :um,            :type => String,    :default => "kg"
  field :pu,            :type => Float,     :default => 0.00
  field :qu,            :type => Float,     :default => 0.00

  belongs_to :doc,     :class_name => "TrstAccStock",     :inverse_of => :freights
  belongs_to :freight, :class_name => "TrstAccFreight",   :inverse_of => :stocks

  before_save   :update_month

  class << self
    # @todo
    def monthly(month = nil)
      month ||= Date.today.month
      where(:id_month => month.to_i).asc(:freight_id)
    end
  end

  protected
  # @todo
  def update_month
    self.id_month = doc.id_month
  end
end
