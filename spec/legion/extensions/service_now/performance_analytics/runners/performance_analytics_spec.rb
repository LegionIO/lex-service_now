# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::PerformanceAnalytics::Runners::PerformanceAnalytics do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_widgets' do
    it 'returns widgets' do
      @stubs.get('/api/now/pa/widgets') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'w1', 'name' => 'Open Incidents' }] }]
      end
      expect(@instance.list_widgets[:widgets]).to be_an(Array)
    end
  end

  describe '#list_indicators' do
    it 'returns indicators' do
      @stubs.get('/api/now/pa/indicators') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ind1', 'name' => 'MTTR' }] }]
      end
      expect(@instance.list_indicators[:indicators]).to be_an(Array)
    end
  end

  describe '#list_breakdowns' do
    it 'returns breakdowns' do
      @stubs.get('/api/now/pa/breakdowns') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'b1', 'name' => 'By Priority' }] }]
      end
      expect(@instance.list_breakdowns[:breakdowns]).to be_an(Array)
    end
  end
end
