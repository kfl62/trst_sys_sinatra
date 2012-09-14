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
      # @todo
      def ids
        all.map(&:id)
      end
      # @todo
      def keys(pu = true)
        ks = all.each_with_object([]){|f,k| k << "#{f.id_stats}"}.uniq.sort!
        ks = all.each_with_object([]){|f,k| k << "#{f.id_stats}_#{"%05.2f" % f.pu}"}.uniq.sort! if pu
        ks
      end
    end # Class methods
  end # Freight
end # Trst
