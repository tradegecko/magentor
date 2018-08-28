module MagentoAPI
  # https://devdocs.magento.com/guides/m1x/api/soap/catalog/catalogProduct/catalog_product.listOfAdditionalAttributes.html
  # ListOfAdditionalAttributes

  class CatalogProduct < Base
    class << self
      def list_of_additional_attributes(product_type, attribute_set_id)
        commit('listOfAdditionalAttributes', product_type, attribute_set_id)
      end
    end
  end
end
