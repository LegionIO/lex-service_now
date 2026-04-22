# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::IntegrationHub::Runners::IntegrationHub do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_action_types' do
    it 'returns action types' do
      @stubs.get('/api/now/table/sys_hub_action_type_definition') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'at1', 'name' => 'Create Incident' }] }]
      end
      expect(@instance.list_action_types[:action_types]).to be_an(Array)
    end
  end

  describe '#list_connections' do
    it 'returns connections' do
      @stubs.get('/api/now/table/sys_connection') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'cn1', 'name' => 'Jira Connection' }] }]
      end
      expect(@instance.list_connections[:connections]).to be_an(Array)
    end
  end

  describe '#list_credentials' do
    it 'returns credentials' do
      @stubs.get('/api/now/table/discovery_credential') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'cr1', 'name' => 'SSH Key' }] }]
      end
      expect(@instance.list_credentials[:credentials]).to be_an(Array)
    end
  end
end
