# encoding: utf-8
=begin
#Firm model
=end

class TrstFirm
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,                :type => Array,         :default => ["ShortName","FullName","OfficialName"]
  field :identities,          :type => Hash,          :default => {:chambcom => "Jxx/xxx/xxx", :fiscal => "ROxxx",:account => "xxx", :itm => "xxx", :internet => "xxx.xxx.xxx.xxx", :cod => "XXX"}
  field :address,             :type => Hash,          :default => {:street => "xxx", :city => "xxx", :state => "XX", :country => "RO", :zip => "xxx"}
  field :about,               :type => Hash,          :default => {:caen => "xxx", :scope => "Scope ...?...", :descript => "Descript ...?..."}

  embeds_many :departments, :class_name => "TrstFirmDepart"
  embeds_many :units,       :class_name => "TrstFirmUnit"

end
