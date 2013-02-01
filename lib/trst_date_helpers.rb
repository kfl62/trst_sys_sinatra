# encoding: utf-8
module Trst
  module DateHelpers
    extend ActiveSupport::Concern

    module ClassMethods
      # @todo
      def yearly(y = nil)
        y ||= Date.today.year
        where(:id_date.gte => DateTime.new(y).to_time, :id_date.lt => DateTime.new(y + 1).to_time)
      end
      # @todo
      def monthly(y = nil,m = nil)
        y ||= Date.today.year
        m ||= Date.today.month
        mb = DateTime.new(y, m)
        me = m == 12 ? DateTime.new(y + 1, 1) : DateTime.new(y, m + 1)
        where(:id_date.gte => mb.to_time, :id_date.lt => me.to_time)
      end
      # @todo
      def period(y = nil,m = nil,d = nil,p = nil)
        y ||= Date.today.year
        m ||= Date.today.month
        d ||= Date.today.mday
        p ||= 1
        pb  = Time.utc(y,m,d)
        pe  = pb + p.day
        where(:id_date.gte => pb, :id_date.lt => pe)
      end
      # @todo
      def weekly(y = nil,w = nil)
        y ||= Date.today.year
        w ||= Date.today.cweek
        wb = Date.commercial(y, w, 1)
        we = Date.commercial(y, w, 7)
        where(:id_date.gte => wb.to_time, :id_date.lte => we.to_time)
      end
      # @todo
      def daily(y = nil,m = nil,d = nil)
        y ||= Date.today.year
        m ||= Date.today.month
        d ||= Date.today.mday
        where(:id_date => Time.utc(y,m,d))
      end
    end #Class methods

  end
end
