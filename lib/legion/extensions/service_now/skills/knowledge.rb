# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Skills
        class Knowledge < Legion::LLM::Skills::Base
          skill_name 'servicenow:knowledge'
          namespace  'servicenow'
          description 'Guides through ServiceNow knowledge base article search and retrieval'
          trigger :on_demand
          trigger_words 'KB', 'knowledge base', 'knowledge article', 'how to', 'documentation search'

          steps :gather_search_terms,
                :search_articles,
                :present_results,
                :complete

          def gather_search_terms(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'What are you looking for in the knowledge base?',
              metadata: { step: 'gather_search_terms' },
              gate:     :confirm
            )
          end

          def search_articles(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Searching ServiceNow knowledge base.',
              metadata: { step: 'search_articles' }
            )
          end

          def present_results(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Presenting matching knowledge articles.',
              metadata: { step: 'present_results' }
            )
          end

          def complete(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Knowledge search complete.',
              metadata: { step: 'complete' }
            )
          end
        end
      end
    end
  end
end
