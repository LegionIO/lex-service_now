# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Table::Runners::Table do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#table_list' do
    it 'returns records from any table' do
      @stubs.get('/api/now/table/u_custom_table') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'r1' }] }]
      end
      expect(@instance.table_list(table_name: 'u_custom_table')[:records]).to be_an(Array)
    end
  end

  describe '#table_get' do
    it 'returns a single record' do
      @stubs.get('/api/now/table/u_custom_table/r1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'r1', 'name' => 'test' } }]
      end
      expect(@instance.table_get(table_name: 'u_custom_table', sys_id: 'r1')[:record]['sys_id']).to eq('r1')
    end
  end

  describe '#table_delete' do
    it 'returns deleted true on 204' do
      @stubs.delete('/api/now/table/u_custom_table/r1') { [204, {}, nil] }
      expect(@instance.table_delete(table_name: 'u_custom_table', sys_id: 'r1')[:deleted]).to be true
    end
  end
end
