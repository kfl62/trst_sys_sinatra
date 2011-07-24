# encoding: utf-8
=begin
#Money cache model (Accounting)
=end

class TrstAccCache
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,          :type => String,    :default => "DP_"
  field :id_date,       :type => Date,      :default => Date.new(Time.now.year,Time.now.month,Time.now.day)
  field :money_in,      :type => Float,     :default => 0.00
  field :money_out,     :type => Float,     :default => 0.00
  field :money_stock,   :type => Float,     :default => 0.00
  field :expl,          :type => String,    :default => ""

  belongs_to :unit,       :class_name => "TrstFirmUnit",      :inverse_of => :dps

  before_create :init_expl

  class << self
    # @todo
    def daily(day)
      crit = where(:id_date => DateTime.strptime("#{day}","%F").to_time)
      [crit.sum(:money_in),crit.sum(:money_out),crit.sum(:money_stock)]
    end
    # @todo
    def pos(slg)
      slg = slg.upcase
      where(:unit_id => TrstFirm.unit_id_by_unit_slug(slg))
    end
  end # Class methods

  def table_data
    [
      {:css => "normal",:name => "name",:label => I18n.t("trst_acc_cache.name"),:value => name},
      {:css => "date",:name => "id_date",:label => I18n.t("trst_acc_cache.id_date"),:value => id_date},
      {:css => "integer",:name => "money_in",:label => I18n.t("trst_acc_cache.money_in"),:value => "%.2f" % money_in},
      {:css => "integer",:name => "money_out",:label => I18n.t("trst_acc_cache.money_out"),:value => "%.2f" % money_out},
      {:css => "integer",:name => "money_stock",:label => I18n.t("trst_acc_cache.money_stock"),:value => "%.2f" % money_stock},
      {:css => "normal",:name => "expl",:label => I18n.t("trst_acc_cache.expl"),:value => expl}
    ]
  end

  protected

  # @todo
  def init_expl
    self.expl = I18n.t('trst_acc_cache.expl_value')
  end

end
