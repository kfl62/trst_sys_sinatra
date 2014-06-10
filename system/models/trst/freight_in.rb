# encoding: utf-8
module Trst
  class FreightIn
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers
    include Trst::MainHelpers

    field :id_date,           type: Date
    field :id_stats,          type: String
    field :id_intern,         type: Boolean,                            default: false
    field :qu,                type: Float,                              default: 0.00
    field :pu,                type: Float,                              default: 0.00
    field :val,               type: Float,                              default: 0.00

    belongs_to  :freight,     class_name: 'Trst::Freight',              inverse_of: :ins, index: true
    belongs_to  :unit,        class_name: 'Trst::PartnerFirm::Unit',    inverse_of: :ins, index: true
    belongs_to  :doc_exp,     class_name: 'Trst::Expenditure',          inverse_of: :freights, index: true
    belongs_to  :doc_grn,     class_name: 'Trst::Grn',                  inverse_of: :freights, index: true
    belongs_to  :doc_sor,     class_name: 'Trst::Sorting',              inverse_of: :resl_freights  #, index: true

    alias :unit :unit_belongs_to; alias :name :freight_name; alias :um :freight_um

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    class << self
    end # Class methods

    # @todo
    def key
      "#{id_stats}_#{"%.4f" % pu}"
    end
  end # FreightIn
end # Trst
