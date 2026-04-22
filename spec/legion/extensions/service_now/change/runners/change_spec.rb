# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Change::Runners::Change do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_changes' do
    it 'returns a list of changes' do
      @stubs.get('/api/sn_chg_rest/change') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'abc', 'number' => 'CHG001' }] }]
      end
      expect(@instance.list_changes[:changes]).to be_an(Array)
    end
  end

  describe '#create_normal' do
    it 'creates a normal change' do
      @stubs.post('/api/sn_chg_rest/change/normal') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'abc', 'number' => 'CHG001' } }]
      end
      expect(@instance.create_normal(short_description: 'Deploy app v2')[:change]['number']).to eq('CHG001')
    end
  end

  describe '#create_emergency' do
    it 'creates an emergency change' do
      @stubs.post('/api/sn_chg_rest/change/emergency') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'def', 'number' => 'CHG002' } }]
      end
      expect(@instance.create_emergency(short_description: 'Hotfix')[:change]['number']).to eq('CHG002')
    end
  end

  describe '#create_standard' do
    it 'creates a standard change' do
      @stubs.post('/api/sn_chg_rest/change/standard') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ghi', 'number' => 'CHG003' } }]
      end
      expect(@instance.create_standard(short_description: 'Routine patch')[:change]['number']).to eq('CHG003')
    end
  end

  describe '#get_change' do
    it 'returns a single change' do
      @stubs.get('/api/sn_chg_rest/change/abc') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'abc', 'number' => 'CHG001' } }]
      end
      expect(@instance.get_change(id: 'abc')[:change]['sys_id']).to eq('abc')
    end
  end

  describe '#update_change' do
    it 'updates a change' do
      @stubs.patch('/api/sn_chg_rest/change/abc') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'abc', 'state' => 'scheduled' } }]
      end
      expect(@instance.update_change(id: 'abc', state: 'scheduled')[:change]['state']).to eq('scheduled')
    end
  end

  describe '#delete_change' do
    it 'returns deleted true on 204' do
      @stubs.delete('/api/sn_chg_rest/change/abc') { [204, {}, nil] }
      expect(@instance.delete_change(id: 'abc')[:deleted]).to be true
    end
  end

  describe '#list_change_tasks' do
    it 'returns tasks for a change' do
      @stubs.get('/api/sn_chg_rest/change/abc/task') do
        [200, { 'Content-Type' => 'application/json' }, { 'result' => [{ 'sys_id' => 't1' }] }]
      end
      expect(@instance.list_change_tasks(id: 'abc')[:tasks]).to be_an(Array)
    end
  end

  describe '#create_change_task' do
    it 'creates a task on a change' do
      @stubs.post('/api/sn_chg_rest/change/abc/task') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 't1', 'short_description' => 'Test task' } }]
      end
      expect(@instance.create_change_task(id: 'abc', short_description: 'Test task')[:task]['sys_id']).to eq('t1')
    end
  end

  describe '#update_change_task' do
    it 'updates a task' do
      @stubs.patch('/api/sn_chg_rest/change/abc/task/t1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 't1', 'state' => 'closed' } }]
      end
      expect(@instance.update_change_task(id: 'abc', task_id: 't1', state: 'closed')[:task]['state']).to eq('closed')
    end
  end

  describe '#delete_change_task' do
    it 'returns deleted true on 204' do
      @stubs.delete('/api/sn_chg_rest/change/abc/task/t1') { [204, {}, nil] }
      expect(@instance.delete_change_task(id: 'abc', task_id: 't1')[:deleted]).to be true
    end
  end

  describe '#get_conflicts' do
    it 'returns conflicts for a change' do
      @stubs.get('/api/sn_chg_rest/change/abc/conflict') do
        [200, { 'Content-Type' => 'application/json' }, { 'result' => { 'conflicts' => [] } }]
      end
      expect(@instance.get_conflicts(id: 'abc')[:conflicts]).to be_a(Hash)
    end
  end

  describe '#calculate_conflicts' do
    it 'triggers conflict calculation' do
      @stubs.post('/api/sn_chg_rest/change/abc/conflict') do
        [200, { 'Content-Type' => 'application/json' }, { 'result' => { 'conflicts' => [] } }]
      end
      expect(@instance.calculate_conflicts(id: 'abc')[:conflicts]).to be_a(Hash)
    end
  end

  describe '#get_approvals' do
    it 'returns approvals for a change' do
      @stubs.get('/api/sn_chg_rest/change/abc/approvals') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ap1', 'state' => 'requested' }] }]
      end
      expect(@instance.get_approvals(id: 'abc')[:approvals]).to be_an(Array)
    end
  end
end
