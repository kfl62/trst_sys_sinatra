# encoding: utf-8
=begin
#FirmDepartments model
=end

class TrstFirmDepart
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,                :type => Array,         :default => ["ShortName","FullName"]

  embedded_in :firm, :class_name => "TrstFirm", :inverse_of => :departments

  # @todo
  def table_data
    [
      {:css => "normal",:name => "name,",:label => I18n.t("trst_firm_depart.name_sh"),:value => name[0]},
      {:css => "normal",:name => "name,",:label => I18n.t("trst_firm_depart.name_full"),:value => name[1]}
    ]
  end
end
