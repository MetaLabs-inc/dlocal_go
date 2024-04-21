require "active_support/all"

module DlocalGo
  module Responses
    module ResponseParser
      def self.included(base)
        base.class_eval { class_attribute :response_attributes, :response_associations, :array_data_attribute }

        base.extend(ClassMethods)

        def initialize(response, options = {})
          extract_options(options)

          assign_attributes(response)
          assign_associations(response)
        end
      end

      module ClassMethods
        def has_attributes(attributes)
          self.response_attributes = attributes

          class_eval { attr_reader(*attributes) }
        end

        def has_association(attribute, klass)
          self.response_associations ||= {}
          self.response_associations[attribute] = klass

          class_eval { attr_reader attribute }
        end

        def has_array_data_attribute(attribute)
          self.array_data_attribute = attribute
        end
      end

      private

      def extract_options(options)
        if options[:data_class]
          raise ArgumentError, "array_data_attribute is required" unless self.array_data_attribute

          class_eval { has_association(self.array_data_attribute, options[:data_class]) }
        end
      end

      def assign_attributes(response)
        return if self.response_attributes.nil?

        self.response_attributes.each do |attribute|
          instance_variable_set("@#{attribute}", response.send(attribute) || response.send(attribute.to_s.camelize(:lower)))
        end
      end

      def assign_associations(response)
        return if self.response_associations.nil?

        self.response_associations.each do |attribute, klass|
          response_data = response.send(attribute) || response.send(attribute.to_s.camelize(:lower))

          if response_data.class.name == "Array"
            mapped_data = response_data.map do |data|
              struct = OpenStruct.new(data)
              klass.new(struct)
            end

            instance_variable_set("@#{attribute}", mapped_data)
          else
            struct = OpenStruct.new(response_data)
            instance_variable_set("@#{attribute}", klass.new(struct))
          end
        end
      end
    end
  end
end
