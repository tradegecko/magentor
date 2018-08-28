module MagentoAPI ##TODO
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/catalog_product_attribute_set
  # list
  # attributeAdd
  # attributeRemove
  # create
  # groupAdd
  # groupRemove
  # groupRename
  # remove
  class ProductAttributeSet < Base
    extend MagentoAPI::Helpers::Crud
    class << self
      undef :update, :find

      def create(attributes)
        commit("create", attributes[:name], attributes[:skeleton_id])
      end

      def group_add(id, name)
        commit("groupAdd", id, name)
      end

      def attribute_add(attribute_id, id, group_id)
        commit("attributeAdd", attribute_id, id, group_id)
      end

      def attributes(id, product_type='simple')
        MagentoAPI::CatalogProduct.list_of_additional_attributes(product_type, id)
      end

      def products(id)
        MagentoAPI::Product.commit('list', attribute_set_id: id)
      end
    end

  end
end
