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
  field :main,          :type => Boolean,   :default => false

  embedded_in :firm,          :class_name => "TrstFirm",            :inverse_of => :units
  has_one     :user,          :class_name => "TrstUser",            :inverse_of => :unit
  has_many    :apps,          :class_name => "TrstAccExpenditure",  :inverse_of => :unit
  has_many    :grns,          :class_name => "TrstAccGrn",          :inverse_of => :unit
  has_many    :delivery_notes,:class_name => "TrstAccDeliveryNote", :inverse_of => :unit
  has_many    :stocks,        :class_name => "TrstAccStock",        :inverse_of => :unit
  has_many    :freights,      :class_name => "TrstAccFreight",      :inverse_of => :unit
  has_many    :dps,           :class_name => "TrstAccCache",        :inverse_of => :unit

  before_save :generate_slug

  # @todo
  def current_stock
    stocks.where(:id_date  => Date.new(2000,1,31)).first
  end
  # @todo
  def current_stock_check(all = false, with_pu = false)
    y = Date.today.year
    m = Date.today.month
    keys   = self.current_stock.freights.keys(with_pu)
    retval = keys.each_with_object([]) do |k,a|
      f = self.current_stock.freights.by_id_stats_and_pu(k)[0].freight
      f_st = f.stocks.by_id_stats_and_pu(k).sum_qu(y,m)
      f_in = f.ins.by_id_stats_and_pu(k).sum_qu(y,m)
      f_ou = f.outs.by_id_stats_and_pu(k).sum_qu(y,m)
      f_cs = self.current_stock.freights.by_id_stats_and_pu(k).sum(:qu) || 0
      diff = (f_st + f_in - f_ou - f_cs).round(2)
      a << "#{k} #{("%0.2f" % f_st).rjust(10)} #{("%0.2f" % f_in).rjust(10)} #{("%0.2f" % f_ou).rjust(10)} #{("%0.2f" % (f_st + f_in - f_ou)).rjust(10)} #{("%0.2f" % f_cs).rjust(10)} #{("%0.2f" % diff).rjust(10)}" if (diff != 0 or all)
    end
    retval.unshift("#{('Id').rjust(10)} #{('Stock').rjust(10)} #{('In').rjust(10)} #{('Out').rjust(10)} #{('Calc').rjust(10)} #{('currStock').rjust(10)} #{('Diff').rjust(10)}") unless retval.empty?
    retval.empty? ? "Ok" : retval.join("\n")
  end
  # @todo
  def monthly_stock(y,m)
    stocks.monthly(y,m + 1).first
  end
  # @todo
  def monthly_stock_check(all = false, with_pu = false, y = nil, m = nil)
    y ||= Date.today.year
    m ||= Date.today.month
    base = self.monthly_stock(y,m) || self.current_stock
    keys   = base.freights.keys(with_pu)
    retval = keys.each_with_object([]) do |k,a|
      f    = base.freights.by_id_stats_and_pu(k)[0].freight
      f_st = f.stocks.by_id_stats_and_pu(k).sum_qu(y,m)
      f_in = f.ins.by_id_stats_and_pu(k).sum_qu(y,m)
      f_ou = f.outs.by_id_stats_and_pu(k).sum_qu(y,m)
      f_cs = base.freights.by_id_stats_and_pu(k).sum(:qu) || 0
      diff = (f_st + f_in - f_ou - f_cs).round(2)
      a << "#{k} #{("%0.2f" % f_st).rjust(10)} #{("%0.2f" % f_in).rjust(10)} #{("%0.2f" % f_ou).rjust(10)} #{("%0.2f" % (f_st + f_in - f_ou)).rjust(10)} #{("%0.2f" % f_cs).rjust(10)} #{("%0.2f" % diff).rjust(10)}" if (diff != 0 or all)
    end
    retval.unshift("#{('Id').rjust(10)} #{('Stock').rjust(10)} #{('In').rjust(10)} #{('Out').rjust(10)} #{('Calc').rjust(10)} #{('currStock').rjust(10)} #{('Diff').rjust(10)}") unless retval.empty?
    retval.empty? ? "Ok" : retval.join("\n")
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
