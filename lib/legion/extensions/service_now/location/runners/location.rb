# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Location
        module Runners
          module Location
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_locations(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/cmn_location', params, **)
              { locations: resp.body['result'] }
            end

            def get_location(sys_id:, **)
              resp = get("/api/now/table/cmn_location/#{sys_id}", {}, **)
              { location: resp.body['result'] }
            end

            def create_location(name:, street: nil, city: nil, state: nil,
                                country: nil, zip: nil, phone: nil, **)
              body = { name: name }
              body[:street]  = street if street
              body[:city]    = city if city
              body[:state]   = state if state
              body[:country] = country if country
              body[:zip]     = zip if zip
              body[:phone]   = phone if phone
              resp = post('/api/now/table/cmn_location', body, **)
              { location: resp.body['result'] }
            end

            def update_location(sys_id:, name: nil, street: nil, city: nil,
                                country: nil, **)
              body = {}
              body[:name]    = name if name
              body[:street]  = street if street
              body[:city]    = city if city
              body[:country] = country if country
              resp = patch("/api/now/table/cmn_location/#{sys_id}", body, **)
              { location: resp.body['result'] }
            end

            def delete_location(sys_id:, **)
              resp = delete("/api/now/table/cmn_location/#{sys_id}", **)
              { deleted: resp.status == 204, sys_id: sys_id }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
