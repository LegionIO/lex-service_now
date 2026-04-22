# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::CostCenter::Runners::CostCenter do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_cost_centers' do
    it 'returns cost centers' do
      @stubs.get('/api/now/table/cmn_cost_center') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'cc1', 'name' => 'IT Operations' }] }]
      end
      expect(@instance.list_cost_centers[:cost_centers]).to be_an(Array)
    end
  end

  describe '#get_cost_center' do
    it 'returns a cost center' do
      @stubs.get('/api/now/table/cmn_cost_center/cc1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'cc1', 'name' => 'IT Operations' } }]
      end
      expect(@instance.get_cost_center(sys_id: 'cc1')[:cost_center]['sys_id']).to eq('cc1')
    end
  end

  describe '#create_cost_center' do
    it 'creates a cost center' do
      @stubs.post('/api/now/table/cmn_cost_center') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'cc2', 'name' => 'Engineering' } }]
      end
      expect(@instance.create_cost_center(name: 'Engineering')[:cost_center]['name']).to eq('Engineering')
    end
  end

  describe '#delete_cost_center' do
    it 'deletes a cost center' do
      @stubs.delete('/api/now/table/cmn_cost_center/cc1') { [204, {}, nil] }
      expect(@instance.delete_cost_center(sys_id: 'cc1')[:deleted]).to be true
    end
  end
end
