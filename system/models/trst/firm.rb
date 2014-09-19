# encoding: utf-8
module Trst
  class Firm
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers

    field :name,              type: Array,                              default: ['ShortName','FullName','OfficialName']
    field :identities,        type: Hash,                               default: {"caen" => "xxx", "chambcom" => "J", "fiscal" => "RO", "account" => "xxx", "itm" => "xxx", "internet" => "xxx.xxx.xxx.xxx", "cod" => "XXX"}
    field :contact,           type: Hash,                               default: {"phone" => "xxxx", "fax" => "xxx", "email" => "xx@xxx.xxx", "website" => "xxxx"}
    field :about,             type: Hash,                               default: {"scope" => "Scope ...?...", "descript" => "Descript ...?..."}

    validate :'identities_fiscal_uniq'

    class << self
      # @todo
      def auto_search(params)
        if params[:w]
          default_sort.where(params[:w].to_sym => true)
          .and(name: /\A#{params[:q]}/i)
          .each_with_object([]){|pf,a| a << {id: pf.id.to_s,text: "#{pf.name[0][0..20]}"}}
        elsif params[:id]
          find(params[:id]).people.asc(:name_last).each_with_object([]){|d,a| a << {id: d.id.to_s,text: "#{d.name[0..20]}"}}.push({id: 'new',text: 'Adăugare delegat'})
        else
          default_sort.only(:id,:name,:identities)
          .or(name: /\A#{params[:q]}/i)
          .or(:'identities.fiscal' => /\A#{params[:q]}/i)
          .each_with_object([]){|pf,a| a << {id: pf.id.to_s,text: "#{pf.identities['fiscal'].ljust(18)} #{pf.name[1]}"}}
        end
      end
    end # Class methods

    # @todo
    def view_filter
      [id, name[1]]
    end

    protected

    # @todo
    def identities_fiscal_uniq
      return if !identities.key?('fiscal')
      if self.class.find_by(:'identities.fiscal' => /#{Regexp.escape(identities['fiscal'])}/i) && new_record?
        self.errors.add(:'identities.fiscal', :taken)
      end
    end
  end # Firm
end # Trst
