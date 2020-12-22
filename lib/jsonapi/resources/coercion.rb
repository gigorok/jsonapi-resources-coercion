require "jsonapi/resources/coercion/version"

module JSONAPI
  module Resources
    module Coercion

      class CoercionError < RuntimeError
      end

      def self.prepended(base)
        class << base
          prepend(ClassMethods)
        end
      end

      module ClassMethods

        DEFAULT_PRECISION = 14

        def verify_filter(filter, raw, context = nil)
          verified_filter = super
          filter_type = _allowed_filters.fetch(filter, Hash.new)[:type]
          filter_name = verified_filter[0]
          if filter_type
            wrapped_filters = if verified_filter[1].empty? # nil or empty array
                                [nil]
                              else
                                Array.wrap(verified_filter[1])
                              end
            coerced_values = wrapped_filters.map do |val|
              begin
                if val.blank? # nil or empty string
                  # if _allowed_filters.fetch(filter, Hash.new).fetch(:allow_nil, true)
                  #   nil
                  # else
                  #   raise CoercionError
                  # end
                  nil
                else
                  coerce(val, filter_type)
                end
              rescue CoercionError => _e
                raise JSONAPI::Exceptions::InvalidFilterValue.new(filter_name, val)
              end
            end
            [filter_name, coerced_values]
          else
            verified_filter
          end
        end

        def coerce_as_integer!(val)
          Integer(val)
        rescue ArgumentError
          raise CoercionError
        end

        def coerce_as_string!(val)
          String(val)
        rescue ArgumentError
          raise CoercionError
        end

        def coerce_as_float!(val)
          Float(val)
        rescue ArgumentError
          raise CoercionError
        end

        def coerce_as_boolean!(val)
          (/^(false|f|no|n|0)$/i === val.to_s ? false : (/^(true|t|yes|y|1)$/i === val.to_s ? true : (raise CoercionError)))
        end

        def coerce_as_big_decimal!(val)
          raise CoercionError unless val.to_s.strip =~ /[0-9.]+/
          BigDecimal(val.to_s.strip, DEFAULT_PRECISION)
        end

        alias_method :coerce_as_decimal!, :coerce_as_big_decimal!

        def coerce_as_date!(val)
          Date.parse(val)
        rescue ArgumentError
          raise CoercionError
        end

        def coerce_as_date_time!(val)
          DateTime.parse(val)
        rescue ArgumentError
          raise CoercionError
        end

        alias_method :coerce_as_datetime!, :coerce_as_date_time!

        def coerce_as_time!(val)
          Time.parse(val)
        rescue ArgumentError
          raise CoercionError
        end

        private

        def coerce(val, type)
          coerce_method = "coerce_as_#{type}!"
          if self.respond_to?(coerce_method.to_sym)
            send(coerce_method, val)
          else
            raise CoercionError
          end
        end
      end
    end
  end
end

JSONAPI::Resource.prepend JSONAPI::Resources::Coercion
