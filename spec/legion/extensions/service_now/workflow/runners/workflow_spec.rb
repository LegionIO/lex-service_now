# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Workflow::Runners::Workflow do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_workflows' do
    it 'returns workflows' do
      @stubs.get('/api/now/table/wf_workflow') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'wf1', 'name' => 'Provision User' }] }]
      end
      expect(@instance.list_workflows[:workflows]).to be_an(Array)
    end
  end

  describe '#get_workflow' do
    it 'returns a workflow' do
      @stubs.get('/api/now/table/wf_workflow/wf1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'wf1', 'name' => 'Provision User' } }]
      end
      expect(@instance.get_workflow(sys_id: 'wf1')[:workflow]['sys_id']).to eq('wf1')
    end
  end

  describe '#list_workflow_contexts' do
    it 'returns workflow contexts' do
      @stubs.get('/api/now/table/wf_context') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'wc1', 'state' => 'executing' }] }]
      end
      expect(@instance.list_workflow_contexts[:contexts]).to be_an(Array)
    end
  end

  describe '#cancel_workflow_context' do
    it 'cancels a workflow context' do
      @stubs.patch('/api/now/table/wf_context/wc1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'wc1', 'state' => 'cancelled' } }]
      end
      expect(@instance.cancel_workflow_context(sys_id: 'wc1')[:context]['state']).to eq('cancelled')
    end
  end
end
