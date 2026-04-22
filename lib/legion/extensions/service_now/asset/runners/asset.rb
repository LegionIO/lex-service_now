# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Asset
        module Runners
          module Asset
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_assets(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil,
                            sysparm_fields: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query]  = sysparm_query if sysparm_query
              params[:sysparm_fields] = sysparm_fields if sysparm_fields
              resp = connection(**).get('/api/now/table/alm_asset', params)
              { assets: resp.body['result'] }
            end

            def get_asset(sys_id:, **)
              resp = connection(**).get("/api/now/table/alm_asset/#{sys_id}")
              { asset: resp.body['result'] }
            end

            def create_asset(model:, model_category:, serial_number: nil,
                             assigned_to: nil, state: nil, **)
              body = { model: model, model_category: model_category }
              body[:serial_number] = serial_number if serial_number
              body[:assigned_to]   = assigned_to if assigned_to
              body[:state]         = state if state
              resp = connection(**).post('/api/now/table/alm_asset', body)
              { asset: resp.body['result'] }
            end

            def update_asset(sys_id:, state: nil, assigned_to: nil,
                             location: nil, serial_number: nil, **)
              body = {}
              body[:state]         = state if state
              body[:assigned_to]   = assigned_to if assigned_to
              body[:location]      = location if location
              body[:serial_number] = serial_number if serial_number
              resp = connection(**).patch("/api/now/table/alm_asset/#{sys_id}", body)
              { asset: resp.body['result'] }
            end

            def delete_asset(sys_id:, **)
              resp = connection(**).delete("/api/now/table/alm_asset/#{sys_id}")
              { deleted: resp.status == 204, sys_id: sys_id }
            end

            def list_hardware(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/alm_hardware', params)
              { hardware: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
