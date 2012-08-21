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

    # @todo
    def view_filter
      [id, name[1]]
    end
  end # Firm
end # Trst
