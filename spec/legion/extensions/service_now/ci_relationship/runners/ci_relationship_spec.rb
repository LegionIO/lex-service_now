# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::CiRelationship::Runners::CiRelationship do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_relationship_types' do
    it 'returns relationship types' do
      @stubs.get('/api/now/table/cmdb_rel_type') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'rt1', 'name' => 'Uses' }] }]
      end
      expect(@instance.list_relationship_types[:relationship_types]).to be_an(Array)
    end
  end

  describe '#list_ci_relationships' do
    it 'returns CI relationships' do
      @stubs.get('/api/now/table/cmdb_rel_ci') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'r1', 'type' => { 'value' => 'rt1' } }] }]
      end
      expect(@instance.list_ci_relationships[:relationships]).to be_an(Array)
    end
  end

  describe '#create_ci_relationship' do
    it 'creates a CI relationship' do
      @stubs.post('/api/now/table/cmdb_rel_ci') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'r2', 'type' => { 'value' => 'rt1' } } }]
      end
      result = @instance.create_ci_relationship(parent: 'ci1', child: 'ci2', type: 'rt1')
      expect(result[:relationship]['sys_id']).to eq('r2')
    end
  end

  describe '#delete_ci_relationship' do
    it 'deletes a CI relationship' do
      @stubs.delete('/api/now/table/cmdb_rel_ci/r1') { [204, {}, nil] }
      expect(@instance.delete_ci_relationship(sys_id: 'r1')[:deleted]).to be true
    end
  end
end
