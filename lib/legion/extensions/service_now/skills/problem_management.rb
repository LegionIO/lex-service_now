# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Skills
        class ProblemManagement < Legion::LLM::Skills::Base
          skill_name 'servicenow:problem_management'
          namespace  'servicenow'
          description 'Guides through ServiceNow problem management — root cause analysis and resolution'
          trigger :on_demand
          trigger_words 'PRB', 'problem', 'root cause', 'RCA', 'known error', 'workaround', 'recurring incident'

          steps :identify_problem,
                :investigate_root_cause,
                :document_workaround,
                :implement_fix,
                :complete

          def identify_problem(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Identifying the problem record and linking related incidents.',
              metadata: { step: 'identify_problem' }
            )
          end

          def investigate_root_cause(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Investigating root cause using incident history and audit trail.',
              metadata: { step: 'investigate_root_cause' },
              gate:     :confirm
            )
          end

          def document_workaround(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Documenting workaround and marking as known error if applicable.',
              metadata: { step: 'document_workaround' }
            )
          end

          def implement_fix(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Implementing permanent fix and closing the problem record.',
              metadata: { step: 'implement_fix' },
              gate:     :confirm
            )
          end

          def complete(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Problem management workflow complete.',
              metadata: { step: 'complete' }
            )
          end
        end
      end
    end
  end
end
