# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Vendor
        module Runners
          module Vendor
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_vendors(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/core_company',
                                        params.merge(sysparm_query: build_vendor_query(sysparm_query)))
              { vendors: resp.body['result'] }
            end

            def get_vendor(sys_id:, **)
              resp = connection(**).get("/api/now/table/core_company/#{sys_id}")
              { vendor: resp.body['result'] }
            end

            def create_vendor(name:, phone: nil, website: nil, vendor_type: nil, **)
              body = { name: name, vendor: true }
              body[:phone]       = phone if phone
              body[:website]     = website if website
              body[:vendor_type] = vendor_type if vendor_type
              resp = connection(**).post('/api/now/table/core_company', body)
              { vendor: resp.body['result'] }
            end

            def update_vendor(sys_id:, name: nil, phone: nil, website: nil, **)
              body = {}
              body[:name]    = name if name
              body[:phone]   = phone if phone
              body[:website] = website if website
              resp = connection(**).patch("/api/now/table/core_company/#{sys_id}", body)
              { vendor: resp.body['result'] }
            end

            def delete_vendor(sys_id:, **)
              resp = connection(**).delete("/api/now/table/core_company/#{sys_id}")
              { deleted: resp.status == 204, sys_id: sys_id }
            end

            private

            def build_vendor_query(extra_query)
              base = 'vendor=true'
              extra_query ? "#{base}^#{extra_query}" : base
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
