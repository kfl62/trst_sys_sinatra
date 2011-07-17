# encoding: utf-8
=begin
#PartnersAddress model
=end

class TrstPartnerAddress
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,      :default => "Main address"
  field :city,      :default => "Cluj-Napoca"
  field :street,    :default => "Xxx"
  field :nr,        :default => "xxx"
  field :bl,        :default => "__"
  field :sc,        :default => "__"
  field :et,        :default => "__"
  field :ap,        :default => "__"
  field :state,     :default => "Cluj"
  field :country,   :default => "Romania"
  field :zip,       :default => "xxxxxx"

  embedded_in :trst_partnersfirm, :class_name => "TrstPartner", :inverse_of => :addresses

  def table_data
    [
      {:css => "normal",:name => "name",:label => I18n.t("trst_partner_address.name"),:value => name},
      {:css => "normal",:name => "city",:label => I18n.t("trst_partner_address.city"),:value => city},
      {:css => "normal",:name => "street",:label => I18n.t("trst_partner_address.street"),:value => street},
      {:css => "normal",:name => "nr",:label => I18n.t("trst_partner_address.nr"),:value => nr},
      {:css => "normal",:name => "bl",:label => I18n.t("trst_partner_address.bl"),:value => bl},
      {:css => "normal",:name => "sc",:label => I18n.t("trst_partner_address.sc"),:value => sc},
      {:css => "normal",:name => "et",:label => I18n.t("trst_partner_address.et"),:value => et},
      {:css => "normal",:name => "ap",:label => I18n.t("trst_partner_address.ap"),:value => ap},
      {:css => "normal",:name => "state",:label => I18n.t("trst_partner_address.state"),:value => state},
      {:css => "normal",:name => "country",:label => I18n.t("trst_partner_address.country"),:value => country},
      {:css => "normal",:name => "zip",:label => I18n.t("trst_partner_address.zip"),:value => zip}
    ]
  end
end
