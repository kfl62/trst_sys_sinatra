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

  embedded_in :firm,      :class_name => "TrstFirm",            :inverse_of => :units
  has_one     :user,      :class_name => "TrstUser",            :inverse_of => :unit
  has_many    :apps,      :class_name => "TrstAccExpenditure",  :inverse_of => :unit
  has_many    :stocks,    :class_name => "TrstAccStock",        :inverse_of => :unit
  has_many    :freights,  :class_name => "TrstAccFreight",      :inverse_of => :unit

  before_save :generate_slug

  # @todo
  def table_data
    [
      {:css => "normal",:name => "name,",:label => I18n.t("trst_firm.name_sh"),:value => name[0]},
      {:css => "normal",:name => "name,",:label => I18n.t("trst_firm.name_full"),:value => name[1]},
      {:css => "normal",:name => "chief",:label => I18n.t("trst_firm.chief"),:value => chief}
    ]
  end

  protected
  # @todo
  def generate_slug
    self.slug = name[0]
  end
end
