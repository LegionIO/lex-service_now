# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Tag
        module Runners
          module Tag
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_tags(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/label', params)
              { tags: resp.body['result'] }
            end

            def get_tag(sys_id:, **)
              resp = connection(**).get("/api/now/table/label/#{sys_id}")
              { tag: resp.body['result'] }
            end

            def create_tag(name:, color: nil, **)
              body = { name: name }
              body[:color] = color if color
              resp = connection(**).post('/api/now/table/label', body)
              { tag: resp.body['result'] }
            end

            def delete_tag(sys_id:, **)
              resp = connection(**).delete("/api/now/table/label/#{sys_id}")
              { deleted: resp.status == 204, sys_id: sys_id }
            end

            def list_tagged_records(tag_sys_id:, table_name: nil, sysparm_limit: 100, **)
              query = "label=#{tag_sys_id}"
              query += "^table=#{table_name}" if table_name
              params = { sysparm_query: query, sysparm_limit: sysparm_limit }
              resp = connection(**).get('/api/now/table/label_entry', params)
              { tagged_records: resp.body['result'] }
            end

            def add_tag_to_record(tag_sys_id:, table_name:, record_sys_id:, **)
              body = { label: tag_sys_id, table: table_name, id_display: record_sys_id }
              resp = connection(**).post('/api/now/table/label_entry', body)
              { tag_entry: resp.body['result'] }
            end

            def remove_tag_from_record(tag_entry_sys_id:, **)
              resp = connection(**).delete("/api/now/table/label_entry/#{tag_entry_sys_id}")
              { deleted: resp.status == 204, sys_id: tag_entry_sys_id }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
