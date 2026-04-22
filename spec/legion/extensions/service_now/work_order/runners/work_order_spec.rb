# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::WorkOrder::Runners::WorkOrder do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_work_orders' do
    it 'returns work orders' do
      @stubs.get('/api/now/table/wm_order') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'wo1', 'number' => 'WO001' }] }]
      end
      expect(@instance.list_work_orders[:work_orders]).to be_an(Array)
    end
  end

  describe '#get_work_order' do
    it 'returns a work order' do
      @stubs.get('/api/now/table/wm_order/wo1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'wo1', 'number' => 'WO001' } }]
      end
      expect(@instance.get_work_order(sys_id: 'wo1')[:work_order]['sys_id']).to eq('wo1')
    end
  end

  describe '#create_work_order' do
    it 'creates a work order' do
      @stubs.post('/api/now/table/wm_order') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'wo2', 'number' => 'WO002' } }]
      end
      result = @instance.create_work_order(short_description: 'Install printer')
      expect(result[:work_order]['number']).to eq('WO002')
    end
  end

  describe '#close_work_order' do
    it 'closes a work order' do
      @stubs.patch('/api/now/table/wm_order/wo1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'wo1', 'state' => 'closed_complete' } }]
      end
      result = @instance.close_work_order(sys_id: 'wo1', close_notes: 'Printer installed')
      expect(result[:work_order]['state']).to eq('closed_complete')
    end
  end

  describe '#list_work_order_tasks' do
    it 'returns work order tasks' do
      @stubs.get('/api/now/table/wm_task') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'wt1' }] }]
      end
      expect(@instance.list_work_order_tasks(work_order_sys_id: 'wo1')[:work_order_tasks]).to be_an(Array)
    end
  end
end
