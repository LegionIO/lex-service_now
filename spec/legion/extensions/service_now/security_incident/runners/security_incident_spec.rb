# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::SecurityIncident::Runners::SecurityIncident do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_security_incidents' do
    it 'returns security incidents' do
      @stubs.get('/api/now/table/sn_si_incident') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'si1', 'number' => 'SIR001' }] }]
      end
      expect(@instance.list_security_incidents[:security_incidents]).to be_an(Array)
    end
  end

  describe '#create_security_incident' do
    it 'creates a security incident' do
      @stubs.post('/api/now/table/sn_si_incident') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'si2', 'number' => 'SIR002' } }]
      end
      result = @instance.create_security_incident(short_description: 'Phishing attempt')
      expect(result[:security_incident]['number']).to eq('SIR002')
    end
  end

  describe '#close_security_incident' do
    it 'closes a security incident' do
      @stubs.patch('/api/now/table/sn_si_incident/si1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'si1', 'state' => 'closed' } }]
      end
      result = @instance.close_security_incident(sys_id: 'si1', close_notes: 'Resolved')
      expect(result[:security_incident]['state']).to eq('closed')
    end
  end
end
