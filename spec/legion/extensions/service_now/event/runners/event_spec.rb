# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Event::Runners::Event do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#create_event' do
    it 'creates an event' do
      @stubs.post('/api/now/table/sysevent') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'e1', 'name' => 'disk.full' } }]
      end
      result = @instance.create_event(name: 'disk.full', source: 'monitoring', severity: '2')
      expect(result[:event]['name']).to eq('disk.full')
    end
  end

  describe '#list_events' do
    it 'returns events' do
      @stubs.get('/api/now/table/sysevent') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'e1', 'name' => 'disk.full' }] }]
      end
      expect(@instance.list_events[:events]).to be_an(Array)
    end
  end

  describe '#get_event' do
    it 'returns a single event' do
      @stubs.get('/api/now/table/sysevent/e1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'e1', 'name' => 'disk.full' } }]
      end
      expect(@instance.get_event(sys_id: 'e1')[:event]['sys_id']).to eq('e1')
    end
  end
end
