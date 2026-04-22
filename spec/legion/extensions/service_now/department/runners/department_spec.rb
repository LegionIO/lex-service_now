# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Department::Runners::Department do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_departments' do
    it 'returns departments' do
      @stubs.get('/api/now/table/cmn_department') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'd1', 'name' => 'IT' }] }]
      end
      expect(@instance.list_departments[:departments]).to be_an(Array)
    end
  end

  describe '#get_department' do
    it 'returns a department' do
      @stubs.get('/api/now/table/cmn_department/d1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'd1', 'name' => 'IT' } }]
      end
      expect(@instance.get_department(sys_id: 'd1')[:department]['sys_id']).to eq('d1')
    end
  end

  describe '#create_department' do
    it 'creates a department' do
      @stubs.post('/api/now/table/cmn_department') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'd2', 'name' => 'Finance' } }]
      end
      expect(@instance.create_department(name: 'Finance')[:department]['name']).to eq('Finance')
    end
  end

  describe '#delete_department' do
    it 'deletes a department' do
      @stubs.delete('/api/now/table/cmn_department/d1') { [204, {}, nil] }
      expect(@instance.delete_department(sys_id: 'd1')[:deleted]).to be true
    end
  end
end
