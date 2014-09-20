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

    has_many   :from_freights,class_name: "Trst::FreightOut",           inverse_of: :doc_sor
    has_many   :resl_freights,class_name: "Trst::FreightIn",            inverse_of: :doc_sor
    belongs_to :unit,         class_name: "Trst::PartnerFirm::Unit",    inverse_of: :srts
    belongs_to :signed_by,    class_name: "Trst::User",                 inverse_of: :srts

    alias :file_name :name; alias :unit :unit_belongs_to

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    accepts_nested_attributes_for :from_freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }
    accepts_nested_attributes_for :resl_freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }

    class << self
    end # Class methods

    # @todo
    def increment_name(unit_id)
      docs = self.class.by_unit_id(unit_id).yearly(Date.today.year)
      if docs.count > 0
        name = docs.asc(:name).last.name.next
      else
        unit = Trst::PartnerFirm.unit_by_unit_id(unit_id)
        prfx = Date.today.year.to_s[-2..-1]
        name = "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}_PVST-#{prfx}00001"
      end
      name
    end
    # @todo
    def freights_list
      start = [id_date.to_s,name]
      start.push(expl) if expl.length > 0
      ary = from_freights.asc(:id_stats).each_with_object(start) do |f,r|
        r << "#{f.freight.name}: #{"%.2f" % f.qu} #{f.um} ( #{"%.4f" % f.pu} )"
      end
      ary << "-"*10
      resl_freights.asc(:id_stats).each_with_object(ary) do |f,r|
         r << "#{f.freight.name}: #{"%.2f" % f.qu} #{f.um} ( #{"%.4f" % f.pu} )"
     end
    end
  end # Sorting
end # Trst
