module Zesty
  module Refinements
    module CamelCase
      refine Hash do

        def to_camel_case(data = self)
          case data
          when Array
            data.map { |value| to_camel_case(value) }
          when Hash
            data.map { |key, value| [camel_case_key(key), to_camel_case(value)] }.to_h
          else
            data
          end
        end

        private

        def camel_case_key(key)
          case key
          when Symbol
            camel_case(key.to_s).to_sym
          when String
            camel_case(key).to_sym
          else
            key
          end
        end

        def camel_case(string)
          @acronyms ||= { 'id' => 'ID', 'zuid' => 'ZUID' }
          @acronym_regex ||= /#{@acronyms.values.join("|")}/
          @acronyms_camelize_regex ||= /^(?:#{@acronym_regex}(?=\b|[A-Z_])|\w)/
          @acronyms_underscore_regex ||= /(?:(?<=([A-Za-z\d]))|\b)(#{@acronym_regex})(?=\b|[^a-z])/

          result = string.sub(/^[a-z\d]*/) { |match| @acronyms[match] || match }

          if !result.start_with?("_") # e.g. ignore "_meta", "_meta_title", etc.
            result = result.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{@acronyms[$2] || $2.capitalize}" }
          end

          result
        end

      end
    end
  end
end
