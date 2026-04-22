# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Sla::Runners::Sla do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_sla_definitions' do
    it 'returns SLA definitions' do
      @stubs.get('/api/now/table/contract_sla') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 's1', 'name' => 'P1 SLA' }] }]
      end
      expect(@instance.list_sla_definitions[:sla_definitions]).to be_an(Array)
    end
  end

  describe '#get_sla_definition' do
    it 'returns a single SLA definition' do
      @stubs.get('/api/now/table/contract_sla/s1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 's1', 'name' => 'P1 SLA' } }]
      end
      expect(@instance.get_sla_definition(sys_id: 's1')[:sla_definition]['sys_id']).to eq('s1')
    end
  end

  describe '#list_task_slas' do
    it 'returns task SLAs' do
      @stubs.get('/api/now/table/task_sla') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ts1' }] }]
      end
      expect(@instance.list_task_slas[:task_slas]).to be_an(Array)
    end
  end

  describe '#get_task_sla' do
    it 'returns a task SLA' do
      @stubs.get('/api/now/table/task_sla/ts1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ts1', 'stage' => 'in_progress' } }]
      end
      expect(@instance.get_task_sla(sys_id: 'ts1')[:task_sla]['sys_id']).to eq('ts1')
    end
  end
end
