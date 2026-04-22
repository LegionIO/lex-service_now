# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::UpdateSet::Runners::UpdateSet do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_update_sets' do
    it 'returns update sets' do
      @stubs.get('/api/now/table/sys_update_set') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'us1', 'name' => 'Sprint 42' }] }]
      end
      expect(@instance.list_update_sets[:update_sets]).to be_an(Array)
    end
  end

  describe '#get_update_set' do
    it 'returns an update set' do
      @stubs.get('/api/now/table/sys_update_set/us1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'us1', 'name' => 'Sprint 42' } }]
      end
      expect(@instance.get_update_set(sys_id: 'us1')[:update_set]['sys_id']).to eq('us1')
    end
  end

  describe '#create_update_set' do
    it 'creates an update set' do
      @stubs.post('/api/now/table/sys_update_set') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'us2', 'name' => 'Sprint 43' } }]
      end
      expect(@instance.create_update_set(name: 'Sprint 43')[:update_set]['name']).to eq('Sprint 43')
    end
  end

  describe '#list_update_set_changes' do
    it 'returns changes in an update set' do
      @stubs.get('/api/now/table/sys_update_xml') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'x1', 'name' => 'sys_script_ABCD' }] }]
      end
      expect(@instance.list_update_set_changes(update_set_sys_id: 'us1')[:changes]).to be_an(Array)
    end
  end

  describe '#delete_update_set' do
    it 'deletes an update set' do
      @stubs.delete('/api/now/table/sys_update_set/us1') { [204, {}, nil] }
      expect(@instance.delete_update_set(sys_id: 'us1')[:deleted]).to be true
    end
  end
end
