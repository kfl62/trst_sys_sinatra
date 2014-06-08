# encoding: utf-8
module Trst
  class CacheBookLine
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers

    field :order,             type: Integer
    field :doc,               type: String
    field :in,                type: Float,                              default: 0.00
    field :out,               type: Float,                              default: 0.00
    field :expl,              type: String

    embedded_in :cb,          class_name: 'Trst::CacheBook',            inverse_of: :lines

    class << self
    end # Class methods

  end # CacheBookIn

end #Trst
