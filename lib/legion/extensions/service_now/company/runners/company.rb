# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Company
        module Runners
          module Company
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_companies(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/core_company', params)
              { companies: resp.body['result'] }
            end

            def get_company(sys_id:, **)
              resp = connection(**).get("/api/now/table/core_company/#{sys_id}")
              { company: resp.body['result'] }
            end

            def create_company(name:, phone: nil, website: nil,
                               stock_symbol: nil, publicly_traded: nil, **)
              body = { name: name }
              body[:phone]           = phone if phone
              body[:website]         = website if website
              body[:stock_symbol]    = stock_symbol if stock_symbol
              body[:publicly_traded] = publicly_traded unless publicly_traded.nil?
              resp = connection(**).post('/api/now/table/core_company', body)
              { company: resp.body['result'] }
            end

            def update_company(sys_id:, name: nil, phone: nil, website: nil, **)
              body = {}
              body[:name]    = name if name
              body[:phone]   = phone if phone
              body[:website] = website if website
              resp = connection(**).patch("/api/now/table/core_company/#{sys_id}", body)
              { company: resp.body['result'] }
            end

            def delete_company(sys_id:, **)
              resp = connection(**).delete("/api/now/table/core_company/#{sys_id}")
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
