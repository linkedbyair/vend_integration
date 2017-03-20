module GetObjectsEndpoint
  def get_endpoint(name)
    name = name.to_s
    method = "get_#{name.pluralize}"
    post "/#{method}" do
      begin
        code = 200
        response = client.send(method, since: payload['after_version'])
        objects = response['data']
        set_summary "Retrieved #{objects.size} #{name.pluralize} from Vend"
        add_parameter :max_version, response['version']['max']
        if objects.any?
            objects.each do |object|              
            #flip between transfers, purchase orders & stocktake .... vend only has one exit point 
                   
                if name == 'purchase_order'                 
                   if   object['type'] == 'OUTLET' 
                        add_object 'transfer_order', object
                    elsif object['type'] == 'SUPPLIER' 
                          add_object 'purchase_order', object
                        elsif object['type'] == 'STOCKTAKE'
                              add_object 'inventory_adjustment', object 
                    end
                else 
                  add_object name, object
                end
            end
        else
          add_value name.pluralize, []
        end
      rescue VendEndpointError => e
        code = 500
        set_summary "Validation error has ocurred: #{e.message}"
      rescue => e
        code = 500
        error_notification(e)
      end

      process_result code
    end
  end
end
