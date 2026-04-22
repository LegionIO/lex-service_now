# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Metric::Runners::Metric do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_metric_definitions' do
    it 'returns metric definitions' do
      @stubs.get('/api/now/table/metric_definition') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'md1', 'name' => 'MTTR' }] }]
      end
      expect(@instance.list_metric_definitions[:metric_definitions]).to be_an(Array)
    end
  end

  describe '#list_metric_instances' do
    it 'returns metric instances' do
      @stubs.get('/api/now/table/metric_instance') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'mi1', 'value' => '42' }] }]
      end
      expect(@instance.list_metric_instances[:metric_instances]).to be_an(Array)
    end
  end
end
