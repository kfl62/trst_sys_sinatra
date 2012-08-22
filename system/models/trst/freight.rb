# encoding: utf-8
module Trst
  class Freight
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers

    field :name,        type: String,        default: "Freight"
    field :um,          type: String,        default: "kg"
    field :pu,          type: Float,         default: 0.00
    field :id_stats,    type: String

    class << self
    end # Class methods

  end # Freight
end # Trst
