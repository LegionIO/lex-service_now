# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Account
        module Runners
          module Account
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_accounts(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/account', params, **)
              { accounts: resp.body['result'] }
            end

            def get_account(sys_id:, **)
              resp = get("/api/now/account/#{sys_id}", {}, **)
              { account: resp.body['result'] }
            end

            def create_account(name:, phone: nil, email: nil, **)
              body = { name: name }
              body[:phone] = phone if phone
              body[:email] = email if email
              resp = post('/api/now/account', body, **)
              { account: resp.body['result'] }
            end

            def update_account(sys_id:, name: nil, phone: nil, email: nil, **)
              body = {}
              body[:name]  = name if name
              body[:phone] = phone if phone
              body[:email] = email if email
              resp = patch("/api/now/account/#{sys_id}", body, **)
              { account: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
