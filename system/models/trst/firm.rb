# encoding: utf-8
module Trst
  class Firm
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers

    field :name,                type: Array,         default: ['ShortName','FullName','OfficialName']
    field :identities,          type: Hash,          default: {"caen" => "xxx", "chambcom" => "J", "fiscal" => "RO", "account" => "xxx", "itm" => "xxx", "internet" => "xxx.xxx.xxx.xxx", "cod" => "XXX"}
    field :contact,             type: Hash,          default: {"phone" => "xxxx", "fax" => "xxx", "email" => "xx@xxx.xxx", "website" => "xxxx"}
    field :about,               type: Hash,          default: {"scope" => "Scope ...?...", "descript" => "Descript ...?..."}

    validate :'identities_fiscal_uniq'

    # @todo
    def view_filter
      [id, name[1]]
    end

    protected

    # @todo
    def identities_fiscal_uniq
      return if !identities.key?('fiscal')
      if self.class.where(:'identities.fiscal' => /#{Regexp.escape(identities['fiscal'])}/i) && new_record?
        self.errors.add(:'identities.fiscal', :taken)
      end
    end
  end # Firm
end # Trst
