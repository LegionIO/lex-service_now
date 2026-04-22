# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::CmdbHealth::Runners::CmdbHealth do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_duplicate_cis' do
    it 'returns duplicate CIs' do
      @stubs.get('/api/now/table/cmdb_duplicate') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'd1', 'name' => 'server-01' }] }]
      end
      expect(@instance.list_duplicate_cis(class_name: 'cmdb_ci_server')[:duplicates]).to be_an(Array)
    end
  end

  describe '#list_stale_cis' do
    it 'returns stale CIs' do
      @stubs.get('/api/now/table/cmdb_ci') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 's1', 'name' => 'old-server' }] }]
      end
      expect(@instance.list_stale_cis(class_name: 'cmdb_ci_server')[:stale_cis]).to be_an(Array)
    end
  end
end
