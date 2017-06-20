# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magento/version'

Gem::Specification.new do |s|
  s.name = %q{magentor}
  s.version = MagentoAPI::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lachlan Priest"]
  s.date = %q{2014-11-06}
  s.email = %q{lachlan@tradegecko.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "TODOS",
     "init.rb",
     "lib/magento/base.rb",
     "lib/magento/category.rb",
     "lib/magento/category_attribute.rb",
     "lib/magento/connection.rb",
     "lib/magento/country.rb",
     "lib/magento/customer.rb",
     "lib/magento/customer_address.rb",
     "lib/magento/customer_group.rb",
     "lib/magento/inventory.rb",
     "lib/magento/invoice.rb",
     "lib/magento/invoice_line_item.rb",
     "lib/magento/order.rb",
     "lib/magento/order_line_item.rb",
     "lib/magento/product.rb",
     "lib/magento/product_attribute.rb",
     "lib/magento/product_attribute_set.rb",
     "lib/magento/product_link.rb",
     "lib/magento/product_media.rb",
     "lib/magento/product_stock.rb",
     "lib/magento/product_tier_price.rb",
     "lib/magento/product_type.rb",
     "lib/magento/region.rb",
     "lib/magento/shipment.rb",
     "lib/magento/store.rb",
     "lib/magento/version.rb",
     "lib/magentor.rb",
     "magentor.gemspec"
  ]
  s.homepage = %q{http://github.com/lcpriest/magentor}
  s.rdoc_options = ["--main", "README.rdoc", "--inline-source", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Ruby wrapper for the MagentoAPI xmlrpc api}
  s.add_dependency("xmlrpc")

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

