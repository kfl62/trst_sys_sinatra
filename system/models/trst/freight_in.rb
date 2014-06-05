# encoding: utf-8
module Trst
  class FreightIn
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers
    include Trst::MainHelpers

    field :id_date,     type: Date
    field :id_stats,    type: String
    field :id_intern,   type: Boolean,   default: false
    field :qu,          type: Float,     default: 0.00
    field :pu,          type: Float,     default: 0.00
    field :val,         type: Float,     default: 0.00

    belongs_to  :freight,  class_name: 'Trst::Freight',           inverse_of: :ins, index: true
    belongs_to  :unit,     class_name: 'Trst::PartnerFirm::Unit', inverse_of: :ins, index: true

    alias :unit :unit_belongs_to

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    class << self
    end # Class methods
  end # FreightIn
end # Trst
