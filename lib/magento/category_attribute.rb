module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/catalog_category_attribute
  # 100  Requested store view not found.
  # 101  Requested attribute not found.
  # currentStore
  # list
  # options
  class CategoryAttribute < Base
    extend Magento::Helpers::Collection

    class << self
      # catalog_category_attribute.currentStore
      # Set/Get current store view
      #
      # Return: int
      #
      # Arguments:
      #
      # mixed storeView - Store view ID or code. (optional)
      def current_store(*args)
        commit("currentStore", *args)
      end

      # catalog_category_attribute.options
      # Retrieve attribute options
      #
      # Arguments:
      #
      # attributeId - attribute id or code
      # storeView - store view id or code
      def options(*args)
        commit("options", *args)
      end
    end
  end
end
