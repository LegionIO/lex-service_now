# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Csm::Runners::Csm do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_csm_cases' do
    it 'returns CSM cases' do
      @stubs.get('/api/now/table/sn_customerservice_case') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'c1', 'number' => 'CS001' }] }]
      end
      expect(@instance.list_csm_cases[:cases]).to be_an(Array)
    end
  end

  describe '#create_csm_case' do
    it 'creates a CSM case' do
      @stubs.post('/api/now/table/sn_customerservice_case') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'c2', 'number' => 'CS002' } }]
      end
      result = @instance.create_csm_case(subject: 'Login issue', account: 'acc1')
      expect(result[:csm_case]['number']).to eq('CS002')
    end
  end

  describe '#list_contacts' do
    it 'returns contacts' do
      @stubs.get('/api/now/table/customer_contact') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ct1', 'name' => 'John Doe' }] }]
      end
      expect(@instance.list_contacts[:contacts]).to be_an(Array)
    end
  end
end
