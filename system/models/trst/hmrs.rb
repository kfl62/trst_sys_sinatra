# encoding: utf-8
module Trst
  class Hmrs
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers
    include Trst::MainHelpers

    class << self
    end # Class methods

  end # Hmrs
end # Trst
