# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Contract::Runners::Contract do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_contracts' do
    it 'returns contracts' do
      @stubs.get('/api/now/table/ast_contract') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ct1', 'short_description' => 'Vendor SLA' }] }]
      end
      expect(@instance.list_contracts[:contracts]).to be_an(Array)
    end
  end

  describe '#get_contract' do
    it 'returns a contract' do
      @stubs.get('/api/now/table/ast_contract/ct1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ct1', 'short_description' => 'Vendor SLA' } }]
      end
      expect(@instance.get_contract(sys_id: 'ct1')[:contract]['sys_id']).to eq('ct1')
    end
  end

  describe '#create_contract' do
    it 'creates a contract' do
      @stubs.post('/api/now/table/ast_contract') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ct2', 'short_description' => 'New Vendor' } }]
      end
      expect(@instance.create_contract(short_description: 'New Vendor')[:contract]['sys_id']).to eq('ct2')
    end
  end

  describe '#delete_contract' do
    it 'deletes a contract' do
      @stubs.delete('/api/now/table/ast_contract/ct1') { [204, {}, nil] }
      expect(@instance.delete_contract(sys_id: 'ct1')[:deleted]).to be true
    end
  end
end
