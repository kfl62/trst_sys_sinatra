# encoding: utf-8
=begin
#Firm model
=end

class TrstFirm
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,                :type => Array,         :default => ["ShortName","FullName","OfficialName"]
  field :identities,          :type => Hash,          :default => {:caen => "xxx",:chambcom => "Jxx/xxx/xxx",:fiscal => "ROxxx",:account => "xxx",:itm => "xxx",:internet => "xxx.xxx.xxx.xxx",:cod => "XXX"}
  field :contact,             :type => Hash,          :default => {:phone => "xxxx",:fax => "xxx",:email => "xx@xxx.xxx",:website => "xxxx"}
  field :about,               :type => Hash,          :default => {:scope => "Scope ...?...", :descript => "Descript ...?..."}

  embeds_many :addresses,   :class_name => "TrstFirmAddress"
  embeds_many :persons,     :class_name => "TrstFirmContactPerson"
  embeds_many :departments, :class_name => "TrstFirmDepart"
  embeds_many :units,       :class_name => "TrstFirmUnit"

  def details
    self.addresses.create if self.addresses.empty?
    self.persons.create if self.persons.empty?
    ["TrstFirm",id,[addresses,persons]]
  end

  def table_data
    [{:css => "normal",:name => "name,",:label => I18n.t("trst_firm.name_sh"),:value => name[0]},
     {:css => "normal",:name => "name,",:label => I18n.t("trst_firm.name_full"),:value => name[1]},
     {:css => "normal",:name => "name,",:label => I18n.t("trst_firm.name_off"),:value => name[2]},
     {:css => "normal",:name => "identities,caen",:label => I18n.t("trst_firm.identities.caen"),:value => identities["caen"]},
     {:css => "normal",:name => "identities,chambcom",:label => I18n.t("trst_firm.identities.chambcom"),:value => identities["chambcom"]},
     {:css => "normal",:name => "identities,fiscal",:label => I18n.t("trst_firm.identities.fiscal"),:value => identities["fiscal"]},
     {:css => "normal",:name => "identities,account",:label => I18n.t("trst_firm.identities.account"),:value => identities["account"]},
     {:css => "normal",:name => "identities,itm",:label => I18n.t("trst_firm.identities.itm"),:value => identities["itm"]},
     {:css => "normal",:name => "identities,internet",:label => I18n.t("trst_firm.identities.internet"),:value => identities["internet"]},
     {:css => "normal",:name => "identities,cod",:label => I18n.t("trst_firm.identities.cod"),:value => identities["cod"]},
     {:css => "normal",:name => "contact,phone",:label => I18n.t("trst_firm.contact.phone"),:value => contact["phone"]},
     {:css => "normal",:name => "contact,fax",:label => I18n.t("trst_firm.contact.fax"),:value => contact["fax"]},
     {:css => "normal",:name => "contact,email",:label => I18n.t("trst_firm.contact.email"),:value => contact["email"]},
     {:css => "normal",:name => "contact,website",:label => I18n.t("trst_firm.contact.website"),:value => contact["website"]},
     {:css => "normal",:name => "about,scope",:label => I18n.t("trst_firm.about.scope"),:value => about["scope"]},
     {:css => "normal",:name => "about,descript",:label => I18n.t("trst_firm.about.descript"),:value => about["descript"]}]
  end

end

