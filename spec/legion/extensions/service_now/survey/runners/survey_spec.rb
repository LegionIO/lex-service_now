# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Survey::Runners::Survey do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_surveys' do
    it 'returns surveys' do
      @stubs.get('/api/now/table/survey') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'sv1', 'name' => 'CSAT Survey' }] }]
      end
      expect(@instance.list_surveys[:surveys]).to be_an(Array)
    end
  end

  describe '#get_survey' do
    it 'returns a survey' do
      @stubs.get('/api/now/table/survey/sv1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'sv1', 'name' => 'CSAT Survey' } }]
      end
      expect(@instance.get_survey(sys_id: 'sv1')[:survey]['sys_id']).to eq('sv1')
    end
  end

  describe '#list_survey_instances' do
    it 'returns survey instances' do
      @stubs.get('/api/now/table/asmt_assessment_instance') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'si1' }] }]
      end
      expect(@instance.list_survey_instances[:survey_instances]).to be_an(Array)
    end
  end
end
