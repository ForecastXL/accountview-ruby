# Custom encoder
module Accountview
  class DoNotEncoder
    class << self
      extend Forwardable
      def_delegators :'Faraday::Utils', :escape, :unescape
    end

    def self.encode(params)
      return nil if params == nil
      buffer = ''
      params.each do |key, value|
        # encoded_parent = escape(parent)
        buffer << "#{key}=#{value}&"
      end
      return buffer.chop
    end

    def self.decode(query)
      return nil if query == nil
      # Recursive helper lambda
      dehash = lambda do |hash|
        hash.each do |(key, value)|
          if value.kind_of?(Hash)
            hash[key] = dehash.call(value)
          end
        end
        # Numeric keys implies an array
        if hash != {} && hash.keys.all? { |key| key =~ /^\d+$/ }
          hash.sort.inject([]) do |accu, (_, value)|
            accu << value; accu
          end
        else
          hash
        end
      end

      empty_accumulator = {}
      return ((query.split('&').map do |pair|
        pair.split('=', 2) if pair && !pair.empty?
      end).compact.inject(empty_accumulator.dup) do |accu, (key, value)|
        #key = unescape(key)
        key = key
        if value.kind_of?(String)
          #value = unescape(value.gsub(/\+/, ' '))
          value = value
        end

        array_notation = !!(key =~ /\[\]$/)
        subkeys = key.split(/[\[\]]+/)
        current_hash = accu
        for i in 0...(subkeys.size - 1)
          subkey = subkeys[i]
          current_hash[subkey] = {} unless current_hash[subkey]
          current_hash = current_hash[subkey]
        end
        if array_notation
          current_hash[subkeys.last] = [] unless current_hash[subkeys.last]
          current_hash[subkeys.last] << value
        else
          current_hash[subkeys.last] = value
        end
        accu
      end).inject(empty_accumulator.dup) do |accu, (key, value)|
        accu[key] = value.kind_of?(Hash) ? dehash.call(value) : value
        accu
      end
    end
  end
end
