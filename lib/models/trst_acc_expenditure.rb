# encoding: utf-8
=begin
#Expenditure model (Accounting)
=end

class TrstAccExpenditure
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        :type => String
  field :id_date,     :type => Date
  field :sum_003,     :type => Float,     :default => 0.00
  field :sum_016,     :type => Float,     :default => 0.00
  field :sum_100,     :type => Float,     :default => 0.00
  field :sum_out,     :type => Float,     :default => 0.00

  alias :file_name :name

  has_many   :freights,   :class_name => "TrstAccFreightIn",  :inverse_of => :doc
  belongs_to :client,     :class_name => "TrstPartnersPf",    :inverse_of => :apps
  belongs_to :unit,       :class_name => "TrstFirmUnit",      :inverse_of => :apps

  before_create :increment_name_date
  after_destroy :destroy_freights

  class << self
    # @todo
    def daily(d)
      where(:id_date => DateTime.strptime("#{d}","%F").to_time).asc(:name)
    end
    # @todo
    def monthly(m)
      y = Date.today.year
      m = m.to_i
      mb = DateTime.new(y, m)
      me = DateTime.new(y, m + 1)
      where(:id_date.gte => mb.to_time, :id_date.lt => me.to_time)
    end
    # @todo
    def pos(slg)
      where(:unit_id => TrstFirm.unit_id_by_unit_slug(slg)).asc(:name)
    end
    # @todo
    def by_unit_id(u)
      where(:unit_id => u).asc(:name)
    end
    # @todo
    def pn(pn)
      where(:client_id => TrstPartnersPf.id_by_pn(pn)).asc(:name)
    end
    # @todo
    def by_client_id(ci)
      where(:client_id => ci).asc(:name)
    end
    # @todo
    def check_sum
      retval = []
      all.each do |a|
        f_sum_100 = 0
        a.freights.each do |f|
          f_sum_100 += (f.pu * f.qu).round(2)
        end
        retval.push [a.name, (a.sum_100 - f_sum_100).round(2)] if a.sum_100.round(2) != f_sum_100.round(2)
      end
      retval
    end
    # @todo
    def query(pn, m = nil)
      by_client_id(pn).sum(:sum_out) || 0
    end
    # @todo
    def today_to_console
      today = Date.today.to_s
      daily(today).each{|app| p "#{app.name} --- #{app.updated_at.strftime("%H:%M")} --- #{"%.2f" % app.sum_out}"}
    end
  end

  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.unit_id) rescue nil
  end
  # @todo
  def id_sr
    name.split('-')[0]
  end
  # @todo
  def id_nr
    name.split('-')[1]
  end
  # @todo
  def pdf_template
    'pdf'
  end

  protected
  # @todo
  def increment_name_date
    self.name = TrstAccExpenditure.where(:unit_id => unit_id).asc(:name).last.name.next rescue "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}_000001"
    self.id_date = Date.today
  end
  # @todo
  def destroy_freights
    self.freights.destroy_all
  end
end
