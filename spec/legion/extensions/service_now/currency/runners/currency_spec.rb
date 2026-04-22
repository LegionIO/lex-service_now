# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Currency::Runners::Currency do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_currencies' do
    it 'returns currencies' do
      @stubs.get('/api/now/table/fx_currency') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'c1', 'code' => 'USD' }] }]
      end
      expect(@instance.list_currencies[:currencies]).to be_an(Array)
    end
  end

  describe '#list_exchange_rates' do
    it 'returns exchange rates' do
      @stubs.get('/api/now/table/fx_rate') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'r1', 'rate' => '1.25' }] }]
      end
      expect(@instance.list_exchange_rates[:exchange_rates]).to be_an(Array)
    end
  end
end
