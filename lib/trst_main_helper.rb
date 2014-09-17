# encoding: utf-8
module Trst
  module MainHelpers
    extend ActiveSupport::Concern

    module ClassMethods
      # @todo
      def by_id_stats(ids,lst = false)
        c = ids.scan(/\d{2}/).each{|g| g.gsub!("00","\\d{2}")}.join
        result = where(id_stats: /#{c}/).asc(:name)
        if lst
          c = ids.gsub(/\d{2}$/,"\\d{2}")
          result = where(id_stats: /#{c}/).asc(:id_stats)
          result = ids == "00000000" ? ids : result.last.nil? ? ids.next : result.last.id_stats.next
        end
        result
      end
      # @todo
      def keys(p = 4)
        p ? all.map{|f| "#{f.id_stats}_#{"%.#{p}f" % f.pu}"}.uniq.sort! : \
            all.pluck(:id_stats).uniq.sort!
      end
      # @todo
      def by_key(key)
        id_stats, pu = key.split('_')
        pu.nil? ? where(id_stats: id_stats) : where(id_stats: id_stats, pu: pu.to_f)
      end
      # @todo
      def nonin(nin = true)
        where(id_intern: !nin)
      end
      # @todo
      def pos(s)
        uid = Trst::PartnerFirm.pos(s).id
        by_unit_id(uid)
      end
      # # @todo
      def sum_freights(*args)
        opts = args.last.is_a?(Hash) ? {what: :qu}.merge!(args.pop) : {what: :qu}
        y,m,d = *args; today = Date.today
        y,m,d = today.year, today.month, today.day unless ( y || m || d)
        v = opts[:what]
        if d
          daily(y,m,d).sum(v).round(2)
        elsif m
          monthly(y,m).sum(v).round(2)
        else
          yearly(y).sum(v).round(2)
        end
      end
    end #Class methods

    # @todo
    def freight_name
      freight.name
    end
    # @todo
    def freight_um
      freight.um rescue '-'
    end
    # @todo
    def freight_tva
      freight.tva
    end
    # @todo
    def unit_belongs_to
      Trst::PartnerFirm.unit_by_unit_id(unit_id)
    end
  end # MainHelpers
end # Trst
