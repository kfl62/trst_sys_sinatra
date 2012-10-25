# encoding: utf-8
module Trst
  class Address
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers

    field :city,    type: String,   default: 'Cluj-Napoca'
    field :street,  type: String,   default: '-'
    field :nr,      type: String,   default: '-'
    field :bl,      type: String,   default: '-'
    field :sc,      type: String,   default: '-'
    field :et,      type: String,   default: '-'
    field :ap,      type: String,   default: '-'
    field :state,   type: String,   default: 'Cluj'
    field :country, type: String,   default: 'Romania'
    field :zip,     type: String,   default: '-'

    validates_presence_of   :city, :street

    before_save :beautify

    protected
    # @todo
    def beautify
      self.city    = city.titleize if city
      self.street  = street.titleize if street
      self.state   = state.titleize if state
      self.country = country.titleize if country
    end

  end # Address
end #Trst
