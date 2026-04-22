# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::OnCall::Runners::OnCall do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_on_call_schedules' do
    it 'returns on-call schedules' do
      @stubs.get('/api/now/table/cmn_rota') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'oc1', 'name' => 'Network On-Call' }] }]
      end
      expect(@instance.list_on_call_schedules[:schedules]).to be_an(Array)
    end
  end

  describe '#get_on_call_schedule' do
    it 'returns a schedule' do
      @stubs.get('/api/now/table/cmn_rota/oc1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'oc1', 'name' => 'Network On-Call' } }]
      end
      expect(@instance.get_on_call_schedule(sys_id: 'oc1')[:schedule]['sys_id']).to eq('oc1')
    end
  end

  describe '#list_on_call_members' do
    it 'returns members of a rota' do
      @stubs.get('/api/now/table/cmn_rota_member') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'm1', 'member' => { 'value' => 'u1' } }] }]
      end
      expect(@instance.list_on_call_members(rota_sys_id: 'oc1')[:members]).to be_an(Array)
    end
  end
end
