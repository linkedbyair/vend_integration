require 'spec_helper'

describe VendEndpoint do
  def app
    VendEndpoint
  end

  def auth
    {'HTTP_X_AUGURY_TOKEN' => '6a204bd89f3c8348afd5c77c717a097a', "CONTENT_TYPE" => "application/json"}
  end

  let(:order) { Factories.order }
  let(:original) { Factories.original }
  let(:params) { Factories.parameters }

  describe '/get_products' do
    context 'success' do
      it 'retrive products' do
        message = {
          request_id: '123456',
          parameters: params
        }.to_json

        VCR.use_cassette('get_products') do
          post '/get_products', message, auth
          last_response.status.should == 200
          last_response.body.should match /products were retrieved/
        end
      end
    end
  end

  describe '/get_inventory' do
    context 'success' do
      it 'retrive inventory' do
        message = {
          request_id: '123456',
          parameters: params
        }.to_json

        VCR.use_cassette('get_inventory') do
          post '/get_inventory', message, auth
          last_response.status.should == 200
          last_response.body.should match /inventories were retrieved/
        end
      end
    end
  end

  describe '/get_customers' do
    context 'success' do
      it 'retrive customers' do
        message = {
          request_id: '123456',
          parameters: params
        }.to_json

        VCR.use_cassette('get_customers') do
          post '/get_customers', message, auth
          last_response.status.should == 200
          last_response.body.should match /customers were retrieved/
        end
      end
    end
  end

  describe '/get_orders' do
    context 'success' do
      it 'retrive orders' do
        message = {
          request_id: '123456',
          parameters: params
        }.to_json

        VCR.use_cassette('get_orders') do
          post '/get_orders', message, auth
          last_response.status.should == 200
          last_response.body.should match /orders were retrieved/
        end
      end
    end
  end

  describe '/add_order' do
    let(:register_id) { "32aed862-08f5-11e4-a0f5-b8ca3a64f8f4" }
    let(:payment_type_id) {  "b8ca3a64-f8a8-11e4-e0f5-0e6e5ecb3073" }
    let(:order_response) { double("response", :[] => nil, :code => 200) }

    context 'success' do
      it 'imports new orders' do
        message = {
          request_id: '123456',
          order: order,
          parameters: params
        }.to_json

        Vend::Client.any_instance.stub(:register_id => register_id )
        Vend::Client.any_instance.stub(:payment_type_id => register_id )
        Vend::Client.any_instance.stub(:send_order => order_response )

        VCR.use_cassette('send_order') do
          post '/add_order', message, auth
          last_response.status.should == 200
          last_response.body.should match /was sent to Vend/
        end
      end
    end
  end


end
