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

  describe '#table_create' do
    it 'creates a record in the specified table' do
      @stubs.post('/api/now/table/u_custom_table') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'r2', 'name' => 'new record' } }]
      end
      result = @instance.table_create(table_name: 'u_custom_table', name: 'new record')
      expect(result[:record]['sys_id']).to eq('r2')
    end

    it 'does not pass auth fields as body params' do
      posted_body = nil
      @stubs.post('/api/now/table/u_custom_table') do |env|
        posted_body = JSON.parse(env.body)
        [201, { 'Content-Type' => 'application/json' }, { 'result' => { 'sys_id' => 'r3' } }]
      end
      @instance.table_create(table_name: 'u_custom_table', name: 'test', username: 'admin', password: 'secret')
      expect(posted_body.keys).not_to include('username', 'password')
      expect(posted_body['name']).to eq('test')
    end
  end

  describe '#table_update' do
    it 'updates a record in the specified table' do
      @stubs.patch('/api/now/table/u_custom_table/r1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'r1', 'name' => 'updated' } }]
      end
      result = @instance.table_update(table_name: 'u_custom_table', sys_id: 'r1', name: 'updated')
      expect(result[:record]['name']).to eq('updated')
    end
  end

  describe '#table_delete' do
    it 'returns deleted true on 204' do
      @stubs.delete('/api/now/table/u_custom_table/r1') { [204, {}, nil] }
      expect(@instance.table_delete(table_name: 'u_custom_table', sys_id: 'r1')[:deleted]).to be true
    end
  end
end
