# encoding: utf-8
module Trst
  class Sorting
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers
    include Trst::MainHelpers

    field :name,              type: String
    field :id_date,           type: Date,                               default: -> {Date.today}
    field :id_intern,         type: Boolean,                            default: true
    field :expl,              type: String,                             default: ''

    has_many   :from_freights, class_name: "Clns::FreightOut",          inverse_of: :doc_sor, dependent: :destroy
    has_many   :resl_freights, class_name: "Clns::FreightIn",           inverse_of: :doc_sor, dependent: :destroy
    belongs_to :unit,          class_name: "Clns::PartnerFirm::Unit",   inverse_of: :srts
    belongs_to :signed_by,     class_name: "Clns::User",                inverse_of: :srts

    alias :file_name :name; alias :unit :unit_belongs_to

    index({ unit_id: 1, id_date: 1 })

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    accepts_nested_attributes_for :from_freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }
    accepts_nested_attributes_for :resl_freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }

    class << self
    end # Class methods

    # @todo
    def increment_name(unit_id)
      sorts = Clns::Sorting.by_unit_id(unit_id).yearly(Date.today.year)
      if sorts.count > 0
        name = sorts.asc(:name).last.name.next
      else
        unit = Clns::PartnerFirm.unit_by_unit_id(unit_id)
        prfx = Date.today.year.to_s[-2..-1]
        name = "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}_PVST-#{prfx}00001"
      end
      name
    end

  end # Sorting
end # Trst
