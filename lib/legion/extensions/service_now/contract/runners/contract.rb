# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Contract
        module Runners
          module Contract
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_contracts(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/ast_contract', params)
              { contracts: resp.body['result'] }
            end

            def get_contract(sys_id:, **)
              resp = connection(**).get("/api/now/table/ast_contract/#{sys_id}")
              { contract: resp.body['result'] }
            end

            def create_contract(short_description:, vendor: nil, start_date: nil,
                                end_date: nil, value: nil, **)
              body = { short_description: short_description }
              body[:vendor]     = vendor if vendor
              body[:start_date] = start_date if start_date
              body[:end_date]   = end_date if end_date
              body[:value]      = value if value
              resp = connection(**).post('/api/now/table/ast_contract', body)
              { contract: resp.body['result'] }
            end

            def update_contract(sys_id:, state: nil, end_date: nil, value: nil, **)
              body = {}
              body[:state]    = state if state
              body[:end_date] = end_date if end_date
              body[:value]    = value if value
              resp = connection(**).patch("/api/now/table/ast_contract/#{sys_id}", body)
              { contract: resp.body['result'] }
            end

            def delete_contract(sys_id:, **)
              resp = connection(**).delete("/api/now/table/ast_contract/#{sys_id}")
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
