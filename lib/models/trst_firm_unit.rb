# encoding: utf-8
=begin
#FirmDepartments model
=end

class TrstFirmUnit
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,          :type => Array,     :default => ["ShortName","FullName"]
  field :chief,         :type => String,    :default => "Lastname Firstname"

  embedded_in :firm, :class_name => "TrstFirm", :inverse_of => :units
  has_one :user,     :class_name => "TrstUser", :inverse_of => :unit

  # @todo
  def table_data
    [
      {:css => "normal",:name => "name,",:label => I18n.t("trst_firm.name_sh"),:value => name[0]},
      {:css => "normal",:name => "name,",:label => I18n.t("trst_firm.name_full"),:value => name[1]},
      {:css => "normal",:name => "chief",:label => I18n.t("trst_firm.chief"),:value => chief}
    ]
  end
end
