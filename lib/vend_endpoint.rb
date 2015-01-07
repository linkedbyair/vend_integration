require_relative './vend/client'
require_relative './vend/error_parser'
require_relative './vend/order_builder'
require_relative './vend/customer_builder'
require_relative './vend/product_builder'

class VendEndpointError < StandardError; end
