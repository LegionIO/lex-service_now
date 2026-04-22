# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Skills
        class Incident < Legion::LLM::Skills::Base
          skill_name 'servicenow:incident'
          namespace  'servicenow'
          description 'Guides through ServiceNow incident response workflow'
          trigger :on_demand
          trigger_words 'incident', 'INC', 'outage', 'p1', 'sev1', 'production down', 'service down'

          steps :gather_context,
                :assess_severity,
                :determine_action,
                :confirm_with_user,
                :complete

          def gather_context(context: {})
            Legion::LLM::Skills::StepResult.new(
              inject:   "Gathering incident context from ServiceNow. Project: #{detect_project(context)}",
              metadata: { step: 'gather_context' }
            )
          end

          def assess_severity(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Assessing incident severity based on impact and urgency.',
              metadata: { step: 'assess_severity' }
            )
          end

          def determine_action(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Determining recommended action: escalate, assign, or resolve.',
              metadata: { step: 'determine_action' },
              gate:     :confirm
            )
          end

          def confirm_with_user(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Awaiting user confirmation before proceeding.',
              metadata: { step: 'confirm_with_user' }
            )
          end

          def complete(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Incident workflow complete.',
              metadata: { step: 'complete' }
            )
          end
        end
      end
    end
  end
end
