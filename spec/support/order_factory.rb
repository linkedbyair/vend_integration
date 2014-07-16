module Factories
  def self.order(payment_method=nil)
    {
      "number" => "311174282",
      "channel" => "spree",
      "email" => "spree@example.com",
      "currency" => "USD",
      "user_id" => "123",
      "visit_id" => "6590869538865152",
      "visitor_id" => "3821811678576640",
      "pageview_id" => "0",
      "placed_on" => "2013-07-30T19 =>19 =>05Z",
      "updated_at" => "2013-07-30T20 =>08 =>39Z",
      "status" => "complete",
      "totals" => {
          "item" => 99.95,
          "adjustment" => 15,
          "tax" => 5,
          "shipping" => 0,
          "payment" => 114.95,
          "order" => 114.95
      },
      "line_items"=> [
      {
        "id"=> 2,
        "quantity"=> 1,
        "price"=> "22.99",
        "created_at"=> "2013-12-23T16:13:11Z",
        "updated_at"=> "2013-12-23T16:13:11Z",
        "variant_id"=> 2,
        "variant"=> {
          "id"=> 2,
          "name"=> "Ruby on Rails Bag",
          "sku"=> "ROR-00012",
          "price"=> "22.99",
          "weight"=> nil,
          "height"=> nil,
          "width"=> nil,
          "depth"=> nil,
          "is_master"=> true,
          "cost_price"=> "21.0",
          "permalink"=> "ruby-on-rails-bag",
          "options_text"=> "",
          "option_values"=> [],
          "product_id"=> 2,
          "images"=> [
            {
              "id"=> 23,
              "position"=> 1,
              "attachment_content_type"=> "image/jpeg",
              "attachment_file_name"=> "ror_bag.jpeg",
              "type"=> "Spree=>=>Image",
              "attachment_updated_at"=> "2013-12-03T19=>54=>44Z",
              "attachment_width"=> 360,
              "attachment_height"=> 360,
              "alt"=> nil,
              "viewable_type"=> "Spree=>=>Variant",
              "viewable_id"=> 2,
              "attachment_url"=> "/spree/products/23/product/ror_bag.jpeg?1386100484"
            }
          ],
          "product"=> {
            "created_at"=>"2013-12-23T16:13:11Z",
            "updated_at"=>"2013-12-23T16:13:11Z",
            "taxons"=> [
              {
                "id"=>123,
                "name"=>"Foobar"
              },
              {
                "id"=>456,
                "taxonomy_id"=>3,
                "name"=>"Apache"
              }
            ]
          }
        }
      },
      {
        "id"=> 2,
        "quantity"=> 1,
        "price"=> "22.99",
        "created_at"=> "2013-12-23T16:13:11Z",
        "updated_at"=> "2013-12-23T16:13:11Z",
        "variant_id"=> 2,
        "variant"=> {
          "id"=> 2,
          "name"=> "Ruby on Rails Tote",
          "sku"=> "ROR-00013",
          "price"=> "22.99",
          "weight"=> nil,
          "height"=> nil,
          "width"=> nil,
          "depth"=> nil,
          "is_master"=> true,
          "cost_price"=> "21.0",
          "permalink"=> "ruby-on-rails-tote",
          "options_text"=> "",
          "option_values"=> [],
          "product_id"=> 2,
          "images"=> [
            {
              "id"=> 23,
              "position"=> 1,
              "attachment_content_type"=> "image/jpeg",
              "attachment_file_name"=> "ror_bag.jpeg",
              "type"=> "Spree=>=>Image",
              "attachment_updated_at"=> "2013-12-03T19=>54=>44Z",
              "attachment_width"=> 360,
              "attachment_height"=> 360,
              "alt"=> nil,
              "viewable_type"=> "Spree=>=>Variant",
              "viewable_id"=> 2,
              "attachment_url"=> "/spree/products/23/product/ror_bag.jpeg?1386100484"
            }
          ],
          "product"=> {
            "created_at"=>"2013-12-23T16:13:11Z",
            "updated_at"=>"2013-12-23T16:13:11Z",
            "taxons"=> [
              {
                "id"=>123,
                "name"=>"Foobar"
              },
              {
                "id"=>456,
                "taxonomy_id"=>3,
                "name"=>"Apache"
              }
            ]
          }
        }
      }
      ],
      "adjustments" => [
          {
              "name" => "Shipping",
              "value" => 5
          },
          {
              "name" => "Shipping",
              "value" => 5
          },
          {
              "name" => "North America 5.0%",
              "value" => 5
          }
      ],
      "shipping_address" => {
          "firstname" => "Brian",
          "lastname" => "Quinn",
          "address1" => "7735 Old Georgetown Rd",
          "address2" => " ",
          "zipcode" => "20814",
          "city" => "Bethesda",
          "state" => "MD",
          "country" => "US",
          "phone" => "555-123-456"
      },
      "billing_address" => {
          "firstname" => "Brian",
          "lastname" => "Quinn",
          "address1" => "7735 Old Georgetown Rd",
          "address2" => " ",
          "zipcode" => "20814",
          "city" => "Bethesda",
          "state" => "MD",
          "country" => "US",
          "phone" => "555-123-456"
      },
      "payments" => [
          {
              "number" => 6,
              "status" => "completed",
              "amount" => 5,
              "payment_method" => payment_method || 'credit card'
          }
      ],
      "shipments" => [
          {
              "number" => "H273910304",
              "cost" => 5,
              "status" => "shipped",
              "stock_location" => 'HQNYC',
              "shipping_method" => "UPS Ground (USD)",
              "tracking" => nil,
              "updated_at" => nil,
              "shipped_at" => "2013-07-30T20 =>08 =>38Z",
              "items" => [
                  {
                      "name" => "Spree Baseball Jersey",
                      "sku" => "SPR-00001",
                      "external_ref" => "",
                      "quantity" => 1,
                      "price" => 19.99,
                      "variant_id" => 8,
                      "options" => {}
                  },
                  {
                      "name" => "Ruby on Rails Baseball Jersey",
                      "sku" => "ROR-00004",
                      "external_ref" => "",
                      "quantity" => 1,
                      "price" => 19.99,
                      "variant_id" => 20,
                      "options" => {
                          "tshirt-color" => "Red",
                          "tshirt-size" => "Medium"
                      }
                  }
              ]
          },
          {
              "number" => "H982906499",
              "cost" => 5,
              "status" => "ready",
              "stock_location" => nil,
              "shipping_method" => "UPS Ground (USD)",
              "tracking" => "4532535354353452",
              "updated_at" => nil,
              "shipped_at" => nil,
              "items" => [
                  {
                      "name" => "Ruby on Rails Baseball Jersey",
                      "sku" => "ROR-00004",
                      "external_ref" => "",
                      "quantity" => 2,
                      "price" => 19.99,
                      "variant_id" => 20,
                      "options" => {
                          "tshirt-color" => "Red",
                          "tshirt-size" => "Medium"
                      }
                  },
                  {
                      "name" => "Spree Baseball Jersey",
                      "sku" => "SPR-00001",
                      "external_ref" => "",
                      "quantity" => 1,
                      "price" => 19.99,
                      "variant_id" => 8,
                      "options" => {}
                  }
              ]
          }
      ]
    }
  end

  def self.original
    {
      "user_id" => "123",
      "visit_id" => "6590869538865152",
      "visitor_id" => "3821811678576640",
      "pageview_id" => "0",
      "total"=> "9.99",
      "adjustment_total"=> "0.00",
      "ship_total"=> "10.0",
      "tax_total"=> "1.0",
      "email"=> "spree@example.com",
      "currency"=> "USD",
      "created_at"=> "2013-12-23T14:42:57Z",
      "updated_at"=> "2013-12-23T14:42:57Z",
      "last_pageview_id" => "0",
      "credit_cards" => [
        "id" => 3,
        "month" => "11",
        "year" => "2013",
        "cc_type" => "visa"
      ],
      "shipments" => [
        {
          "stock_location_name" => "Something"
        }
      ],
      "line_items"=> [
      {
        "id"=> 2,
        "quantity"=> 1,
        "price"=> "22.99",
        "created_at"=> "2013-12-23T16:13:11Z",
        "updated_at"=> "2013-12-23T16:13:11Z",
        "variant_id"=> 2,
        "variant"=> {
          "id"=> 2,
          "name"=> "Ruby on Rails Bag",
          "sku"=> "ROR-00012",
          "price"=> "22.99",
          "weight"=> nil,
          "height"=> nil,
          "width"=> nil,
          "depth"=> nil,
          "is_master"=> true,
          "cost_price"=> "21.0",
          "permalink"=> "ruby-on-rails-bag",
          "options_text"=> "",
          "option_values"=> [],
          "product_created_at"=> "2013-12-23T16:13:11Z",
          "product_updated_at"=> "2013-12-23T16:13:11Z",
          "product_id"=> 2,
          "images"=> [
            {
              "id"=> 23,
              "position"=> 1,
              "attachment_content_type"=> "image/jpeg",
              "attachment_file_name"=> "ror_bag.jpeg",
              "type"=> "Spree=>=>Image",
              "attachment_updated_at"=> "2013-12-03T19=>54=>44Z",
              "attachment_width"=> 360,
              "attachment_height"=> 360,
              "alt"=> nil,
              "viewable_type"=> "Spree=>=>Variant",
              "viewable_id"=> 2,
              "attachment_url"=> "/spree/products/23/product/ror_bag.jpeg?1386100484"
            }
          ],
          "product"=> {
            "taxons"=> [
              {
                "id"=>123,
                "name"=>"Foobar"
              },
              {
                "id"=>456,
                "taxonomy_id"=>3,
                "name"=>"Apache"
              }
            ]
          }
        }
      },
      {
        "id"=> 2,
        "quantity"=> 1,
        "price"=> "22.99",
        "created_at"=> "2013-12-23T16:13:11Z",
        "updated_at"=> "2013-12-23T16:13:11Z",
        "variant_id"=> 2,
        "variant"=> {
          "id"=> 2,
          "name"=> "Ruby on Rails Tote",
          "sku"=> "ROR-00013",
          "price"=> "22.99",
          "weight"=> nil,
          "height"=> nil,
          "width"=> nil,
          "depth"=> nil,
          "is_master"=> true,
          "cost_price"=> "21.0",
          "permalink"=> "ruby-on-rails-tote",
          "options_text"=> "",
          "option_values"=> [],
          "product_id"=> 2,
          "product_created_at"=> "2013-12-23T16:13:11Z",
          "product_updated_at"=> "2013-12-23T16:13:11Z",
          "images"=> [
            {
              "id"=> 23,
              "position"=> 1,
              "attachment_content_type"=> "image/jpeg",
              "attachment_file_name"=> "ror_bag.jpeg",
              "type"=> "Spree=>=>Image",
              "attachment_updated_at"=> "2013-12-03T19=>54=>44Z",
              "attachment_width"=> 360,
              "attachment_height"=> 360,
              "alt"=> nil,
              "viewable_type"=> "Spree=>=>Variant",
              "viewable_id"=> 2,
              "attachment_url"=> "/spree/products/23/product/ror_bag.jpeg?1386100484"
            }
          ],
          "product"=> {
            "taxons"=> [
              {
                "id"=>123,
                "name"=>"Foobar"
              },
              {
                "id"=>456,
                "taxonomy_id"=>3,
                "name"=>"Apache"
              }
            ]
          }
        }
      }
      ]
    }
  end
end
