# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Calendar::Runners::Calendar do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_schedules' do
    it 'returns schedules' do
      @stubs.get('/api/now/table/cmn_schedule') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 's1', 'name' => 'Business Hours' }] }]
      end
      expect(@instance.list_schedules[:schedules]).to be_an(Array)
    end
  end

  describe '#create_schedule' do
    it 'creates a schedule' do
      @stubs.post('/api/now/table/cmn_schedule') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 's2', 'name' => 'Support Hours' } }]
      end
      expect(@instance.create_schedule(name: 'Support Hours')[:schedule]['name']).to eq('Support Hours')
    end
  end

  describe '#list_schedule_entries' do
    it 'returns schedule entries' do
      @stubs.get('/api/now/table/cmn_schedule_span') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'se1', 'name' => 'Monday' }] }]
      end
      expect(@instance.list_schedule_entries(schedule_sys_id: 's1')[:entries]).to be_an(Array)
    end
  end

  describe '#delete_schedule' do
    it 'deletes a schedule' do
      @stubs.delete('/api/now/table/cmn_schedule/s1') { [204, {}, nil] }
      expect(@instance.delete_schedule(sys_id: 's1')[:deleted]).to be true
    end
  end
end
