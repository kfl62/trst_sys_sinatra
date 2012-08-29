# encoding: utf-8
module Trst
  module DateHelpers
    extend ActiveSupport::Concern

    module ClassMethods
      # @todo
      def yearly(y = nil)
        y = y.to_i  if y.is_a? String
        y ||= Date.today.year
        where(:id_date.gte => DateTime.new(y).to_time, :id_date.lt => DateTime.new(y + 1).to_time)
      end
      # @todo
      def monthly(y = nil, m = nil)
        y,m = y.split('-').map{|s| s.to_i} if y.is_a? String
        y ||= Date.today.year
        m ||= Date.today.month
        mb = DateTime.new(y, m)
        me = m.to_i == 12 ? DateTime.new(y + 1, 1) : DateTime.new(y, m + 1)
        where(:id_date.gte => mb.to_time, :id_date.lt => me.to_time)
      end
      # @todo
      def weekly(y = nil, w = nil)
        y,w = y.split('-').map{|s| s.to_i} if y.is_a? String
        y ||= Date.today.year
        w ||= Date.today.cweek
        wb = Date.commercial(y, w, 1)
        we = Date.commercial(y, w, 7)
        where(:id_date.gte => wb.to_time, :id_date.lte => we.to_time)
      end
      # @todo
      def daily(y = nil, m = nil, d = nil)
        y,m,d = y.split('-').map{|s| s.to_i} if y.is_a? String
        y ||= Date.today.year
        m ||= Date.today.month
        d ||= Date.today.mday
        where(:id_date => Time.utc(y,m,d))
      end
    end #Class methods

  end
end
