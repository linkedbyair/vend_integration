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

  describe '/add_order' do
    context 'success' do
      it 'imports new orders' do
        message = {
          request_id: '123456',
          order: order,
          parameters: params
        }.to_json

        VCR.use_cassette('import_new_order') do
          post '/add_order', message, auth
          last_response.should == ""
          last_response.status.should == 200
          last_response.body.should match /was sent to Jirafe/
        end
      end
    end

    # context 'failure' do
    #   it 'returns error details 'do
    #     order = Factories.order.merge({ :number => nil })

    #     message = {
    #       request_id: '123456',
    #       order: order,
    #       parameters: params
    #     }.to_json

    #     VCR.use_cassette('import_order_fail') do
    #       post '/add_order', message, auth
    #       last_response.status.should == 500
    #       last_response.body.should match /None is not of type/
    #     end
    #   end
    # end
  end


end
