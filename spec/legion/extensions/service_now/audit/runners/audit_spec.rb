# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Audit::Runners::Audit do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_audit_records' do
    it 'returns audit records' do
      @stubs.get('/api/now/table/sys_audit') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'a1', 'fieldname' => 'state' }] }]
      end
      expect(@instance.list_audit_records[:audit_records]).to be_an(Array)
    end
  end

  describe '#get_audit_record' do
    it 'returns a single audit record' do
      @stubs.get('/api/now/table/sys_audit/a1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'a1', 'fieldname' => 'state' } }]
      end
      expect(@instance.get_audit_record(sys_id: 'a1')[:audit_record]['sys_id']).to eq('a1')
    end
  end

  describe '#list_field_changes' do
    it 'returns field changes for a record' do
      @stubs.get('/api/now/table/sys_audit') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'a1', 'fieldname' => 'state', 'newvalue' => '2' }] }]
      end
      result = @instance.list_field_changes(tablename: 'incident', documentkey: 'i1')
      expect(result[:field_changes]).to be_an(Array)
    end
  end
end
