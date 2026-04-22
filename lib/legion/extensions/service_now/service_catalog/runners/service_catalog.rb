# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module ServiceCatalog
        module Runners
          module ServiceCatalog
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_catalogs(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = connection(**).get('/api/sn_sc/servicecatalog/catalogs', params)
              { catalogs: resp.body['result'] }
            end

            def get_catalog(sys_id:, **)
              resp = connection(**).get("/api/sn_sc/servicecatalog/catalogs/#{sys_id}")
              { catalog: resp.body['result'] }
            end

            def get_category(sys_id:, **)
              resp = connection(**).get("/api/sn_sc/servicecatalog/categories/#{sys_id}")
              { category: resp.body['result'] }
            end

            def list_items(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil,
                           catalog_id: nil, category_id: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              params[:catalog_id]    = catalog_id if catalog_id
              params[:category_id]   = category_id if category_id
              resp = connection(**).get('/api/sn_sc/servicecatalog/items', params)
              { items: resp.body['result'] }
            end

            def get_item(sys_id:, **)
              resp = connection(**).get("/api/sn_sc/servicecatalog/items/#{sys_id}")
              { item: resp.body['result'] }
            end

            def get_item_variables(sys_id:, **)
              resp = connection(**).get("/api/sn_sc/servicecatalog/items/#{sys_id}/variables")
              { variables: resp.body['result'] }
            end

            def order_now(sys_id:, quantity: 1, variables: nil, **)
              body = { quantity: quantity }
              body[:variables] = variables if variables
              resp = connection(**).post("/api/sn_sc/servicecatalog/items/#{sys_id}/order_now", body)
              { request: resp.body['result'] }
            end

            def add_to_cart(sys_id:, quantity: 1, variables: nil, **)
              body = { quantity: quantity }
              body[:variables] = variables if variables
              resp = connection(**).post("/api/sn_sc/servicecatalog/items/#{sys_id}/add_to_cart", body)
              { cart: resp.body['result'] }
            end

            def get_cart(**)
              resp = connection(**).get('/api/sn_sc/servicecatalog/cart')
              { cart: resp.body['result'] }
            end

            def checkout_cart(**)
              resp = connection(**).post('/api/sn_sc/servicecatalog/cart/checkout', {})
              { order: resp.body['result'] }
            end

            def delete_cart(cart_id:, **)
              resp = connection(**).delete("/api/sn_sc/servicecatalog/cart/#{cart_id}")
              { deleted: resp.status == 204, cart_id: cart_id }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
