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

  end # Address
end #Trst
