# encoding: utf-8
module Trst
  class Stock
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers
    include Trst::MainHelpers

    field :name,              type: String
    field :id_date,           type: Date
    field :expl,              type: String,                             default: 'Stock initial'

    has_many   :freights,     class_name: "Trst::FreightStock",         :inverse_of => :doc_stk
    belongs_to :unit,         class_name: "Trst::PartnerFirm::Unit",    :inverse_of => :stks

    alias :file_name :name; alias :unit :unit_belongs_to

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 && attrs[:pu].to_f == 0 },
      allow_destroy: true

    class << self
    end # Class methods

    # @todo
    def keys
      freights.keys
    end
   end # Stock
end #Trst
