# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Task::Runners::Task do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_tasks' do
    it 'returns tasks' do
      @stubs.get('/api/now/table/task') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 't1', 'number' => 'TSK001' }] }]
      end
      expect(@instance.list_tasks[:tasks]).to be_an(Array)
    end
  end

  describe '#get_task' do
    it 'returns a single task' do
      @stubs.get('/api/now/table/task/t1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 't1', 'number' => 'TSK001' } }]
      end
      expect(@instance.get_task(sys_id: 't1')[:task]['sys_id']).to eq('t1')
    end
  end

  describe '#update_task' do
    it 'updates a task' do
      @stubs.patch('/api/now/table/task/t1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 't1', 'state' => '2' } }]
      end
      expect(@instance.update_task(sys_id: 't1', state: '2')[:task]['state']).to eq('2')
    end
  end

  describe '#close_task' do
    it 'closes a task' do
      @stubs.patch('/api/now/table/task/t1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 't1', 'state' => '3' } }]
      end
      expect(@instance.close_task(sys_id: 't1', close_notes: 'Done')[:task]['state']).to eq('3')
    end
  end

  describe '#add_work_note' do
    it 'adds a work note' do
      @stubs.patch('/api/now/table/task/t1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 't1' } }]
      end
      expect(@instance.add_work_note(sys_id: 't1', work_notes: 'Working on it')[:task]['sys_id']).to eq('t1')
    end
  end
end
