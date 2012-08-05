# encoding: utf-8
module Trst
  class Person
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers

    field :name_last,   type: String, default: 'LastName'
    field :name_frst,   type: String, default: 'FirstName'
    field :id_pn,       type: String, default: '123456789012'
    field :id_doc,      type: Hash,   default: {"type" => 'CI', "sr" => 'KX', "nr" => '123456', "by" => 'SPCLEP Cluj-Napoca', "on" => '1980-01-01'}
    field :phone,       type: String, default: '+40-000-000000'
    field :email,       type: String, default: 'email@example.com'
    field :other,       type: String, default: 'Alte date'

    validates_presence_of   :name_last, :name_frst
    validates_uniqueness_of :id_pn

    # @todo
    def name(last_first = true)
      last_first ? "#{name_last} #{name_frst}" : "#{name_first} #{name_last}"
    end
  end # Person
end # Trst