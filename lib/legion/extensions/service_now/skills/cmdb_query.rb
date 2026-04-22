# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Skills
        class CmdbQuery < Legion::LLM::Skills::Base
          skill_name 'servicenow:cmdb_query'
          namespace  'servicenow'
          description 'Guides through CMDB configuration item lookup and relationship exploration'
          trigger :on_demand
          trigger_words 'CMDB', 'CI', 'configuration item', 'asset', 'cmdb_ci', 'server lookup'

          steps :clarify_query,
                :scope_search,
                :present_results,
                :complete

          def clarify_query(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Clarifying CMDB query: what CI class and attributes are you looking for?',
              metadata: { step: 'clarify_query' },
              gate:     :confirm
            )
          end

          def scope_search(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Scoping CMDB search by class, name, and environment.',
              metadata: { step: 'scope_search' }
            )
          end

          def present_results(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Presenting CMDB query results with relationships.',
              metadata: { step: 'present_results' }
            )
          end

          def complete(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'CMDB query complete.',
              metadata: { step: 'complete' }
            )
          end
        end
      end
    end
  end
end
