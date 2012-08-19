# encoding: utf-8
module Trst
  class Firm
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers

    field :name,                type: Array,         default: ['ShortName','FullName','OfficialName']
    field :identities,          type: Hash,          default: {"caen" => "xxx", "chambcom" => "J", "fiscal" => "RO", "account" => "xxx", "itm" => "xxx", "internet" => "xxx.xxx.xxx.xxx", "cod" => "XXX"}
    field :contact,             type: Hash,          default: {"phone" => "xxxx", "fax" => "xxx", "email" => "xx@xxx.xxx", "website" => "xxxx"}
    field :about,               type: Hash,          default: {"scope" => "Scope ...?...", "descript" => "Descript ...?..."}

    embeds_many :addresses,   :class_name => "Trst::FirmAddress", cascade_callbacks: true
    embeds_many :people,      :class_name => "Trst::FirmPerson",  cascade_callbacks: true

    accepts_nested_attributes_for :addresses, :people
    # @todo
    def view_filter
      [id, name[1]]
    end
  end # Firm

  class FirmAddress < Address

    field :name,    type: String,   default: 'Main Address'

    embedded_in :firm, class_name: 'Trst::Firm', inverse_of: :addresses

  end # FirmAddress

  class FirmPerson < Person

    field :role,    type: String

    embedded_in :firm, class_name: 'Trst::Firm', inverse_of: :people

  end # FirmPerson

end # Trst
