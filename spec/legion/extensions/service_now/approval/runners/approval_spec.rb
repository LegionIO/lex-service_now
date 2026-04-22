# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Approval::Runners::Approval do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_approvals' do
    it 'returns approvals' do
      @stubs.get('/api/now/table/sysapproval_approver') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ap1', 'state' => 'requested' }] }]
      end
      expect(@instance.list_approvals[:approvals]).to be_an(Array)
    end
  end

  describe '#get_approval' do
    it 'returns a single approval' do
      @stubs.get('/api/now/table/sysapproval_approver/ap1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ap1', 'state' => 'requested' } }]
      end
      expect(@instance.get_approval(sys_id: 'ap1')[:approval]['sys_id']).to eq('ap1')
    end
  end

  describe '#approve' do
    it 'approves a request' do
      @stubs.patch('/api/now/table/sysapproval_approver/ap1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ap1', 'state' => 'approved' } }]
      end
      expect(@instance.approve(sys_id: 'ap1')[:approval]['state']).to eq('approved')
    end
  end

  describe '#reject' do
    it 'rejects a request' do
      @stubs.patch('/api/now/table/sysapproval_approver/ap1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ap1', 'state' => 'rejected' } }]
      end
      expect(@instance.reject(sys_id: 'ap1', comments: 'Not approved')[:approval]['state']).to eq('rejected')
    end
  end

  describe '#list_approvals_for_record' do
    it 'returns approvals for a specific record' do
      @stubs.get('/api/now/table/sysapproval_approver') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ap1', 'document_id' => 'chg1' }] }]
      end
      expect(@instance.list_approvals_for_record(document_id: 'chg1')[:approvals]).to be_an(Array)
    end
  end
end
