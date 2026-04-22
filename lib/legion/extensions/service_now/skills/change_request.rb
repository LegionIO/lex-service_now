# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Skills
        class ChangeRequest < Legion::LLM::Skills::Base
          skill_name 'servicenow:change_request'
          namespace  'servicenow'
          description 'Guides through ServiceNow change request creation and CAB approval workflow'
          trigger :on_demand
          trigger_words 'CHG', 'RFC', 'change request', 'CAB', 'change advisory board', 'change management'

          steps :gather_requirements,
                :risk_assessment,
                :draft_and_review,
                :submit_for_approval,
                :complete

          def gather_requirements(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Gathering change requirements: scope, timeline, and affected systems.',
              metadata: { step: 'gather_requirements' }
            )
          end

          def risk_assessment(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Assessing risk: impact, likelihood, and rollback plan.',
              metadata: { step: 'risk_assessment' }
            )
          end

          def draft_and_review(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Drafting change request. Please review the details.',
              metadata: { step: 'draft_and_review' },
              gate:     :confirm
            )
          end

          def submit_for_approval(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Submitting change request for CAB approval.',
              metadata: { step: 'submit_for_approval' }
            )
          end

          def complete(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Change request submitted successfully.',
              metadata: { step: 'complete' }
            )
          end
        end
      end
    end
  end
end
