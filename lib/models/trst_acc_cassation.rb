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

  before_create :increment_name_date
  before_destroy :destroy_freights

  class << self
    # @todo
    def pos(slg)
      where(:unit_id => TrstFirm.unit_id_by_unit_slug(slg)).asc(:name)
    end
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
      me = m.to_i == 12 ? DateTime.new(y + 1, 1) : DateTime.new(y, m + 1)
      where(:id_date.gte => mb.to_time, :id_date.lt => me.to_time).asc(:name)
    end
    # @todo
    def by_unit_id(u)
      where(:unit_id => u).asc(:name)
    end
  end # Class methods
end
