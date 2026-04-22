# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Notification
        module Runners
          module Notification
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_notifications(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/sysevent_email_action', params)
              { notifications: resp.body['result'] }
            end

            def get_notification(sys_id:, **)
              resp = connection(**).get("/api/now/table/sysevent_email_action/#{sys_id}")
              { notification: resp.body['result'] }
            end

            def create_notification(name:, event_name:, recipient: nil, subject: nil,
                                    message_html: nil, active: true, **)
              body = { name: name, event_name: event_name, active: active }
              body[:recipient]     = recipient if recipient
              body[:subject]       = subject if subject
              body[:message_html]  = message_html if message_html
              resp = connection(**).post('/api/now/table/sysevent_email_action', body)
              { notification: resp.body['result'] }
            end

            def update_notification(sys_id:, name: nil, active: nil, subject: nil,
                                    message_html: nil, **)
              body = {}
              body[:name]         = name if name
              body[:active]       = active unless active.nil?
              body[:subject]      = subject if subject
              body[:message_html] = message_html if message_html
              resp = connection(**).patch("/api/now/table/sysevent_email_action/#{sys_id}", body)
              { notification: resp.body['result'] }
            end

            def delete_notification(sys_id:, **)
              resp = connection(**).delete("/api/now/table/sysevent_email_action/#{sys_id}")
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
