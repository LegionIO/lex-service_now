# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Survey
        module Runners
          module Survey
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_surveys(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/survey', params)
              { surveys: resp.body['result'] }
            end

            def get_survey(sys_id:, **)
              resp = connection(**).get("/api/now/table/survey/#{sys_id}")
              { survey: resp.body['result'] }
            end

            def list_survey_instances(survey_sys_id: nil, sysparm_limit: 100,
                                      sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = "survey=#{survey_sys_id}" if survey_sys_id
              resp = connection(**).get('/api/now/table/asmt_assessment_instance', params)
              { survey_instances: resp.body['result'] }
            end

            def get_survey_instance(sys_id:, **)
              resp = connection(**).get("/api/now/table/asmt_assessment_instance/#{sys_id}")
              { survey_instance: resp.body['result'] }
            end

            def list_survey_responses(instance_sys_id:, sysparm_limit: 100, **)
              params = {
                sysparm_query: "instance=#{instance_sys_id}",
                sysparm_limit: sysparm_limit
              }
              resp = connection(**).get('/api/now/table/asmt_assessment_instance_question', params)
              { responses: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
