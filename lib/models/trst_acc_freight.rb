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
  field :descript,    :type => String,        :default => ""
  field :pu_other,    :type => Array,         :default => []

  class << self
    def auto_search
      fs = []
      all.each do |f|
        fs << {:id => f.id,:um => f.um,:pu => f.pu,:p03 => f.p03,:label => f.name}
      end
      {:identifier => "id",:items => fs}
    end
  end

  # @todo
  def table_data
    [
      {:css => "normal",:name => "name",:label => I18n.t("trst_acc_freight.name"),:value => name},
      {:css => "normal",:name => "um",:label => I18n.t("trst_acc_freight.um"),:value => um},
      {:css => "integer",:name => "pu",:label => I18n.t("trst_acc_freight.pu"),:value => pu},
      {:css => "normal",:name => "p03",:label => I18n.t("trst_acc_freight.p03"),:value => p03}
    ]
  end
end
