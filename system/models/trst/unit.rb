# encoding: utf-8
module Trst
  class Unit
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers

    field :main,      type: Boolean,      default: false
    field :role,      type: String
    field :name,      type: Array,        default: ['ShortName','FullName']
    field :slug,      type: String
    field :chief,     type: String,       default: 'Lastname Firstname'

    embedded_in :firm,      class_name: 'Trst::PartnerFirm',  inverse_of: :units
    has_many    :users,     class_name: 'Trst::User',         inverse_of: :unit

    # @todo
    def view_filter
      [id, name[1]]
    end
  end # Unit
end # Trst
