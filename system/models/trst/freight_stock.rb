# encoding: utf-8
module Trst
  class FreightStock
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

    belongs_to  :freight,     class_name: 'Trst::Freight',              inverse_of: :stks, index: true
    belongs_to  :unit,        class_name: 'Trst::PartnerFirm::Unit',    inverse_of: :fsts, index: true
    belongs_to  :doc_stk,     class_name: 'Trst::Stock',                inverse_of: :freights, index: true

    alias :unit :unit_belongs_to; alias :name :freight_name; alias :um :freight_um

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}
    scope :stock_now,  ->()        {where(id_date: Date.new(2000,1,31))}

    class << self
    end # Class methods

    # @todo
    def key
      "#{id_stats}_#{"%.4f" % pu}"
    end
  end # FreightStock
end # Trst
