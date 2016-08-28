# encoding: utf-8
module Trst
  class Person
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers

    field :id_pn              ,type: String
    field :name_last          ,type: String
    field :name_frst          ,type: String
    field :id_doc             ,type: Hash         ,default: {"type" => 'CI', "by" => 'SPCLEP'}
    field :email              ,type: String
    field :phone              ,type: String
    field :mobile             ,type: String
    field :other              ,type: String

    validates_presence_of   :name_last, :name_frst
    validates_uniqueness_of :id_pn, :unless => Proc.new{|p| p.id_pn == '-'}

    before_save :beautify

    class << self
      # @todo
      def auto_search(params)
        default_sort.only(:id,:id_pn,:name_last,:name_frst)
        .or(id_pn: /\A#{params[:q]}/)
        .or(name_last: /\A#{params[:q]}/i)
        .or(name_frst: /\A#{params[:q]}/i)
        .each_with_object([]){|pf,a| a << {id: pf.id.to_s,text: "#{pf.id_pn.ljust(18)} #{pf.name}"}}
      end
      # @todo
      def default_sort
        asc(:name_last,:name_frst)
      end
    end # Class methods

    # @todo
    def name(last_first = true)
      last_first ? "#{name_last} #{name_frst}" : "#{name_frst} #{name_last}"
    end
    # @todo
    def view_filter
      [id, name, id_pn]
    end
    # @todo
    def i18n_hash
      {
        id_pn: id_pn, name: name,
        city: address.city, street: address.street, nr: address.nr, bl: address.bl, sc: address.sc, et: address.et, ap: address.ap,
        dsr: id_doc["sr"], dnr: id_doc["nr"], dby: id_doc["by"], don: id_doc["on"]
      }
    end
    protected
    # @todo
    def beautify
      name_frst = name_frst.titleize if name_frst
      name_last = name_last.titleize if name_last
      id_doc['type'] = id_doc['type'].upcase if id_doc['type']
      id_doc['sr']   = id_doc['sr'].upcase if id_doc['sr']
    end
  end # Person

end # Trst
