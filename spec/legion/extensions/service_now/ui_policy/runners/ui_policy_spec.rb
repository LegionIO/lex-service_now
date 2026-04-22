# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::UiPolicy::Runners::UiPolicy do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_ui_policies' do
    it 'returns UI policies' do
      @stubs.get('/api/now/table/sys_ui_policy') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'up1', 'short_description' => 'Hide field' }] }]
      end
      expect(@instance.list_ui_policies[:ui_policies]).to be_an(Array)
    end
  end

  describe '#create_ui_policy' do
    it 'creates a UI policy' do
      @stubs.post('/api/now/table/sys_ui_policy') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'up2', 'short_description' => 'New Policy' } }]
      end
      result = @instance.create_ui_policy(table: 'incident', short_description: 'New Policy')
      expect(result[:ui_policy]['sys_id']).to eq('up2')
    end
  end

  describe '#delete_ui_policy' do
    it 'deletes a UI policy' do
      @stubs.delete('/api/now/table/sys_ui_policy/up1') { [204, {}, nil] }
      expect(@instance.delete_ui_policy(sys_id: 'up1')[:deleted]).to be true
    end
  end
end
