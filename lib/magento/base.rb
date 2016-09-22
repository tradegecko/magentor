# Base MagentoAPI model handles basic crud operations and stores connection to magento instance.
# It has the following class attributes:
#
# * <tt>connection</tt>: the MagentoAPI::Connection to use
#
# And the following instance attributes:
# * <tt>attributes</tt>: the attributes of the magento object
#
module MagentoAPI
  class Base
    attr_accessor :attributes

    def self.connection
      Thread.current[:magento_connection]
    end

    def self.connection=(connection)
      Thread.current[:magento_connection] = connection
    end

    module ClassMethods
      # Uses the classes name and method to make an rpc call through connection
      def commit(method, *args)
        # TODO: need to catch errors sent back from magento and bubble them up appropriately
        method = "#{api_path}.#{method}"

        MagentoAPI::Base.connection.call(method, *args)
      rescue RuntimeError => ex
        if ex.message.include?("Wrong content-type")
          raise InvalidResponseFormat.new(ex.message)
        else
          raise
        end
      end

      def api_path
        to_s.split('::').last.underscore.downcase
      end
    end

    module InstanceMethods
      def initialize(attributes = {})
        attributes = {} if attributes.empty?
        @attributes = attributes.dup.deep_symbolize_keys!
      end

      # TODO: find out if the id naming is consistent
      def id
        @attributes["#{self.class.to_s.split('::').last.underscore.downcase}_id".to_sym]
      end

      def id=(_id)
        @attributes["#{self.class.to_s.split('::').last.underscore.downcase}_id".to_sym] = _id
      end

      def object_attributes=(new_attributes)
        return if new_attributes.nil?
        attributes = new_attributes.dup.deep
        attributes.deep_symbolize_keys!
        attributes.each do |k, v|
          send(k + "=", v)
        end
      end

      # def respond_to_missing?(method_symbol, include_private = false)
      #   method_name =~ /(=|\?)$/ || @attributes.include?(method_symbol) || super
      # end

      def method_missing(method_symbol, *arguments)
        method_name = method_symbol.to_s

        if method_name =~ /(=|\?)$/
          case $1
          when "="
            @attributes[$`] = arguments.first
          when "?"
            @attributes[$`]
          end
        else
          if @attributes.include?(method_symbol)
            @attributes[method_symbol]
          else
            super
          end
        end
      end
    end

    include InstanceMethods
    extend ClassMethods
  end

  class InvalidResponseFormat < StandardError
    attr_reader :code

    def initialize(message)
      @code = "415"
      super(message)
    end
  end

  class ApiError < StandardError
    attr_reader :code

    def initialize(e)
      @initial_error = e
      @code = e.faultCode
      super("#{e.faultCode} -> #{e.faultString}")
    end
  end
end
