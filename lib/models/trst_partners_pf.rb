# encoding: utf-8
=begin
#Partners model
=end

class TrstPartnersPf
  include Mongoid::Document
  include Mongoid::Timestamps

  field :id_pn,               :type => String,        :default => "123456789ABCD"
  field :name_last,           :type => String,        :default => "Last(Nume)"
  field :name_first,          :type => String,        :default => "First(Prenume)"
  field :identities,          :type => Hash,          :default => {:id_sr => "KX", :id_nr => "123456",:id_by => "SPCLEP Cluj-Napoca", :id_on => "1900-01-01"}
  field :address,             :type => Hash,          :default => {:city => "Cluj-Napoca", :street => "str.", :nr => "00", :bl => "-", :sc => "-", :et => "-", :ap => "-"}
  field :other,               :type => String,        :default => "Client"

  has_many :apps, :class_name => "TrstAccExpenditure", :inverse_of => :client

  before_save :titleize_fields
  class << self
    # @todo
    def auto_search(u = nil)
      pfs = []
      all.asc(:name_last, :name_first).each do |pf|
        if pf.id_pn == "123456789ABCD"
          pf.delete
        else
          label = "#{pf.id_pn} | #{pf.name_full}"
          pfs << {:id => pf.id,:pn => pf.id_pn,:label => label}
        end
      end
      {:identifier => "id",:items => pfs}
    end
    # @todo
    def check_pn
      ctrl = "279146358279"
      errors = []
      all.asc(:name_last, :name_first).each do |pf|
        sum = 0
        ctrl.each_char.each_with_index do |c, i|
          sum += c.to_i * pf.id_pn[i].to_i
        end
        mod = sum % 11
        unless (mod < 10 && mod == pf.id_pn[12].to_i) || (mod = 10 && pf.id_pn[12].to_i == 1)
          errors << [pf.name_full, pf.id_pn]
        end
      end
      errors.empty? ? "Ok" : errors
    end
  end
  # @todo
  def name_full
    [name_last,name_first].join(' ')
  end
  alias :name :name_full
  # @todo
  def name_stats
    "#{self.name} (#{id_pn})"[0..40] +
    "\n" +
    "Str.#{address["street"]} nr.#{ address["nr"]},#{address["city"]}"[0..40]
  end
  # @todo
  def table_data
    [
      {:css => "normal",:name => "id_pn",:label => I18n.t("trst_partners_pf.id_pn"),:value => id_pn},
      {:css => "normal",:name => "name_last",:label => I18n.t("trst_partners_pf.name_last"),:value => name_last},
      {:css => "normal",:name => "name_first",:label => I18n.t("trst_partners_pf.name_first"),:value => name_first},
      {:css => "normal",:name => "identities,id_sr",:label => I18n.t("trst_partners_pf.identities.id_sr"),:value => identities["id_sr"]},
      {:css => "normal",:name => "identities,id_nr",:label => I18n.t("trst_partners_pf.identities.id_nr"),:value => identities["id_nr"]},
      {:css => "normal",:name => "identities,id_by",:label => I18n.t("trst_partners_pf.identities.id_by"),:value => identities["id_by"]},
      {:css => "normal",:name => "identities,id_on",:label => I18n.t("trst_partners_pf.identities.id_on"),:value => identities["id_on"]},
      {:css => "normal",:name => "address,city",:label => I18n.t("trst_partners_pf.address.city"),:value => address["city"]},
      {:css => "normal",:name => "address,street",:label => I18n.t("trst_partners_pf.address.street"),:value => address["street"]},
      {:css => "normal",:name => "address,nr",:label => I18n.t("trst_partners_pf.address.nr"),:value => address["nr"]},
      {:css => "normal",:name => "address,bl",:label => I18n.t("trst_partners_pf.address.bl"),:value => address["bl"]},
      {:css => "normal",:name => "address,sc",:label => I18n.t("trst_partners_pf.address.sc"),:value => address["sc"]},
      {:css => "normal",:name => "address,et",:label => I18n.t("trst_partners_pf.address.et"),:value => address["et"]},
      {:css => "normal",:name => "address,ap",:label => I18n.t("trst_partners_pf.address.ap"),:value => address["ap"]},
      {:css => "normal",:name => "other",:label => I18n.t("trst_partners_pf.other"),:value => other}
   ]
  end
  # @todo
  def i18n_hash
    {
      id_pn: id_pn, name: name_full,
      city: address['city'], street: address['street'], nr: address["nr"], bl: address["bl"], sc: address["sc"], et: address["et"], ap: address["ap"],
      id_sr: identities["id_sr"], id_nr: identities["id_nr"], id_by: identities["id_by"], id_on: identities["id_on"]
    }
  end
  protected
  # @todo
  def titleize_fields
    self.name_last = name_last.titleize if name_last
    self.name_first = name_first.titleize if name_first
    self.address[:street] = address[:street].titleize if address[:street]
    self.address[:city] = address[:street].titleize if address[:city]
  end
end
