# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::ScriptAction::Runners::ScriptAction do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_script_actions' do
    it 'returns script actions' do
      @stubs.get('/api/now/table/sysevent_script_action') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'sa1', 'name' => 'Create Incident' }] }]
      end
      expect(@instance.list_script_actions[:script_actions]).to be_an(Array)
    end
  end

  describe '#create_script_action' do
    it 'creates a script action' do
      @stubs.post('/api/now/table/sysevent_script_action') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'sa2', 'name' => 'New Action' } }]
      end
      result = @instance.create_script_action(
        name: 'New Action', event_name: 'incident.created',
        script: 'current.setState(2);'
      )
      expect(result[:script_action]['name']).to eq('New Action')
    end
  end

  describe '#delete_script_action' do
    it 'deletes a script action' do
      @stubs.delete('/api/now/table/sysevent_script_action/sa1') { [204, {}, nil] }
      expect(@instance.delete_script_action(sys_id: 'sa1')[:deleted]).to be true
    end
  end
end
