# encoding: utf-8
=begin
#Expenditure model (Accounting)
=end

class TrstAccExpenditure
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        :type => String
  field :id_date,     :type => Date
  field :id_intern,   :type => Boolean,   :default => false
  field :sum_003,     :type => Float,     :default => 0.00
  field :sum_016,     :type => Float,     :default => 0.00
  field :sum_100,     :type => Float,     :default => 0.00
  field :sum_out,     :type => Float,     :default => 0.00

  alias :file_name :name

  has_many   :freights,   :class_name => "TrstAccFreightIn",  :inverse_of => :doc_exp
  belongs_to :client,     :class_name => "TrstPartnersPf",    :inverse_of => :apps
  belongs_to :unit,       :class_name => "TrstFirmUnit",      :inverse_of => :apps
  belongs_to :signed_by,  :class_name => "TrstUser",          :inverse_of => :apps

  before_create :increment_name_date
  before_destroy :destroy_freights

  class << self
    # @todo
    def daily(y = nil, m = nil, d = nil)
      y,m,d = y.split('-').map{|s| s.to_i} if y.is_a? String
      y ||= Date.today.year
      m ||= Date.today.month
      d ||= Date.today.mday
      where(:id_date => Time.utc(y,m,d)).asc(:name)
    end
    # @todo
    def monthly(y = nil, m = nil)
      y ||= Date.today.year
      m ||= Date.today.month
      mb = DateTime.new(y, m)
      me = m == 12 ? DateTime.new(y + 1, 1) : DateTime.new(y, m + 1)
      where(:id_date.gte => mb.to_time, :id_date.lt => me.to_time).asc(:name)
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
      retval = all.each_with_object([]) do |app,a|
        f_sum_100 = 0
        app.freights.each do |f|
          f_sum_100 += (f.pu * f.qu).round(2)
        end
        a << "#{app.unit.slug} -#{app.name.rjust(16)} #{app.id_date.to_s} #{("%0.2f" % app.sum_100).rjust(10)} #{("%0.2f" % f_sum_100).rjust(10)} #{("%0.2f" % (app.sum_100 - f_sum_100)).rjust(10)}" if app.sum_100.round(2) != f_sum_100.round(2)
      end
      puts retval.empty? ? "Ok" : retval.join("\n")
    end
    # @todo
    def query(pn, m = nil)
      by_client_id(pn).sum(:sum_out) || 0
    end
    # @todo
    def to_txt
      all.each{|app| p "#{app.name} --- #{app.id_date.to_s} #{app.updated_at.strftime("%H:%M")} --- #{("%.2f" % app.sum_out).rjust(8)}"}
    end
  end

  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.unit_id) rescue nil
  end
  # @todo
  def pdf_template
    'pdf'
  end
  # @todo
  def freights_list
    self.freights.asc(:id_stats).each_with_object([]) do |f,r|
      r << "#{f.freight.name}: #{"%.2f" % f.qu} kg ( #{"%.2f" % f.pu} )"
    end
  end
  # @todo
  def change_date(y,m,d)
    t = Time.utc(y,m,d)
    set(:id_date,t)
    freights.each{|f| f.set(:id_date,t)}
  end

  protected
  # @todo
  def increment_name_date
    if TrstAccExpenditure.by_unit_id(unit_id).last.freights.empty?
      TrstAccExpenditure.by_unit_id(unit_id).last.destroy
    end unless TrstAccExpenditure.by_unit_id(unit_id).last.nil?
    self.name = TrstAccExpenditure.by_unit_id(unit_id).asc(:name).last.name.next rescue "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}-000001"
    self.id_date = Date.today
  end
  # @todo
  def destroy_freights
    self.freights.destroy_all
  end
end
