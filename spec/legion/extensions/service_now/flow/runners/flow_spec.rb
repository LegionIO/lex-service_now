# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Flow::Runners::Flow do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_flows' do
    it 'returns flows' do
      @stubs.get('/api/sn_fd/flow') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'f1', 'name' => 'Provision User' }] }]
      end
      expect(@instance.list_flows[:flows]).to be_an(Array)
    end
  end

  describe '#get_flow' do
    it 'returns a single flow' do
      @stubs.get('/api/sn_fd/flow/f1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'f1', 'name' => 'Provision User' } }]
      end
      expect(@instance.get_flow(sys_id: 'f1')[:flow]['sys_id']).to eq('f1')
    end
  end

  describe '#execute_flow' do
    it 'executes a flow' do
      @stubs.post('/api/sn_fd/flow/f1/execute') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'executionId' => 'exec1', 'status' => 'running' } }]
      end
      result = @instance.execute_flow(sys_id: 'f1', inputs: { user: 'jdoe' })
      expect(result[:execution]['executionId']).to eq('exec1')
    end
  end

  describe '#get_flow_execution' do
    it 'returns execution status' do
      @stubs.get('/api/sn_fd/flow_execution/exec1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'executionId' => 'exec1', 'status' => 'complete' } }]
      end
      expect(@instance.get_flow_execution(execution_id: 'exec1')[:execution]['status']).to eq('complete')
    end
  end

  describe '#list_subflows' do
    it 'returns subflows' do
      @stubs.get('/api/sn_fd/subflow') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'sf1', 'name' => 'Send Notification' }] }]
      end
      expect(@instance.list_subflows[:subflows]).to be_an(Array)
    end
  end
end
