# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Account::Runners::Account do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_accounts' do
    it 'returns accounts' do
      @stubs.get('/api/now/account') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'a1', 'name' => 'Acme Corp' }] }]
      end
      expect(@instance.list_accounts[:accounts]).to be_an(Array)
    end
  end

  describe '#get_account' do
    it 'returns a single account' do
      @stubs.get('/api/now/account/a1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'a1', 'name' => 'Acme Corp' } }]
      end
      expect(@instance.get_account(sys_id: 'a1')[:account]['sys_id']).to eq('a1')
    end
  end

  describe '#create_account' do
    it 'creates an account' do
      @stubs.post('/api/now/account') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'a2', 'name' => 'New Corp' } }]
      end
      expect(@instance.create_account(name: 'New Corp')[:account]['sys_id']).to eq('a2')
    end
  end

  describe '#update_account' do
    it 'updates an account' do
      @stubs.patch('/api/now/account/a1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'a1', 'name' => 'Acme Corp Updated' } }]
      end
      expect(@instance.update_account(sys_id: 'a1', name: 'Acme Corp Updated')[:account]['name']).to eq('Acme Corp Updated')
    end
  end
end
