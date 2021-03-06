# encoding: utf-8
require_relative 'cache_book_line'

module Trst
  class CacheBook
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers

    field :name,              type: String,                             default: -> {"#{Trst::PartnerFirm.find_by(firm:true).name[0][0..2]}_RC-#{Date.today.to_s.gsub("-","")}"}
    field :id_date,           type: Date,                               default: -> {Date.today}
    field :ib,                type: Float,                              default: 0.00
    field :fb,                type: Float,                              default: 0.00

    alias :file_name :name

    embeds_many :lines,       class_name: 'Trst::CacheBook::Line',      cascade_callbacks: true

    accepts_nested_attributes_for :lines,
      reject_if: ->(attrs){ attrs[:in].to_f == 0 && attrs[:out].to_f == 0},
      allow_destroy: true

    after_create  :update_following
    after_update  :update_following
    after_destroy :update_following

    class << self
    end # Class methods

    protected

    # @todo
    def update_following
      prev = self.class.where(:id_date.lt => self.id_date).asc(:id_date).last
      diff = self.changes["fb"]
      diff = (diff[1] - ( diff[0] || (prev.fb rescue 0.0))).round(2) unless diff.nil?
      diff = self.ib - self.fb if self.destroyed?
      diff ||= 0.0
      self.class.where(:id_date.gt => self.id_date).asc(:id_date).each do |cbp|
        cbp.set(ib: (cbp.ib + diff).round(2))
        cbp.set(fb: (cbp.fb + diff).round(2))
      end
    end

  end # CacheBook

  class CacheBook::Line < Trst::CacheBookLine

    embedded_in :cb,          class_name: 'Trst::CacheBook',          inverse_of: :lines

  end # CacheBookIn

end #Trst
