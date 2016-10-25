# Ruby wrapper for the magento api
#
# Author::    Lachlan Priest  (mailto:lachlan@tradegecko.com)
# License::   MIT
#
# Inspiration from the MagentoAPI plugin from Tim Matheson (http://github.com/timmatheson/Magento)
# Inspiration from the MagentoAPI plugin from Preston Stuteville (http://github.com/pstuteville/magentor)

require "active_support/inflector"
require "logger"
require 'xmlrpc/client'

XMLRPC::Config.send(:remove_const, :ENABLE_NIL_PARSER)
XMLRPC::Config.send(:const_set, :ENABLE_NIL_PARSER, true)
XMLRPC::Config.send(:remove_const, :ENABLE_NIL_CREATE)
XMLRPC::Config.send(:const_set, :ENABLE_NIL_CREATE, true)

require 'magento/connection'
require 'magento/base'
require 'magento/helpers/collection'
require 'magento/helpers/crud'
require 'active_support/notifications'

module MagentoAPI
  autoload :CategoryAttribute,   "magento/category_attribute"
  autoload :Category,            "magento/category"
  autoload :Country,             "magento/country"
  autoload :CustomerAddress,     "magento/customer_address"
  autoload :CustomerGroup,       "magento/customer_group"
  autoload :Customer,            "magento/customer"
  autoload :Inventory,           "magento/inventory"
  autoload :Invoice,             "magento/invoice"
  autoload :InvoiceLineItem,     "magento/invoice_line_item"
  autoload :OrderLineItem,       "magento/order_line_item"
  autoload :Order,               "magento/order"
  autoload :ProductAttribute,    "magento/product_attribute"
  autoload :ProductAttributeSet, "magento/product_attribute_set"
  autoload :ProductLink,         "magento/product_link"
  autoload :ProductMedia,        "magento/product_media"
  autoload :Product,             "magento/product"
  autoload :ProductStock,        "magento/product_stock"
  autoload :ProductTierPrice,    "magento/product_tier_price"
  autoload :ProductType,         "magento/product_type"
  autoload :Region,              "magento/region"
  autoload :Shipment,            "magento/shipment"
  autoload :Store,               "magento/store"

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end
end
