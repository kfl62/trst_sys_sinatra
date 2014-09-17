# encoding: utf-8
module Trst
  class Unit
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers

    field :main,              type: Boolean,                            default: false
    field :role,              type: String
    field :name,              type: Array,                              default: ['ShortName','FullName']
    field :slug,              type: String
    field :chief,             type: String,                             default: 'Lastname Firstname'

    embedded_in :firm,        class_name: 'Trst::PartnerFirm',          inverse_of: :units
    has_many    :users,       class_name: 'Trst::User',                 inverse_of: :unit
    has_many    :freights,    class_name: 'Trst::Freight',              inverse_of: :unit
    has_many    :dps,         class_name: 'Trst::Cache',                inverse_of: :unit
    has_many    :apps,        class_name: 'Trst::Expenditure',          inverse_of: :unit
    has_many    :stks,        class_name: 'Trst::Stock',                inverse_of: :unit
    has_many    :dlns,        class_name: 'Trst::DeliveryNote',         inverse_of: :unit
    has_many    :grns,        class_name: 'Trst::Grn',                  inverse_of: :unit
    has_many    :csss,        class_name: 'Trst::Cassation',            inverse_of: :unit
    has_many    :srts,        class_name: 'Trst::Sorting',              inverse_of: :unit
    has_many    :ins,         class_name: 'Trst::FreightIn',            inverse_of: :unit
    has_many    :outs,        class_name: 'Trst::FreightOut',           inverse_of: :unit
    has_many    :fsts,        class_name: 'Trst::FreightStock',         inverse_of: :unit

    # @todo
    def view_filter
      [id, name[1]]
    end
  end # Unit
end # Trst
