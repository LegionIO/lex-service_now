# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::MidServer::Runners::MidServer do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_mid_servers' do
    it 'returns MID servers' do
      @stubs.get('/api/now/table/ecc_agent') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ms1', 'name' => 'mid-prod-01' }] }]
      end
      expect(@instance.list_mid_servers[:mid_servers]).to be_an(Array)
    end
  end

  describe '#get_mid_server' do
    it 'returns a MID server' do
      @stubs.get('/api/now/table/ecc_agent/ms1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ms1', 'name' => 'mid-prod-01' } }]
      end
      expect(@instance.get_mid_server(sys_id: 'ms1')[:mid_server]['sys_id']).to eq('ms1')
    end
  end

  describe '#get_mid_server_by_name' do
    it 'looks up a MID server by name' do
      @stubs.get('/api/now/table/ecc_agent') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ms1', 'name' => 'mid-prod-01' }] }]
      end
      result = @instance.get_mid_server_by_name(name: 'mid-prod-01')
      expect(result[:mid_server]['name']).to eq('mid-prod-01')
    end
  end
end
