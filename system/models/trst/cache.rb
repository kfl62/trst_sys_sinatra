# encoding: utf-8
module Trst
  class Cache
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers
    include DateHelpers
    include Trst::MainHelpers

    field   :name,            type: String,                             default: -> {"DP_NR-#{Date.today.to_s}"}
    field   :id_date,         type: Date,                               default: -> {Date.today}
    field   :money_in,        type: Float,                              default: 0.0
    field   :money_out,       type: Float,                              default: 0.0
    field   :money_stock,     type: Float,                              default: 0.0

    alias :unit :unit_belongs_to

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    class << self
    end # Class methods

  end # Cache
end # Trst
