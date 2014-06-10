# encoding: utf-8
require './system/models/trst/freight'
module Trst
  class Invoice
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers
    include Trst::MainHelpers

    field :name,              type: String
    field :id_date,           type: Date,                               default: -> {Date.today}
    field :id_intern,         type: Boolean,                            default: false
    field :doc_name,          type: String
    field :sum_100,           type: Float,                              default: 0.00
    field :sum_tva,           type: Float,                              default: 0.00
    field :sum_out,           type: Float,                              default: 0.00
    field :deadl,             type: Date,                               default: -> {Date.today}
    field :payed,             type: Boolean,                            default: false
    field :expl,              type: String,                             default: ''

    embeds_many :freights,     class_name: "Trst::InvoiceFreight",      inverse_of: :doc_inv, cascade_callbacks: true
    has_many    :dlns,         class_name: "Trst::DeliveryNote",        inverse_of: :doc_inv
    has_many    :grns,         class_name: "Trst::Grn",                 inverse_of: :doc_inv
    has_many    :pyms,         class_name: "Trst::Payment",             inverse_of: :doc_inv, dependent: :delete
    belongs_to  :client,       class_name: "Trst::PartnerFirm",         inverse_of: :invs_client
    belongs_to  :client_d,     class_name: "Trst::PartnerFirm::Person", inverse_of: :invs_client
    belongs_to  :signed_by,    class_name: "Trst::User",                inverse_of: :invs

    alias :file_name :name

    accepts_nested_attributes_for :dlns, :grns
    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }
    accepts_nested_attributes_for :pyms,
      reject_if: ->(attrs){ attrs[:val].empty? }

    class << self
      # @todo
      def auto_search(params)
        day = params[:day].split('-').map(&:to_i)
        where(id_date: Date.new(*day))
        .or(doc_name: /#{params[:q]}/i)
        .or(:client_id.in => Trst::PartnerFirm.only(:id).where(name: /#{params[:q]}/i).map(&:id))
        .each_with_object([]) do |i,a|
          a << {id: i.id,
                text: {
                        name:  i.name,
                        title: i.freights_list.join("\n"),
                        doc_name: i.doc_name,
                        client:   i.client.name[1]}}
        end
      end
    end # Class methods

    # @todo
    def client_d
      Trst::PartnerFirm.person_by_person_id(client_d_id) rescue nil
    end
    # @todo
    def increment_name(unit_id)
      docs = self.class.by_unit_id(unit_id).yearly(Date.today.year)
      if docs.count > 0
        name = docs.asc(:name).last.name.next
      else
        unit = Trst::PartnerFirm.unit_by_unit_id(unit_id)
        prfx = Date.today.year.to_s[-2..-1]
        name = "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}_INV-#{prfx}00001"
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
  end # Invoice

  class InvoiceFreight < Trst::Freight
    field :qu,                type: Float,                              default: 0.00
    # temproray solutioin, @todo  convert to Hash
    field       :pu,          type: Float,                              default: 0.0

    embedded_in :doc_inv,     class_name: "Trst::Invoice",              inverse_of: :freights

  end # InvoiceFreight

end # Trst
