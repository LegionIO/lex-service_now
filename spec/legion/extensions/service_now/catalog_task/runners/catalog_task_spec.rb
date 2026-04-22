# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::CatalogTask::Runners::CatalogTask do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_catalog_tasks' do
    it 'returns catalog tasks' do
      @stubs.get('/api/now/table/sc_task') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ct1', 'number' => 'TASK001' }] }]
      end
      expect(@instance.list_catalog_tasks[:catalog_tasks]).to be_an(Array)
    end
  end

  describe '#get_catalog_task' do
    it 'returns a catalog task' do
      @stubs.get('/api/now/table/sc_task/ct1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ct1', 'number' => 'TASK001' } }]
      end
      expect(@instance.get_catalog_task(sys_id: 'ct1')[:catalog_task]['sys_id']).to eq('ct1')
    end
  end

  describe '#close_catalog_task' do
    it 'closes a catalog task' do
      @stubs.patch('/api/now/table/sc_task/ct1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ct1', 'state' => '3' } }]
      end
      expect(@instance.close_catalog_task(sys_id: 'ct1', close_notes: 'Done')[:catalog_task]['state']).to eq('3')
    end
  end
end
