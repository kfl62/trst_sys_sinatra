# encoding: utf-8
module Trst
  class Freight
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers

    field :name,        type: String,         default: "Freight"
    field :id_stats,    type: String
    field :um,          type: String,         default: "kg"
    field :pu,          type: Hash,           default: {dflt: 0.00}

    has_many    :ins,      class_name: "Trst::FreightIn",       inverse_of: :freight
    has_many    :outs,     class_name: "Trst::FreightOut",      inverse_of: :freight
    has_many    :stks,     class_name: "Trst::FreightStock",    inverse_of: :freight

    index({ id_stats: 1 })

    class << self
      # @todo
      def ids
        all.map(&:id)
      end
      # @todo
      def keys(u = 'dflt')
        u ? all.map{|f| "#{f.id_stats}_#{"%.4f" % (f.pu[u] rescue f.pu)}"}.uniq.sort! : \
            all.pluck(:id_stats).uniq.sort!
      end
    end # Class methods
  end # Freight
end # Trst
