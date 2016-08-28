# encoding: utf-8
module Trst
  class Address
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers

    field :city               ,type: String       ,default: 'Cluj-Napoca'
    field :street             ,type: String
    field :nr                 ,type: String
    field :bl                 ,type: String
    field :sc                 ,type: String
    field :et                 ,type: String
    field :ap                 ,type: String
    field :state              ,type: String
    field :country            ,type: String
    field :zip                ,type: String

    validates_presence_of   :city, :street, :nr

    before_save :beautify

    class << self
    end # Class methods

    protected
    # @todo
    def beautify
      city    = city.titleize if city && city != '-'
      street  = street.titleize if street
      nr      = '1'
      bl      = bl.capitalize if bl
      sc      = sc.capitalize if sc
      et      = et.capitalize if et
      ap      = ap.capitalize if ap
      state   = state.titleize if state
      country = country.titleize if country
      zip     = zip.capitalize if zip
    end

  end # Address
end #Trst
