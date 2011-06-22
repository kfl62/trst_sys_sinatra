# encoding: utf-8
=begin
#Partners model
=end

class TrstPartners
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,                :type => Array,         :default => ["ShortName","FullName","OfficialName"]
  field :identities,          :type => Hash,          :default => {:chambcom => "Jxx/xxx/xxx", :fiscal => "ROxxx",:account => "xxx", :itm => "xxx", :internet => "xxx.xxx.xxx.xxx", :cod => "XXX"}
  field :address,             :type => Hash,          :default => {:street => "xxx", :city => "xxx", :state => "XX", :country => "RO", :zip => "xxx"}
  field :about,               :type => Hash,          :default => {:caen => "xxx", :scope => "Scope ...?...", :descript => "Descript ...?..."}

  def table_data
    [{:css => "normal",:name => "name,",:label => I18n.t("trst_firm.name_sh"),:value => name[0]},
     {:css => "normal",:name => "name,",:label => I18n.t("trst_firm.name_full"),:value => name[1]},
     {:css => "normal",:name => "name,",:label => I18n.t("trst_firm.name_off"),:value => name[2]},
     {:css => "normal",:name => "identities,chambcom",:label => I18n.t("trst_firm.identities.chambcom"),:value => identities["chambcom"]},
     {:css => "normal",:name => "identities,fiscal",:label => I18n.t("trst_firm.identities.fiscal"),:value => identities["fiscal"]},
     {:css => "normal",:name => "identities,account",:label => I18n.t("trst_firm.identities.account"),:value => identities["account"]},
     {:css => "normal",:name => "identities,itm",:label => I18n.t("trst_firm.identities.itm"),:value => identities["itm"]},
     {:css => "normal",:name => "identities,internet",:label => I18n.t("trst_firm.identities.internet"),:value => identities["internet"]},
     {:css => "normal",:name => "identities,cod",:label => I18n.t("trst_firm.identities.cod"),:value => identities["cod"]},
     {:css => "normal",:name => "about,caen",:label => I18n.t("trst_firm.about.caen"),:value => about["caen"]},
     {:css => "normal",:name => "about,scope",:label => I18n.t("trst_firm.about.scope"),:value => about["scope"]},
     {:css => "normal",:name => "about,descript",:label => I18n.t("trst_firm.about.descript"),:value => about["descript"]}]
  end

end
