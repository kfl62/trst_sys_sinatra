# encoding: utf-8
=begin
#FreightIn model (Accounting)
=end

class TrstAccFreightIn
  include Mongoid::Document
  include Mongoid::Timestamps

  field :id_date,     :type => Date
  field :um,          :type => String,    :default => "kg"
  field :pu,          :type => Float,     :default => 0.00
  field :qu,          :type => Float,     :default => 0.00

  belongs_to :doc,     :class_name => "TrstAccExpenditure",   :inverse_of => :freights
  belongs_to :freight, :class_name => "TrstAccFreight",       :inverse_of => :ins

  before_save   :update_date

  scope :monthly, ->(m)  { where(:id_date.gte => DateTime.new(Date.today.year,m).to_time, :id_date.lt => DateTime.new(Date.today.year,m + 1).to_time)}
  scope :pn,      ->(pn) { where(:doc_id.in => TrstAccExpenditure.pn(pn).map{|e| e.id}) }
  protected
  # @todo
  def update_date
    self.id_date = doc.id_date
  end

end
