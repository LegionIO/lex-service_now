# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Location::Runners::Location do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_locations' do
    it 'returns locations' do
      @stubs.get('/api/now/table/cmn_location') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'l1', 'name' => 'HQ' }] }]
      end
      expect(@instance.list_locations[:locations]).to be_an(Array)
    end
  end

  describe '#get_location' do
    it 'returns a location' do
      @stubs.get('/api/now/table/cmn_location/l1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'l1', 'name' => 'HQ' } }]
      end
      expect(@instance.get_location(sys_id: 'l1')[:location]['sys_id']).to eq('l1')
    end
  end

  describe '#create_location' do
    it 'creates a location' do
      @stubs.post('/api/now/table/cmn_location') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'l2', 'name' => 'Branch Office' } }]
      end
      expect(@instance.create_location(name: 'Branch Office')[:location]['name']).to eq('Branch Office')
    end
  end

  describe '#delete_location' do
    it 'deletes a location' do
      @stubs.delete('/api/now/table/cmn_location/l1') { [204, {}, nil] }
      expect(@instance.delete_location(sys_id: 'l1')[:deleted]).to be true
    end
  end
end
