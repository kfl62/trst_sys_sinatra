# encoding: utf-8
module Trst
  class DeliveryNote
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers
    include Trst::MainHelpers

    field :name,              type: String
    field :id_date,           type: Date,                               default: -> {Date.today}
    field :id_intern,         type: Boolean,                            default: false
    field :doc_name,          type: String
    field :doc_plat,          type: String
    field :charged,           type: Boolean,                            default: false
    field :expl,              type: String,                             default: ''

    has_many   :freights,     class_name: "Trst::FreightOut",           inverse_of: :doc_dln
    belongs_to :doc_grn,      class_name: "Trst::Grn",                  inverse_of: :dlns
    belongs_to :doc_inv,      class_name: "Trst::Invoice",              inverse_of: :dlns
    belongs_to :client,       class_name: "Trst::PartnerFirm",          inverse_of: :dlns_client
    belongs_to :client_d,     class_name: "Trst::PartnerFirm::Person",  inverse_of: :dlns_client
    belongs_to :unit,         class_name: "Trst::PartnerFirm::Unit",    inverse_of: :dlns
    belongs_to :signed_by,    class_name: "Trst::User",                 inverse_of: :dlns

    alias :file_name :name; alias :unit :unit_belongs_to

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

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
        .or(:client_id.in => Trst::PartnerFirm.only(:id).where(name: /#{params[:q]}/i).map(&:id))
        .each_with_object([]) do |d,a|
          a << {id: d.id.to_s,
                text: {
                        name:  d.name,
                        title: d.freights_list.join("\n"),
                        doc_name: d.doc_name,
                        client:   d.client.name[1]}}
        end
      end
    end # Class methods

    # @todo
    def increment_name(unit_id)
      docs = Trst::DeliveryNote.by_unit_id(unit_id).yearly(Date.today.year)
      if docs.count > 0
        name = docs.asc(:name).last.name.next
      else
        unit = Trst::PartnerFirm.unit_by_unit_id(unit_id)
        prfx = Date.today.year.to_s[-2..-1]
        name = "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}_AEAA-#{prfx}00001"
      end
      name
    end
    # @todo
    def freights_list
      start = [id_date.to_s,name]
      start.push(expl) if expl.length > 0
      freights.asc(:id_stats).each_with_object(start) do |f,r|
        r << "#{f.freight.name}: #{"%.2f" % f.qu} #{f.um} ( #{"%.4f" % f.pu} )"
      end
    end

  end # DeliveryNote
end # Trst
