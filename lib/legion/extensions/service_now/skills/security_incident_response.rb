# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Skills
        class SecurityIncidentResponse < Legion::LLM::Skills::Base
          skill_name 'servicenow:security_incident_response'
          namespace  'servicenow'
          description 'Guides through ServiceNow security incident response and triage'
          trigger :on_demand
          trigger_words 'SIR', 'security incident', 'breach', 'phishing', 'malware', 'threat', 'vulnerability'

          steps :triage_security_incident,
                :contain_threat,
                :investigate,
                :remediate,
                :complete

          def triage_security_incident(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Triaging security incident: severity, affected systems, initial indicators.',
              metadata: { step: 'triage_security_incident' }
            )
          end

          def contain_threat(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Identifying containment actions to limit threat spread.',
              metadata: { step: 'contain_threat' },
              gate:     :confirm
            )
          end

          def investigate(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Investigating root cause, attack vector, and affected assets.',
              metadata: { step: 'investigate' }
            )
          end

          def remediate(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Remediating the threat and documenting lessons learned.',
              metadata: { step: 'remediate' },
              gate:     :confirm
            )
          end

          def complete(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Security incident response complete.',
              metadata: { step: 'complete' }
            )
          end
        end
      end
    end
  end
end
