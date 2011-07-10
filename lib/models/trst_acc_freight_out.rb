# encoding: utf-8
=begin
#FreightOut model (Accounting)
=end

class TrstAccFreightOut
  include Mongoid::Document
  include Mongoid::Timestamps

  field :id_date,     :type => Date
  field :um,          :type => String,    :default => "kg"
  field :pu,          :type => Float,     :default => 0.00
  field :qu,          :type => Float,     :default => 0.00

  belongs_to :doc,     :class_name => "TrstAccDeliveryNote",  :inverse_of => :freights
  belongs_to :freight, :class_name => "TrstAccFreight",       :inverse_of => :outs

  before_save   :update_date

  scope :monthly, ->(m) { where(:id_date.gte => DateTime.new(Date.today.year,m).to_time, :id_date.lt => DateTime.new(Date.today.year,m + 1).to_time)}

  protected
  # @todo
  def update_date
    self.id_date = doc.id_date
  end

end
