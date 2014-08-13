# encoding: utf-8
module Trst
  class Expenditure
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers
    include Trst::MainHelpers

    field :name,              type: String
    field :id_date,           type: Date,                               default: -> {Date.today}
    field :id_intern,         type: Boolean,                            default: false
    field :sum_003,           type: Float,                              default: 0.00
    field :sum_016,           type: Float,                              default: 0.00
    field :sum_100,           type: Float,                              default: 0.00
    field :sum_out,           type: Float,                              default: 0.00
    field :expl,              type: String,                             default: ''

    alias :file_name :name; alias :unit :unit_belongs_to

    has_many   :freights,     class_name: "Trst::FreightIn",            inverse_of: :doc_exp
    belongs_to :unit,         class_name: "Trst::PartnerFirm::Unit",    inverse_of: :apps, index: true
    belongs_to :client,       class_name: "Trst::PartnerPerson",        inverse_of: :apps, index: true
    belongs_to :signed_by,    class_name: "Trst::User",                 inverse_of: :apps

    index({ unit_id: 1, id_date: 1 })

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 || attrs[:id_date].empty?}

    class << self
      # @todo
      def to_txt
        all.asc(:name).each{|app| p "#{app.name} --- #{app.id_date.to_s} #{app.updated_at.strftime("%H:%M")} --- #{("%.2f" % app.sum_out).rjust(8)}"}
      end
      # @todo
      def auto_search(params)
        unit_id = params[:uid]
        day     = params[:day].split('-').map(&:to_i)
        where(unit_id: unit_id,id_date: Date.new(*day),name: /#{params[:q]}/i).asc(:name).each_with_object([]) do |e,a|
          a << {id: e.id,
                text: {
                        name:  e.name,
                        title: e.freights_list.join("\n"),
                        time:  e.updated_at.strftime("%H:%M"),
                        val:   "%.2f" % e.sum_100,
                        out:   "%.2f" % e.sum_out}}
        end
      end
    end # Class methods

    # @todo
    def increment_name(unit_id)
      docs = self.class.by_unit_id(unit_id).yearly(Date.today.year)
      if docs.count > 0
        name = docs.asc(:name).last.name.next
      else
        unit = Trst::PartnerFirm.unit_by_unit_id(unit_id)
        prfx = Date.today.year.to_s[-2..-1]
        name = "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}-#{prfx}00001"
      end
      name
    end
    # @todo
    def freights_list
      freights.asc(:id_stats).each_with_object([]) do |f,r|
        r << "#{f.freight.name}: #{"%.2f" % f.qu} kg ( #{"%.2f" % f.pu} )"
      end
    end

  end # Expenditure
end # Trst
