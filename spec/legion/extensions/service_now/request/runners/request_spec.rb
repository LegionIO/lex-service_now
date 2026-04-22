# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Request::Runners::Request do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_requests' do
    it 'returns requests' do
      @stubs.get('/api/now/table/sc_request') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'r1', 'number' => 'REQ001' }] }]
      end
      expect(@instance.list_requests[:requests]).to be_an(Array)
    end
  end

  describe '#get_request' do
    it 'returns a single request' do
      @stubs.get('/api/now/table/sc_request/r1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'r1', 'number' => 'REQ001' } }]
      end
      expect(@instance.get_request(sys_id: 'r1')[:request]['sys_id']).to eq('r1')
    end
  end

  describe '#list_request_items' do
    it 'returns request items' do
      @stubs.get('/api/now/table/sc_req_item') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'ri1', 'number' => 'RITM001' }] }]
      end
      expect(@instance.list_request_items[:request_items]).to be_an(Array)
    end
  end

  describe '#get_request_item' do
    it 'returns a single request item' do
      @stubs.get('/api/now/table/sc_req_item/ri1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ri1', 'number' => 'RITM001' } }]
      end
      expect(@instance.get_request_item(sys_id: 'ri1')[:request_item]['sys_id']).to eq('ri1')
    end
  end

  describe '#update_request_item' do
    it 'updates a request item' do
      @stubs.patch('/api/now/table/sc_req_item/ri1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'ri1', 'state' => '3' } }]
      end
      expect(@instance.update_request_item(sys_id: 'ri1', state: '3')[:request_item]['state']).to eq('3')
    end
  end
end
