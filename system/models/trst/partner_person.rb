# encoding: utf-8
module Trst
  class PartnerPerson < Trst::Person

    embeds_one  :address,     class_name: 'Trst::PartnerPerson::Address', cascade_callbacks: true

    accepts_nested_attributes_for :address

  end # PartnerPerson

  class PartnerPerson::Address < Trst::Address

    field :name,              type: String,                               default: 'Domiciliu'

    embedded_in :partner_person,class_name: 'Wstm::PartnerPerson',        inverse_of: :address

  end # PartnerPerson::Address
end # Trst
