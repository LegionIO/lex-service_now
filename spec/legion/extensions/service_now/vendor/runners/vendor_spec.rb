# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Vendor::Runners::Vendor do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_vendors' do
    it 'returns vendors' do
      @stubs.get('/api/now/table/core_company') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'v1', 'name' => 'Acme Supplies' }] }]
      end
      expect(@instance.list_vendors[:vendors]).to be_an(Array)
    end
  end

  describe '#get_vendor' do
    it 'returns a vendor' do
      @stubs.get('/api/now/table/core_company/v1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'v1', 'name' => 'Acme Supplies' } }]
      end
      expect(@instance.get_vendor(sys_id: 'v1')[:vendor]['sys_id']).to eq('v1')
    end
  end

  describe '#create_vendor' do
    it 'creates a vendor' do
      @stubs.post('/api/now/table/core_company') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'v2', 'name' => 'New Vendor' } }]
      end
      expect(@instance.create_vendor(name: 'New Vendor')[:vendor]['sys_id']).to eq('v2')
    end
  end

  describe '#delete_vendor' do
    it 'deletes a vendor' do
      @stubs.delete('/api/now/table/core_company/v1') { [204, {}, nil] }
      expect(@instance.delete_vendor(sys_id: 'v1')[:deleted]).to be true
    end
  end
end
