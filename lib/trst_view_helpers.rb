# encoding: utf-8
module Trst
  module ViewHelpers
    extend ActiveSupport::Concern

    K,M,G,T, = [10,20,30,40].map{|v| 2.0**v}

    module ClassMethods
      # @todo
      def default_sort
        asc(:name)
      end
    end
    # @todo
    def view_filter
      [id, name]
    end
    # @todo
    def nice_bytes( bytes, max_digits=3 )
      value, suffix, precision = case bytes
      when 0...K
        [ bytes, 'b', 0 ]
      else
        value, suffix = case bytes
        when K...M then [ bytes / K, 'kB' ]
        when M...G then [ bytes / M, 'MB' ]
        when G...T then [ bytes / G, 'GB' ]
        else            [ bytes / T, 'TB' ]
        end
        used_digits = case value
        when   0...10   then 1
        when  10...100  then 2
        when 100...1024 then 3
        end
        leftover_digits = max_digits - used_digits
        [ value, suffix, leftover_digits > 0 ? leftover_digits : 0 ]
      end
      "%.#{precision}f#{suffix}" % value
    end
  end
end
