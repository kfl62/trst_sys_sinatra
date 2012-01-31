# encoding: utf-8
=begin
#Partners model
=end

class TrstPartnersPf
  include Mongoid::Document
  include Mongoid::Timestamps

  field :id_pn,               :type => String
  field :name_last,           :type => String,        :default => "Last(Nume)"
  field :name_first,          :type => String,        :default => "First(Prenume)"
  field :identities,          :type => Hash,          :default => {:id_sr => "KX", :id_nr => "123456",:id_by => "SPCLEP Cluj-Napoca", :id_on => "1900-01-01"}
  field :address,             :type => Hash,          :default => {:city => "Cluj-Napoca", :street => "str.", :nr => "00", :bl => "-", :sc => "-", :et => "-", :ap => "-"}
  field :other,               :type => String,        :default => "Client"

  has_many :apps, :class_name => "TrstAccExpenditure", :inverse_of => :client

  validates_uniqueness_of :id_pn
  before_create :tmp_pn
  before_save   :titleize_fields

  scope :pn,   ->(pn) { where(:id_pn => pn) }

  class << self
    # @todo
    def auto_search(u = nil)
      pfs = []
      all.asc(:name_last, :name_first).each do |pf|
        if pf.id_pn.nil? || pf.id_pn.empty? || pf.id_pn.include?("tmp")
          pf.delete if (pf.created_at + 300) < DateTime.now
        else
          label = "#{pf.id_pn} | #{pf.name_full}"
          pfs << {:id => pf.id,:pn => pf.id_pn,:label => label}
        end
      end
      {:identifier => "id",:items => pfs}
    end
    # @todo
    def check_pn
      errors = all.asc(:name_last, :name_first).each_with_object([]) do |pf,e|
        e << [pf.name, pf.id_pn] if pf.pn_error?
      end
      errors.empty? ? "Ok" : errors
    end
    # @todo
    def id_by_pn(pn)
      pn(pn).first.id rescue nil
    end
    # @todo
    def by_id_pn(pn)
      where(:id_pn => pn)
    end
  end # Class methods
  # @todo
  def name_full
    [name_last,name_first].join(' ')
  end
  alias :name :name_full
  # @todo
  def name_stats
    n = self.name[0..17] << (self.name.length > 17 ? '.' : '')
    t = "Str.#{address["street"]} nr.#{ address["nr"]},#{address["city"]}"
    txt = t[0..35] << (t.length > 35 ? '.' : '')
    "#{n} (#{id_pn})" +
    "\n#{txt}"
  end
  # @todo
  def pn_error?
    ctrl = "279146358279"
    if id_pn.nil? || id_pn.length != 13
      return true
    else
      sum = 0
      ctrl.each_char.each_with_index do |c, i|
        sum += c.to_i * id_pn[i].to_i
      end
      mod = sum % 11
      unless (mod < 10 && mod == id_pn[12].to_i) || (mod = 10 && id_pn[12].to_i == 1)
        return true
      end
    end
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
  def tmp_pn
    self.id_pn = "tmp_#{Random.new.rand(10..100)}"
  end
  # @todo
  def titleize_fields
    self.name_last = name_last.titleize if name_last
    self.name_first = name_first.titleize if name_first
    self.address[:street] = address[:street].titleize if address[:street]
    self.address[:city] = address[:city].titleize if address[:city]
  end
end
