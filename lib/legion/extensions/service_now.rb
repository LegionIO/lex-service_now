# frozen_string_literal: true

require 'legion/extensions/service_now/version'
require 'legion/extensions/service_now/helpers/client'

require 'legion/extensions/service_now/change/runners/change'
require 'legion/extensions/service_now/cmdb/instance/runners/instance'
require 'legion/extensions/service_now/cmdb/meta/runners/meta'
require 'legion/extensions/service_now/knowledge/runners/knowledge'
require 'legion/extensions/service_now/service_catalog/runners/service_catalog'
require 'legion/extensions/service_now/account/runners/account'
require 'legion/extensions/service_now/incident/runners/incident'
require 'legion/extensions/service_now/problem/runners/problem'
require 'legion/extensions/service_now/attachment/runners/attachment'
require 'legion/extensions/service_now/table/runners/table'
require 'legion/extensions/service_now/aggregate/runners/aggregate'
require 'legion/extensions/service_now/user/runners/user'
require 'legion/extensions/service_now/user_group/runners/user_group'
require 'legion/extensions/service_now/request/runners/request'
require 'legion/extensions/service_now/approval/runners/approval'
require 'legion/extensions/service_now/task/runners/task'
require 'legion/extensions/service_now/sla/runners/sla'
require 'legion/extensions/service_now/import_set/runners/import_set'
require 'legion/extensions/service_now/event/runners/event'
require 'legion/extensions/service_now/performance_analytics/runners/performance_analytics'
require 'legion/extensions/service_now/flow/runners/flow'

require 'legion/extensions/service_now/client'

if defined?(Legion::LLM)
  require 'legion/extensions/service_now/skills/incident'
  require 'legion/extensions/service_now/skills/change_request'
  require 'legion/extensions/service_now/skills/cmdb_query'
  require 'legion/extensions/service_now/skills/knowledge'
  require 'legion/extensions/service_now/skills/service_catalog'
end

module Legion
  module Extensions
    module ServiceNow
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
