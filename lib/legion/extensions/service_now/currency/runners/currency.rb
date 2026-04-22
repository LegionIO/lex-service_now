# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Currency
        module Runners
          module Currency
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_currencies(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = connection(**).get('/api/now/table/fx_currency', params)
              { currencies: resp.body['result'] }
            end

            def get_currency(sys_id:, **)
              resp = connection(**).get("/api/now/table/fx_currency/#{sys_id}")
              { currency: resp.body['result'] }
            end

            def list_exchange_rates(from_currency: nil, to_currency: nil,
                                    sysparm_limit: 100, **)
              params = { sysparm_limit: sysparm_limit }
              query_parts = []
              query_parts << "from_cur=#{from_currency}" if from_currency
              query_parts << "to_cur=#{to_currency}" if to_currency
              params[:sysparm_query] = query_parts.join('^') unless query_parts.empty?
              resp = connection(**).get('/api/now/table/fx_rate', params)
              { exchange_rates: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
