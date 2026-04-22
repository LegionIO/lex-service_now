# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Grc::Runners::Grc do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_risks' do
    it 'returns risks' do
      @stubs.get('/api/now/table/sn_risk_risk') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'r1', 'name' => 'Data Breach Risk' }] }]
      end
      expect(@instance.list_risks[:risks]).to be_an(Array)
    end
  end

  describe '#list_controls' do
    it 'returns controls' do
      @stubs.get('/api/now/table/sn_compliance_control') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'c1', 'name' => 'Access Review' }] }]
      end
      expect(@instance.list_controls[:controls]).to be_an(Array)
    end
  end

  describe '#list_audits' do
    it 'returns audits' do
      @stubs.get('/api/now/table/sn_audit_engagement') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'a1', 'name' => 'Q4 Audit' }] }]
      end
      expect(@instance.list_audits[:audits]).to be_an(Array)
    end
  end
end
