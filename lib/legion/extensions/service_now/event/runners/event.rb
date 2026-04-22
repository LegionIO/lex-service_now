# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Event
        module Runners
          module Event
            include Legion::Extensions::ServiceNow::Helpers::Client

            def create_event(name:, source:, resource: nil, node: nil,
                             severity: '5', description: nil, **)
              body = { name: name, source: source, severity: severity }
              body[:resource]    = resource if resource
              body[:node]        = node if node
              body[:description] = description if description
              resp = post('/api/now/table/sysevent', body, **)
              { event: resp.body['result'] }
            end

            def list_events(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/sysevent', params, **)
              { events: resp.body['result'] }
            end

            def get_event(sys_id:, **)
              resp = get("/api/now/table/sysevent/#{sys_id}", {}, **)
              { event: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
