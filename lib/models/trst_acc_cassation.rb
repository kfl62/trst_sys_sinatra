# encoding: utf-8
=begin
  Cassation model (Accounting)
=end

class TrstAccCassation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,              :type => String
  field :id_date,           :type => Date
  field :id_intern,         :type => Boolean,     :default => false
  field :text,              :type => String
  field :val,               :type => Float,       :default => 0.0

  alias :file_name :name

  has_many   :freights,   :class_name => "TrstAccFreightOut", :inverse_of => :doc_cs
  belongs_to :unit,       :class_name => "TrstFirmUnit",      :inverse_of => :cassations
  belongs_to :signed_by,  :class_name => "TrstUser",          :inverse_of => :cassations

  before_create   :init_name_date_expl
  before_destroy  :destroy_freights
  before_save     :update_value

  class << self
    # @todo
    def pos(slg)
      where(:unit_id => TrstFirm.pos(slg).id)
    end
    # @todo
    def daily(y = nil, m = nil, d = nil)
      y,m,d = y.split('-').map{|s| s.to_i} if y.is_a? String
      y ||= Date.today.year
      m ||= Date.today.month
      d ||= Date.today.mday
      where(:id_date => Time.utc(y,m,d))
    end
    # @todo
    def monthly(y = nil, m = nil)
      y ||= Date.today.year
      m ||= Date.today.month
      mb = DateTime.new(y, m)
      me = m.to_i == 12 ? DateTime.new(y + 1, 1) : DateTime.new(y, m + 1)
      where(:id_date.gte => mb.to_time, :id_date.lt => me.to_time)
    end
    # @todo
    def by_unit_id(u)
      where(:unit_id => u)
    end
  end # Class methods
  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.unit_id) rescue nil
  end
  protected
  # @todo
  def init_name_date_expl
    self.name = "PV_din-#{Date.today.to_s}"
    self.id_date = Date.today
    self.text = I18n.t('trst_acc_cassation.text_value')
  end
  # @todo
  def destroy_freights
    self.freights.destroy_all
  end
  # @todo
  def update_value
    self.val = freights.sum(:val).round(2) rescue 0.0
  end
end
