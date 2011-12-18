# encoding: utf-8
=begin
#FirmDelegate model
=end

class TrstFirmDelegate
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,    :default => "FirstName LastName"
  field :role,    :default => "Delegat"
  field :id_pn,   :default => "1620824264374"
  field :id_sr,   :default => "KX"
  field :id_nr,   :default => "123456"
  field :id_by,   :default => "SPCLEP Cluj-Napoca"
  field :id_on,   :default => "21.12.2008"
  field :phone,   :default => "+40-264-406440"

  embedded_in :trst_firm, :class_name => "TrstFirm", :inverse_of => :delegates

  def table_data
    [
      {:css => "normal",:name => "name",:label => I18n.t("trst_firm_delegate.name"),:value => name},
      {:css => "normal",:name => "role",:label => I18n.t("trst_firm_delegate.role"),:value => role},
      {:css => "normal",:name => "id_pn",:label => I18n.t("trst_firm_delegate.id_pn"),:value => id_pn},
      {:css => "normal",:name => "id_sr",:label => I18n.t("trst_firm_delegate.id_sr"),:value => id_sr},
      {:css => "normal",:name => "id_nr",:label => I18n.t("trst_firm_delegate.id_nr"),:value => id_nr},
      {:css => "normal",:name => "id_by",:label => I18n.t("trst_firm_delegate.id_by"),:value => id_by},
      {:css => "normal",:name => "id_on",:label => I18n.t("trst_firm_delegate.id_on"),:value => id_on},
      {:css => "normal",:name => "phone",:label => I18n.t("trst_firm_delegate.phone"),:value => phone}
   ]
  end

end
