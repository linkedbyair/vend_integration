require 'digest'
require 'active_support/all'

module Vend
  class ProductBuilder
    class << self
      def build(client, payload)
        sku = payload['sku'].presence || "spree-#{payload['source_id']}"
        handle = payload['permalink']
        hash = {
            'source_id'         => payload['source_id'],
            'handle'            => handle,
            'tags'              => payload['tags'],
            'name'              => payload['name'],
            'description'       => payload['description'],
            'sku'               => sku,
            'retail_price'      => payload['price'],
            'supply_price'      => payload['cost_price'],
            'brand_name'        => get_brand_on_taxons(payload['taxons'])
        }

        hash[:id] = payload['id'] if payload.has_key?('id')

        %w(one two three).each_with_index do |opt, index|
          hash.merge!(
            "variant_option_#{opt}_name" => payload["options"].keys[index],
            "variant_option_#{opt}_value" => payload["options"].values[index],
          )
        end

        hash
      end

      def parse_product(product)
        hash = {
                :id                 => product['id'],
                :channel            => 'Vend',
                'name'              => product['name'].split("/")[0],
                'source_id'         => product['source_id'],
                'sku'               => product['sku'],
                'description'       => product['description'],
                'price'             => product['price'],
                'permalink'         => product['sku'],
                'meta_keywords'     => product['tags'],
                'updated_at'        => product['updated_at'],
                'images'=> [
                  {
                    'url'=> product['image']
                  }
                ]
              }
        hash['taxons'] = [['Brands', product['brand_name']]] if product['brand_name'] && ! product['brand_name'].empty?
        hash
      end

      private

      def get_brand_on_taxons(taxons)
        (taxons&.select{ |item| item.first == 'Brands' }&.first&.drop(1)&.join('/')) || ''
      end
    end
  end
end
