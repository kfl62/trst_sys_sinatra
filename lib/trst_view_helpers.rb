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
    end #Class methods
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
  end # ViewHelpers
end # Trst

class String
  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.empty? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
  def to_search_extended
    self.gsub(/[aeioust]/, 'a'=>"\[a|ă|â|á|î\]", 'e'=>"\[e|é\]", 'i'=>"\[i|î|í|â\]", 'o'=>"\[o|ó|ö|ő\]", 'u'=>"\[u|ú|ü|ű\]", 's'=>"\[s|\u015F|\u0219\]", 't'=>"\[t|\u0163|\u021B\]")
  end
end
