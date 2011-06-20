# encoding: utf-8
=begin
#FirmContactPerson model
=end

class TrstFirmContactPerson
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,    :default => "FirstName LastName"
  field :role,    :default => "Administrator"
  field :id_pn,   :default => "1620824264374"
  field :id_sr,   :default => "KX"
  field :id_nr,   :default => "123456"
  field :id_by,   :default => "SPCLEP Cluj-Napoca"
  field :id_on,   :default => "21.12.2008"
  field :phone,   :default => "+40-264-406440"
  field :email,   :default => "some@adress.com"
  field :other,   :default => "Alte date..."

  embedded_in :trst_firm, :inverse_of => :persons

  def table_data
    [{:css => "normal",:name => "name",:label => I18n.t("trst_firm_contact_person.name"),:value => name},
     {:css => "normal",:name => "role",:label => I18n.t("trst_firm_contact_person.role"),:value => role},
     {:css => "normal",:name => "id_pn",:label => I18n.t("trst_firm_contact_person.id_pn"),:value => id_pn},
     {:css => "normal",:name => "id_sr",:label => I18n.t("trst_firm_contact_person.id_sr"),:value => id_sr},
     {:css => "normal",:name => "id_nr",:label => I18n.t("trst_firm_contact_person.id_nr"),:value => id_nr},
     {:css => "normal",:name => "id_by",:label => I18n.t("trst_firm_contact_person.id_by"),:value => id_by},
     {:css => "normal",:name => "id_on",:label => I18n.t("trst_firm_contact_person.id_on"),:value => id_on},
     {:css => "normal",:name => "phone",:label => I18n.t("trst_firm_contact_person.phone"),:value => phone},
     {:css => "normal",:name => "other",:label => I18n.t("trst_firm_contact_person.other"),:value => other}]
  end

end
