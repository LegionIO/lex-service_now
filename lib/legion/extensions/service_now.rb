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
