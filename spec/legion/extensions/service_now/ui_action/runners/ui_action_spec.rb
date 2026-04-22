# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::UiAction::Runners::UiAction do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_ui_actions' do
    it 'returns UI actions' do
      @stubs.get('/api/now/table/sys_ui_action') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ua1', 'name' => 'Resolve' }] }]
      end
      expect(@instance.list_ui_actions[:ui_actions]).to be_an(Array)
    end
  end

  describe '#create_ui_action' do
    it 'creates a UI action' do
      @stubs.post('/api/now/table/sys_ui_action') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ua2', 'name' => 'My Button' } }]
      end
      result = @instance.create_ui_action(
        name: 'My Button', table: 'incident',
        script: 'current.resolve();', action_type: 'button'
      )
      expect(result[:ui_action]['name']).to eq('My Button')
    end
  end

  describe '#delete_ui_action' do
    it 'deletes a UI action' do
      @stubs.delete('/api/now/table/sys_ui_action/ua1') { [204, {}, nil] }
      expect(@instance.delete_ui_action(sys_id: 'ua1')[:deleted]).to be true
    end
  end
end
