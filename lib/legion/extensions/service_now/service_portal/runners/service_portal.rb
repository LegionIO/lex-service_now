# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module ServicePortal
        module Runners
          module ServicePortal
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_portals(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = connection(**).get('/api/sn_sp/portal', params)
              { portals: resp.body['result'] }
            end

            def get_portal(sys_id:, **)
              resp = connection(**).get("/api/sn_sp/portal/#{sys_id}")
              { portal: resp.body['result'] }
            end

            def list_portal_pages(portal_sys_id:, sysparm_limit: 100, **)
              params = {
                sysparm_query: "sp_portal=#{portal_sys_id}",
                sysparm_limit: sysparm_limit
              }
              resp = connection(**).get('/api/now/table/sp_page', params)
              { pages: resp.body['result'] }
            end

            def get_portal_page(sys_id:, **)
              resp = connection(**).get("/api/now/table/sp_page/#{sys_id}")
              { page: resp.body['result'] }
            end

            def list_portal_widgets(portal_sys_id: nil, sysparm_limit: 100, **)
              params = { sysparm_limit: sysparm_limit }
              params[:sysparm_query] = "sp_portal=#{portal_sys_id}" if portal_sys_id
              resp = connection(**).get('/api/now/table/sp_widget', params)
              { widgets: resp.body['result'] }
            end

            def get_portal_widget(sys_id:, **)
              resp = connection(**).get("/api/now/table/sp_widget/#{sys_id}")
              { widget: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
