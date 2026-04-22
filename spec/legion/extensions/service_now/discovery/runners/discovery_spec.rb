# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Discovery::Runners::Discovery do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_discovery_schedules' do
    it 'returns discovery schedules' do
      @stubs.get('/api/now/table/discovery_schedule') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ds1', 'name' => 'Daily Scan' }] }]
      end
      expect(@instance.list_discovery_schedules[:schedules]).to be_an(Array)
    end
  end

  describe '#get_discovery_schedule' do
    it 'returns a discovery schedule' do
      @stubs.get('/api/now/table/discovery_schedule/ds1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ds1', 'name' => 'Daily Scan' } }]
      end
      expect(@instance.get_discovery_schedule(sys_id: 'ds1')[:schedule]['sys_id']).to eq('ds1')
    end
  end

  describe '#list_discovery_logs' do
    it 'returns discovery logs' do
      @stubs.get('/api/now/table/discovery_log') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'dl1', 'message' => 'Scan started' }] }]
      end
      expect(@instance.list_discovery_logs[:logs]).to be_an(Array)
    end
  end
end
