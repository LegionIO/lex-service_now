# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Asset::Runners::Asset do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_assets' do
    it 'returns assets' do
      @stubs.get('/api/now/table/alm_asset') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'a1', 'name' => 'Laptop-001' }] }]
      end
      expect(@instance.list_assets[:assets]).to be_an(Array)
    end
  end

  describe '#get_asset' do
    it 'returns a single asset' do
      @stubs.get('/api/now/table/alm_asset/a1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'a1', 'name' => 'Laptop-001' } }]
      end
      expect(@instance.get_asset(sys_id: 'a1')[:asset]['sys_id']).to eq('a1')
    end
  end

  describe '#create_asset' do
    it 'creates an asset' do
      @stubs.post('/api/now/table/alm_asset') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'a2', 'serial_number' => 'SN123' } }]
      end
      result = @instance.create_asset(model: 'm1', model_category: 'mc1', serial_number: 'SN123')
      expect(result[:asset]['serial_number']).to eq('SN123')
    end
  end

  describe '#delete_asset' do
    it 'deletes an asset' do
      @stubs.delete('/api/now/table/alm_asset/a1') { [204, {}, nil] }
      expect(@instance.delete_asset(sys_id: 'a1')[:deleted]).to be true
    end
  end
end
