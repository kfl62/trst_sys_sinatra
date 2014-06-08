# encoding: utf-8
module Trst
  class Bank
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers

    field :name,            type: String
    field :swift,           type: String

    embedded_in :firm,      class_name: 'Trst::PartnerFirm',            inverse_of: :banks

    class << self
    end # Class methods

  end # Bank
end # Trst
