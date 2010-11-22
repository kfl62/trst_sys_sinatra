# encoding: utf-8
=begin
#FirmDepartments model
=end

class TrstFirmUnit
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,                :type => Array,    :default => ["ShortName","FullName","OfficialName"]

  embedded_in :firm, :inverse_of => :units

end
