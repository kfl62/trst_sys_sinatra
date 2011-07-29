# encoding: utf-8
=begin
#Freight model (Accounting)
=end

class TrstAccFreight
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        :type => String,        :default => "Freight"
  field :um,          :type => String,        :default => "kg"
  field :pu,          :type => Float,         :default => 0.00
  field :p03,         :type => Boolean,       :default => true
  field :category,    :type => String,        :default => "Category"
  field :descript,    :type => Array,         :default => []
  field :pu_other,    :type => Array,         :default => []

  has_many :ins,      :class_name => "TrstAccFreightIn",    :inverse_of => :freight
  has_many :outs,     :class_name => "TrstAccFreightOut",   :inverse_of => :freight
  has_many :stocks,   :class_name => "TrstAccFreightStock", :inverse_of => :freight
  belongs_to :unit,   :class_name => "TrstFirmUnit",        :inverse_of => :freights

  class << self
    # @todo
    def auto_search(u=nil, stock=nil)
      u ||= TrstFirm.unit_id_by_unit_slug("Main")
      fs = []
      where(:unit_id => u).asc(:name).each do |f|
        if stock
          fs << {:id => f.id,:um => f.um,:stock => f.stock, :label => f.name}
        else
          fs << {:id => f.id,:um => f.um,:pu => f.pu,:p03 => f.p03,:label => f.name}
        end
      end
      {:identifier => "id",:items => fs}
    end
    # @todo
    def pos(s)
      where(:unit_id => TrstFirm.unit_id_by_unit_slug(s)).asc(:name)
    end
    # @todo
    def by_unit_id(u)
      where(:unit_id => u).asc(:name)
    end
    # @todo
    def query(m = nil)
      m = m || Date.today.month
      retval = []
      asc(:name).each do |f|
        stk = f.stocks.monthly(m).sum(:qu) || 0
        f_in  = f.ins.monthly(m).sum(:qu) || 0
        f_out = f.outs.monthly(m).sum(:qu) || 0
        retval << [f.name, stk.round(2), f_in.round(2), f_out.round(2), (stk + f_in - f_out).round(2)]
      end
      retval
    end
  end # Class methods

  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.unit_id)
  end
  # @todo
  def col_name
    ary = name.split(" ")
    case ary.length
     when 1
       ary[0][0..3].upcase
     when 2
       ary[0][0..1].upcase + ary[1][0..1].upcase
     when 3
       ary[0][0..1].upcase + ary[1][0].upcase + ary[2][0].upcase
     else
       "ERR"
     end
  end
  # @todo
  def expenditure_pdf_name
    ary = name.split(" ")
    case ary.length
    when 1
      ary[0].titleize
    when 2
      [ary[0][0..2],'.',ary[1]].join[0..7]
    else
      "Error"
    end
  end
  # @todo
  def stock
    (stocks.first.qu rescue 0.00) + (ins.sum(:qu) || 0.00) - (outs.sum(:qu) || 0.00)
  end
  # @todo
  def table_data
    [
      {:css => "normal",:name => "name",:label => I18n.t("trst_acc_freight.name"),:value => name},
      {:css => "normal",:name => "um",:label => I18n.t("trst_acc_freight.um"),:value => um},
      {:css => "integer",:name => "pu",:label => I18n.t("trst_acc_freight.pu"),:value => pu},
      {:css => "boolean",:name => "p03",:label => I18n.t("trst_acc_freight.p03"),:value => p03},
      {:css => "normal",:name => "descript,",:label => I18n.t("trst_acc_freight.cod"),:value => descript[0]}
    ]
  end
end
