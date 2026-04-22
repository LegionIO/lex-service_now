# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Cmdb
        module Meta
          module Runners
            module Meta
              include Legion::Extensions::ServiceNow::Helpers::Client

              def get_hierarchy(**)
                resp = get('/api/now/doc/meta/hierarchy', {}, **)
                { hierarchy: resp.body['result'] }
              end

              def get_class_meta(class_name:, **)
                resp = get("/api/now/doc/meta/#{class_name}", {}, **)
                { meta: resp.body['result'] }
              end

              include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                          Legion::Extensions::Helpers.const_defined?(:Lex, false)
            end
          end
        end
      end
    end
  end
end
