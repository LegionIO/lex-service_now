# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Problem::Runners::Problem do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_problems' do
    it 'returns a list of problems' do
      @stubs.get('/api/now/table/problem') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'p1', 'number' => 'PRB001' }] }]
      end
      expect(@instance.list_problems[:problems]).to be_an(Array)
    end
  end

  describe '#get_problem' do
    it 'returns a single problem' do
      @stubs.get('/api/now/table/problem/p1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'p1', 'number' => 'PRB001' } }]
      end
      expect(@instance.get_problem(sys_id: 'p1')[:problem]['sys_id']).to eq('p1')
    end
  end

  describe '#create_problem' do
    it 'creates a problem' do
      @stubs.post('/api/now/table/problem') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'p2', 'number' => 'PRB002' } }]
      end
      expect(@instance.create_problem(short_description: 'Recurring outage')[:problem]['number']).to eq('PRB002')
    end
  end

  describe '#update_problem' do
    it 'updates a problem' do
      @stubs.patch('/api/now/table/problem/p1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'p1', 'state' => '2' } }]
      end
      expect(@instance.update_problem(sys_id: 'p1', state: '2')[:problem]['state']).to eq('2')
    end
  end

  describe '#close_problem' do
    it 'closes a problem' do
      @stubs.patch('/api/now/table/problem/p1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'p1', 'state' => '107' } }]
      end
      result = @instance.close_problem(sys_id: 'p1', fix_notes: 'Root cause identified and resolved')
      expect(result[:problem]['state']).to eq('107')
    end
  end

  describe '#delete_problem' do
    it 'returns deleted true on 204' do
      @stubs.delete('/api/now/table/problem/p1') { [204, {}, nil] }
      expect(@instance.delete_problem(sys_id: 'p1')[:deleted]).to be true
    end
  end
end
