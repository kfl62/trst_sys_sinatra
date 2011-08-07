# encoding: utf-8
=begin
#Money cache model (Accounting)
=end

class TrstAccCache
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,          :type => String
  field :id_date,       :type => Date,      :default => Date.new(Time.now.year,Time.now.month,Time.now.day)
  field :money_in,      :type => Float,     :default => 0.00
  field :money_out,     :type => Float,     :default => 0.00
  field :money_stock,   :type => Float,     :default => 0.00
  field :expl,          :type => String,    :default => ""

  belongs_to :unit,       :class_name => "TrstFirmUnit",      :inverse_of => :dps

  before_create :init_name_date_expl

  class << self
    # @todo
    def daily(day = nil)
      day ||= Date.today.to_s
      where(:id_date => DateTime.strptime("#{day}","%F").to_time)
    end
    # @todo
    def monthly(month = nil)
      year = Date.today.year
      month ||= Date.today.month
      mb = DateTime.new(year, month.to_i)
      me = DateTime.new(year, month.to_i + 1)
      where(:id_date.gte => mb.to_time, :id_date.lt => me.to_time)
    end
    # @todo
    def pos(slg)
      slg = slg.upcase
      where(:unit_id => TrstFirm.unit_id_by_unit_slug(slg)).asc(:id_date)
    end
    # @todo
    def by_unit_id(u)
      where(:unit_id => u).asc(:id_date)
    end
    # @todo
    def query(month = nil)
      today = Date.today
      year  = today.year
      month ||= today.month
      days_in_month = (Date.new(year, 12, 31) << (12-month)).day
      unit_id = first.unit_id
      retval, tot_out = [], 0
      tot_in = monthly(month.to_i).sum(:money_stock) || 0
      (1..days_in_month).each do |i|
        day = Date.new(year,month.to_i,i).to_s
        sum_in  = daily(day).sum(:money_in) || 0.0
        tot_in += sum_in
        sum_out = TrstAccExpenditure.by_unit_id(unit_id).daily(day).sum(:sum_out) || 0.0
        tot_out += sum_out
        retval << [day, sum_in.round(2), sum_out.round(2), (tot_in - tot_out).round(2)] unless (sum_in == 0 && sum_out ==0)
      end
      retval.push(["Total", tot_in.round(2), tot_out.round(2), (tot_in - tot_out).round(2)])
      retval
    end
    # @todo
    def balance(month = nil)
      month ||= Date.today.month
      unit_id = first.unit_id
      stk = monthly(month.to_i).sum(:money_stock) || 0
      ins = monthly(month.to_i).sum(:money_in) || 0
      out = TrstAccExpenditure.by_unit_id(unit_id).monthly(month.to_i).sum(:sum_out) || 0
      [stk, ins, out, stk + ins - out]
    end
  end # Class methods

  def table_data
    [
      {:css => "admin",:name => "name",:label => I18n.t("trst_acc_cache.name"),:value => name},
      {:css => "date",:name => "id_date",:label => I18n.t("trst_acc_cache.id_date"),:value => id_date},
      {:css => "integer",:name => "money_in",:label => I18n.t("trst_acc_cache.money_in"),:value => "%.2f" % money_in},
      {:css => "admin",:name => "money_out",:label => I18n.t("trst_acc_cache.money_out"),:value => "%.2f" % money_out},
      {:css => "admin",:name => "money_stock",:label => I18n.t("trst_acc_cache.money_stock"),:value => "%.2f" % money_stock},
      {:css => "normal",:name => "expl",:label => I18n.t("trst_acc_cache.expl"),:value => expl}
    ]
  end

  protected

  # @todo
  def init_name_date_expl
    self.name = "DP_NR-#{Date.today.to_s}"
    self.id_date = Date.today
    self.expl = I18n.t('trst_acc_cache.expl_value')
  end

end
