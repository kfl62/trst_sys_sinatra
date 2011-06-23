# encoding: utf-8
=begin
#Partners model
=end

class TrstPartnersPf
  include Mongoid::Document
  include Mongoid::Timestamps

  field :id_pn,               :type => String,        :default => "123456789ABCD"
  field :name,                :type => Array,         :default => ["LastName","FirstName"]
  field :identities,          :type => Hash,          :default => {:id_sr => "KX", :id_nr => "123456",:id_by => "SPCLEP Cluj-Napoca", :id_on => "1900-01-01"}
  field :address,             :type => Hash,          :default => {:city => "Cluj-Napoca", :street => "str.", :nr => "00", :bl => "__", :sc => "__", :et => "__", :ap => "__"}
  field :other,               :type => String,        :default => "Client"

  has_many :apps, :class_name => "TrstAccExpenditure", :inverse_of => :client
  class << self
    # @todo
    def auto_search
      pfs = []
      all.each do |pf|
        label = "#{pf.id_pn} | #{pf.name_full}"
        pfs << {:id => pf.id,:pn => pf.id_pn,:label => label}
      end
      {:identifier => "id",:items => pfs}
    end
  end
  # @todo
  def name_full
    name.join(' ')
  end
  # @todo
  def table_data
    [
      {:css => "normal",:name => "id_pn",:label => I18n.t("trst_partners_pf.id_pn"),:value => id_pn},
      {:css => "normal",:name => "name,",:label => I18n.t("trst_partners_pf.name_last"),:value => name[0]},
      {:css => "normal",:name => "name,",:label => I18n.t("trst_partners_pf.name_first"),:value => name[1]},
      {:css => "normal",:name => "identities,id_sr",:label => I18n.t("trst_partners_pf.identities.id_sr"),:value => identities["id_sr"]},
      {:css => "normal",:name => "identities,id_nr",:label => I18n.t("trst_partners_pf.identities.id_nr"),:value => identities["id_nr"]},
      {:css => "normal",:name => "identities,id_by",:label => I18n.t("trst_partners_pf.identities.id_by"),:value => identities["id_by"]},
      {:css => "normal",:name => "identities,id_on",:label => I18n.t("trst_partners_pf.identities.id_on"),:value => identities["id_on"]},
      {:css => "normal",:name => "address,city",:label => I18n.t("trst_partners_pf.address.city"),:value => address["city"]},
      {:css => "normal",:name => "address,street",:label => I18n.t("trst_partners_pf.address.street"),:value => address["street"]},
      {:css => "normal",:name => "address,nr",:label => I18n.t("trst_partners_pf.address.nr"),:value => address["nr"]},
      {:css => "normal",:name => "address,bl",:label => I18n.t("trst_partners_pf.address.bl"),:value => address["bl"]},
      {:css => "normal",:name => "address,sc",:label => I18n.t("trst_partners_pf.address.sc"),:value => address["sc"]},
      {:css => "normal",:name => "address,et",:label => I18n.t("trst_partners_pf.address.et"),:value => address["et"]},
      {:css => "normal",:name => "address,ap",:label => I18n.t("trst_partners_pf.address.ap"),:value => address["ap"]},
      {:css => "normal",:name => "other",:label => I18n.t("trst_partners_pf.other"),:value => other}
   ]
  end

end
