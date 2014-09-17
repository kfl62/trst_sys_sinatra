# encoding: utf-8
module Trst
  class Grn
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers
    include Trst::MainHelpers

    field :name,              type: String
    field :id_date,           type: Date,                               default: -> {Date.today}
    field :id_intern,         type: Boolean,                            default: false
    field :doc_type,          type: String
    field :doc_name,          type: String
    field :doc_date,          type: Date
    field :doc_plat,          type: String
    field :doc_text,          type: String
    field :sum_100,           type: Float,                              default: 0.00
    field :sum_tva,           type: Float,                              default: 0.00
    field :sum_out,           type: Float,                              default: 0.00
    field :expl,              type: String,                             default: ''
    field :charged,           type: Boolean,                            default: false

    has_many   :freights,     class_name: "Trst::FreightIn",          inverse_of: :doc_grn
    has_many   :dlns,         class_name: "Trst::DeliveryNote",       inverse_of: :doc_grn
    belongs_to :supplr,       class_name: "Trst::PartnerFirm",        inverse_of: :grns_supplr
    belongs_to :supplr_d,     class_name: "Trst::PartnerFirm::Person",inverse_of: :grns_supplr
    belongs_to :doc_inv,      class_name: "Trst::Invoice",            inverse_of: :grns
    belongs_to :unit,         class_name: "Trst::PartnerFirm::Unit",  inverse_of: :grns
    belongs_to :signed_by,    class_name: "Trst::User",               inverse_of: :grns

    alias :file_name :name; alias :unit :unit_belongs_to

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    accepts_nested_attributes_for :dlns
    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }

    class << self
      # @todo
      def charged(b = true)
        where(charged: b)
      end
      # @todo
      def auto_search(params)
        unit_id = params[:uid]
        day     = params[:day].split('-').map(&:to_i)
        where(unit_id: unit_id,id_date: Date.new(*day))
        .or(doc_name: /#{params[:q]}/i)
        .or(:supplr_id.in => Trst::PartnerFirm.only(:id).where(name: /#{params[:q]}/i).map(&:id))
        .each_with_object([]) do |g,a|
          a << {id: g.id,
                text: {
                        name:  g.name,
                        title: g.freights_list.join("\n"),
                        doc_name: g.doc_name,
                        supplier: g.supplr.name[1]}}
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
        name = "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}_NIR-#{prfx}00001"
      end
      name
    end
    # @todo
    def freights_list
      freights.asc(:id_stats).each_with_object([id_date.to_s,name]) do |f,r|
        r << expl if expl.length > 0
        r << "#{f.freight.name}: #{"%.2f" % f.qu} #{f.um} ( #{"%.4f" % f.pu} )"
      end
    end
  end # Grn
end # Trst
