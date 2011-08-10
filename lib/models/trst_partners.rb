# encoding: utf-8
=begin
#Partners model
=end

class TrstPartner
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,                :type => Array,         :default => ["ShortName","FullName","OfficialName"]
  field :identities,          :type => Hash,          :default => {:caen => "xxx",:chambcom => "Jxx/xxx/xxx",:fiscal => "ROxxx",:account => "xxx",:itm => "xxx",:internet => "xxx.xxx.xxx.xxx",:cod => "XXX"}
  field :contact,             :type => Hash,          :default => {:phone => "xxxx",:fax => "xxx",:email => "xx@xxx.xxx",:website => "xxxx"}
  field :about,               :type => Hash,          :default => {:scope => "Scope ...?...", :descript => "Descript ...?..."}
  field :client,              :type => Boolean,       :default => true
  field :supplier,            :type => Boolean,       :default => true
  field :transporter,         :type => Boolean,       :default => true

  embeds_many :addresses,       :class_name => "TrstPartnerAddress"
  embeds_many :persons,         :class_name => "TrstPartnerContactPerson"
  embeds_many :delegates,       :class_name => "TrstPartnerDelegate"
  embeds_many :departments,     :class_name => "TrstPartnerDepart"
  embeds_many :units,           :class_name => "TrstPartnerUnit"
  has_many    :delivery_notes,  :class_name => "TrstAccDeliveryNote", :inverse_of => :client
  has_many    :delivery_pprss,  :class_name => "TrstAccDeliveryNote", :inverse_of => :transporter

  class << self
    # @todo
    def unit_id_by_unit_slug(s)
      f = where('units.slug' => s).first
      id = f.units.where(:slug => s).first.id
    end
    # @todo
    def unit_by_unit_id(i)
      f = where('units._id' => i).first
      f.units.find(i)
    end
    # @todo
    def clients
      where(:client => true).asc(:name)
    end
    # @todo
    def suppliers
      where(:supplier => true).asc(:name)
    end
    # @todo
    def transporters
      where(:transporter => true).asc(:name)
    end
  end # Class methods

  # @todo
  def details
    self.addresses.create if self.addresses.empty?
    self.persons.create if self.persons.empty?
    self.delegates.create if self.delegates.empty?
    self.departments.create if self.departments.empty?
    self.units.create if self.units.empty?
    ["TrstPartner",id,[addresses,persons,delegates,departments,units]]
  end

  # @todo
  def table_data
    [
      {:css => "normal",:name => "name,",:label => I18n.t("trst_partner.name_sh"),:value => name[0]},
      {:css => "normal",:name => "name,",:label => I18n.t("trst_partner.name_full"),:value => name[1]},
      {:css => "normal",:name => "name,",:label => I18n.t("trst_partner.name_off"),:value => name[2]},
      {:css => "normal",:name => "identities,caen",:label => I18n.t("trst_partner.identities.caen"),:value => identities["caen"]},
      {:css => "normal",:name => "identities,chambcom",:label => I18n.t("trst_partner.identities.chambcom"),:value => identities["chambcom"]},
      {:css => "normal",:name => "identities,fiscal",:label => I18n.t("trst_partner.identities.fiscal"),:value => identities["fiscal"]},
      {:css => "normal",:name => "identities,account",:label => I18n.t("trst_partner.identities.account"),:value => identities["account"]},
      {:css => "normal",:name => "identities,itm",:label => I18n.t("trst_partner.identities.itm"),:value => identities["itm"]},
      {:css => "normal",:name => "identities,internet",:label => I18n.t("trst_partner.identities.internet"),:value => identities["internet"]},
      {:css => "normal",:name => "identities,cod",:label => I18n.t("trst_partner.identities.cod"),:value => identities["cod"]},
      {:css => "normal",:name => "contact,phone",:label => I18n.t("trst_partner.contact.phone"),:value => contact["phone"]},
      {:css => "normal",:name => "contact,fax",:label => I18n.t("trst_partner.contact.fax"),:value => contact["fax"]},
      {:css => "normal",:name => "contact,email",:label => I18n.t("trst_partner.contact.email"),:value => contact["email"]},
      {:css => "normal",:name => "contact,website",:label => I18n.t("trst_partner.contact.website"),:value => contact["website"]},
      {:css => "normal",:name => "about,scope",:label => I18n.t("trst_partner.about.scope"),:value => about["scope"]},
      {:css => "normal",:name => "about,descript",:label => I18n.t("trst_partner.about.descript"),:value => about["descript"]},
      {:css => "boolean",:name => "client",:label => I18n.t("trst_partner.client"),:value => client},
      {:css => "boolean",:name => "supplier",:label => I18n.t("trst_partner.supplier"),:value => supplier},
      {:css => "boolean",:name => "transporter",:label => I18n.t("trst_partner.transporter"),:value => transporter}
    ]
  end


end
