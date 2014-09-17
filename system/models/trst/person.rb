# encoding: utf-8
module Trst
  class Person
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers

    field :id_pn,             type: String,                             default: '123456789012'
    field :name_last,         type: String,                             default: 'LastName'
    field :name_frst,         type: String,                             default: 'FirstName'
    field :id_doc,            type: Hash,                               default: {"type" => 'CI', "sr" => 'KX', "nr" => '123456', "by" => 'SPCLEP Cluj-Napoca', "on" => '1980-01-01'}
    field :email,             type: String,                             default: '-'
    field :phone,             type: String,                             default: '-'
    field :mobile,            type: String,                             default: '-'
    field :other,             type: String,                             default: 'Client'

    validates_presence_of   :name_last, :name_frst
    validates_uniqueness_of :id_pn, :unless => Proc.new{|p| p.id_pn == '-'}

    before_save :beautify

    class << self
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
      self.name_frst = name_frst.titleize if name_frst
      self.name_last = name_last.titleize if name_last
      self.id_doc['type'] = id_doc['type'].upcase if id_doc['type']
      self.id_doc['sr']   = id_doc['sr'].upcase if id_doc['sr']
    end
  end # Person

end # Trst
