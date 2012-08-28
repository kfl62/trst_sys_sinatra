# encoding: utf-8
module Trst
  class Cache
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers
    include DateHelpers

    field   :name,        type: String
    field   :id_date,     type: Date,     default: -> {Date.today}
    field   :money_in,    type: Float,    default: 0.0
    field   :money_out,   type: Float,    default: 0.0
    field   :money_stock, type: Float,    default: 0.0

    class << self
    end # Class methods

  end # Cache
end # Trst
