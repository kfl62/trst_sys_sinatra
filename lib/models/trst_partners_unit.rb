# encoding: utf-8
=begin
#PartnerUnit model
=end

class TrstPartnerUnit
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,          :type => Array,     :default => ["ShortName","FullName"]
  field :slug,          :type => String
  field :chief,         :type => String,    :default => "Lastname Firstname"

  embedded_in :partner,   :class_name => "TrstPartner",         :inverse_of => :units
  has_one     :user,      :class_name => "TrstUser",            :inverse_of => :unit
  has_many    :apps,      :class_name => "TrstAccExpenditure",  :inverse_of => :unit
  has_many    :stocks,    :class_name => "TrstAccStock",        :inverse_of => :unit
  has_many    :freights,  :class_name => "TrstAccFreight",      :inverse_of => :unit

  before_save :generate_slug

  # @todo
  def table_data
    [
      {:css => "normal",:name => "name,",:label => I18n.t("trst_partner_unit.name_sh"),:value => name[0]},
      {:css => "normal",:name => "name,",:label => I18n.t("trst_partner_unit.name_full"),:value => name[1]},
      {:css => "normal",:name => "chief",:label => I18n.t("trst_partner_unit.chief"),:value => chief}
    ]
  end

  protected
  # @todo
  def generate_slug
    self.slug = name[0]
  end
end
