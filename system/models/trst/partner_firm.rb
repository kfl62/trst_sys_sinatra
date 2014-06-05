# encoding: utf-8
module Trst
  class PartnerFirm < Trst::Firm

    field :client,            type: Boolean,                            default: true
    field :supplr,            type: Boolean,                            default: true
    field :transp,            type: Boolean,                            default: true
    field :firm,              type: Boolean,                            default: false

    embeds_many :addresses,   class_name: "Trst::PartnerFirm::Address", cascade_callbacks: true
    embeds_many :people,      class_name: "Trst::PartnerFirm::Person",  cascade_callbacks: true
    embeds_many :banks,       class_name: "Trst::PartnerFirm::Bank",    cascade_callbacks: true
    embeds_many :units,       class_name: "Trst::PartnerFirm::Unit",    cascade_callbacks: true

    accepts_nested_attributes_for :addresses, :people, :units, :banks

    class << self
      # @todo
      def unit_by_unit_id(i)
        i = Moped::BSON::ObjectId(i) if i.is_a?(String)
        find_by(:'units._id' => i).units.find(i)
      end
      # @todo
      def person_by_person_id(i)
        i = Moped::BSON::ObjectId(i) if i.is_a?(String)
        find_by(:'people._id' => i).people.find(i)
      end
      # @todo
      def unit_ids
        find_by(:firm => true).units.asc(:slug).map(&:id)
      end
      # @todo
      def pos(s)
        s = s.upcase
        find_by(:firm => true).units.find_by(:slug => s)
      end
    end # Class methods
    # @todo
    def view_filter
      [id, name[1], identities['fiscal']]
    end
  end # PartnerFirm

  class PartnerFirm::Address < Trst::Address

    field :name,              type: String,                             default: 'Main Address'

    embedded_in :firm,        class_name: 'Trst::PartnerFirm',          inverse_of: :addresses

  end # PartnerFirm::Address

  class PartnerFirm::Person < Trst::Person

    embedded_in :firm,        class_name: 'Trst::PartnerFirm',          inverse_of: :people

  end #PartnerFirm::Person

  class PartnerFirm::Bank < Trst::Bank

    embedded_in :firm,        class_name: 'Trst::PartnerFirm',          inverse_of: :banks

  end # PartnerFirm::Bank

  class PartnerFirm::Unit < Trst::Unit

    embedded_in :firm,        class_name: 'Trst::PartnerFirm',          inverse_of: :units
    has_many    :ins,         class_name: 'Trst::FreightIn',            inverse_of: :unit
    has_many    :outs,        class_name: 'Trst::FreightOut',           inverse_of: :unit
    has_many    :fsts,        class_name: 'Trst::FreightStock',         inverse_of: :unit

    # @todo
    def view_filter
      [id, name[1]]
    end
  end # PartnerFirm::Unit
end #Trst
