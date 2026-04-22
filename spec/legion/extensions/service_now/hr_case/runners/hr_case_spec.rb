# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::HrCase::Runners::HrCase do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_hr_cases' do
    it 'returns HR cases' do
      @stubs.get('/api/now/table/sn_hr_core_case') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'h1', 'number' => 'HR001' }] }]
      end
      expect(@instance.list_hr_cases[:hr_cases]).to be_an(Array)
    end
  end

  describe '#get_hr_case' do
    it 'returns a single HR case' do
      @stubs.get('/api/now/table/sn_hr_core_case/h1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'h1', 'number' => 'HR001' } }]
      end
      expect(@instance.get_hr_case(sys_id: 'h1')[:hr_case]['sys_id']).to eq('h1')
    end
  end

  describe '#create_hr_case' do
    it 'creates an HR case' do
      @stubs.post('/api/now/table/sn_hr_core_case') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'h2', 'number' => 'HR002' } }]
      end
      result = @instance.create_hr_case(subject: 'Leave request', opened_for: 'u1')
      expect(result[:hr_case]['number']).to eq('HR002')
    end
  end

  describe '#close_hr_case' do
    it 'closes an HR case' do
      @stubs.patch('/api/now/table/sn_hr_core_case/h1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'h1', 'state' => 'closed' } }]
      end
      expect(@instance.close_hr_case(sys_id: 'h1', close_notes: 'Resolved')[:hr_case]['state']).to eq('closed')
    end
  end
end
