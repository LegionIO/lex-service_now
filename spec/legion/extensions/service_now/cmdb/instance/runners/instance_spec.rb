# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Cmdb::Instance::Runners::Instance do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_cis' do
    it 'returns a list of CIs' do
      @stubs.get('/api/now/cmdb/instance/cmdb_ci_server') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'records' => [{ 'sys_id' => 's1', 'name' => 'server1' }] } }]
      end
      expect(@instance.list_cis(class_name: 'cmdb_ci_server')[:records]).to be_an(Array)
    end
  end

  describe '#create_ci' do
    it 'creates a CI' do
      @stubs.post('/api/now/cmdb/instance/cmdb_ci_server') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'record' => { 'sys_id' => 's1', 'name' => 'server1' } } }]
      end
      expect(@instance.create_ci(class_name: 'cmdb_ci_server', name: 'server1')[:record]['sys_id']).to eq('s1')
    end
  end

  describe '#get_ci' do
    it 'returns a single CI' do
      @stubs.get('/api/now/cmdb/instance/cmdb_ci_server/s1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'record' => { 'sys_id' => 's1', 'name' => 'server1' } } }]
      end
      expect(@instance.get_ci(class_name: 'cmdb_ci_server', sys_id: 's1')[:record]['sys_id']).to eq('s1')
    end
  end

  describe '#update_ci' do
    it 'updates a CI' do
      @stubs.patch('/api/now/cmdb/instance/cmdb_ci_server/s1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'record' => { 'sys_id' => 's1', 'name' => 'updated' } } }]
      end
      expect(@instance.update_ci(class_name: 'cmdb_ci_server', sys_id: 's1', name: 'updated')[:record]['name']).to eq('updated')
    end
  end

  describe '#delete_ci' do
    it 'returns deleted true on 204' do
      @stubs.delete('/api/now/cmdb/instance/cmdb_ci_server/s1') { [204, {}, nil] }
      expect(@instance.delete_ci(class_name: 'cmdb_ci_server', sys_id: 's1')[:deleted]).to be true
    end
  end

  describe '#get_relationships' do
    it 'returns relationships for a CI' do
      @stubs.get('/api/now/cmdb/instance/cmdb_ci_server/s1/relationships') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'outbound' => [], 'inbound' => [] } }]
      end
      expect(@instance.get_relationships(class_name: 'cmdb_ci_server', sys_id: 's1')[:relationships]).to be_a(Hash)
    end
  end

  describe '#create_relationship' do
    it 'creates a relationship' do
      @stubs.post('/api/now/cmdb/instance/cmdb_ci_server/s1/relationships') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'r1', 'type' => 'Uses' } }]
      end
      result = @instance.create_relationship(class_name: 'cmdb_ci_server', sys_id: 's1',
                                             target_id: 's2', relationship_type: 'Uses')
      expect(result[:relationship]['sys_id']).to eq('r1')
    end
  end
end
