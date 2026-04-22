# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::EmailLog::Runners::EmailLog do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_email_logs' do
    it 'returns email logs' do
      @stubs.get('/api/now/table/sys_email') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'e1', 'subject' => 'Incident INC001' }] }]
      end
      expect(@instance.list_email_logs[:email_logs]).to be_an(Array)
    end
  end

  describe '#get_email_log' do
    it 'returns a single email log' do
      @stubs.get('/api/now/table/sys_email/e1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'e1', 'subject' => 'Incident INC001' } }]
      end
      expect(@instance.get_email_log(sys_id: 'e1')[:email_log]['sys_id']).to eq('e1')
    end
  end

  describe '#list_email_logs_for_record' do
    it 'returns email logs for a specific record' do
      @stubs.get('/api/now/table/sys_email') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'e1' }] }]
      end
      result = @instance.list_email_logs_for_record(target_table: 'incident', target_sys_id: 'i1')
      expect(result[:email_logs]).to be_an(Array)
    end
  end
end
