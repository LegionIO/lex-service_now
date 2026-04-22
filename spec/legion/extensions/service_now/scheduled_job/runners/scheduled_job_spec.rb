# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::ScheduledJob::Runners::ScheduledJob do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_scheduled_jobs' do
    it 'returns scheduled jobs' do
      @stubs.get('/api/now/table/sysauto_script') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'sj1', 'name' => 'Nightly Cleanup' }] }]
      end
      expect(@instance.list_scheduled_jobs[:scheduled_jobs]).to be_an(Array)
    end
  end

  describe '#get_scheduled_job' do
    it 'returns a scheduled job' do
      @stubs.get('/api/now/table/sysauto_script/sj1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'sj1', 'name' => 'Nightly Cleanup' } }]
      end
      expect(@instance.get_scheduled_job(sys_id: 'sj1')[:scheduled_job]['sys_id']).to eq('sj1')
    end
  end

  describe '#create_scheduled_job' do
    it 'creates a scheduled job' do
      @stubs.post('/api/now/table/sysauto_script') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'sj2', 'name' => 'Daily Report' } }]
      end
      result = @instance.create_scheduled_job(name: 'Daily Report', script: 'gs.log("running");')
      expect(result[:scheduled_job]['name']).to eq('Daily Report')
    end
  end

  describe '#delete_scheduled_job' do
    it 'deletes a scheduled job' do
      @stubs.delete('/api/now/table/sysauto_script/sj1') { [204, {}, nil] }
      expect(@instance.delete_scheduled_job(sys_id: 'sj1')[:deleted]).to be true
    end
  end
end
