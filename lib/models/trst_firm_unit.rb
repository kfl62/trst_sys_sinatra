# encoding: utf-8
=begin
#FirmDepartments model
=end

class TrstFirmUnit
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,          :type => Array,     :default => ["ShortName","FullName"]
  field :slug,          :type => String
  field :chief,         :type => String,    :default => "Lastname Firstname"
  field :env_auth,      :type => String

  embedded_in :firm,      :class_name => "TrstFirm",            :inverse_of => :units
  has_one     :user,      :class_name => "TrstUser",            :inverse_of => :unit
  has_many    :apps,      :class_name => "TrstAccExpenditure",  :inverse_of => :unit
  has_many    :stocks,    :class_name => "TrstAccStock",        :inverse_of => :unit
  has_many    :freights,  :class_name => "TrstAccFreight",      :inverse_of => :unit
  has_many    :dps,       :class_name => "TrstAccCache",        :inverse_of => :unit

  before_save :generate_slug

  # @todo
  def current_stock
    stocks.where(:id_month  => 0).first
  end
  # @todo
  def table_data
    [
      {:css => "normal",:name => "name,",:label => I18n.t("trst_firm_unit.name_sh"),:value => name[0]},
      {:css => "normal",:name => "name,",:label => I18n.t("trst_firm_unit.name_full"),:value => name[1]},
      {:css => "normal",:name => "chief",:label => I18n.t("trst_firm_unit.chief"),:value => chief},
      {:css => "normal",:name => "env_auth",:label => I18n.t("trst_firm_unit.env_auth"),:value => env_auth}
    ]
  end

  protected
  # @todo
  def generate_slug
    self.slug = name[0]
  end
end
