# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::DeprecationLog::Runners::DeprecationLog do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_upgrade_logs' do
    it 'returns upgrade logs' do
      @stubs.get('/api/now/table/sys_upgrade_history') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ul1', 'version' => 'Utah' }] }]
      end
      expect(@instance.list_upgrade_logs[:upgrade_logs]).to be_an(Array)
    end
  end

  describe '#list_deprecation_entries' do
    it 'returns deprecation entries' do
      @stubs.get('/api/now/table/sys_deprecation_log') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'de1', 'name' => 'deprecated_api' }] }]
      end
      expect(@instance.list_deprecation_entries[:deprecation_entries]).to be_an(Array)
    end
  end
end
