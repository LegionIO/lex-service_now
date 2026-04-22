# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Notification::Runners::Notification do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_notifications' do
    it 'returns notifications' do
      @stubs.get('/api/now/table/sysevent_email_action') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'n1', 'name' => 'Incident Created' }] }]
      end
      expect(@instance.list_notifications[:notifications]).to be_an(Array)
    end
  end

  describe '#get_notification' do
    it 'returns a single notification' do
      @stubs.get('/api/now/table/sysevent_email_action/n1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'n1', 'name' => 'Incident Created' } }]
      end
      expect(@instance.get_notification(sys_id: 'n1')[:notification]['sys_id']).to eq('n1')
    end
  end

  describe '#create_notification' do
    it 'creates a notification' do
      @stubs.post('/api/now/table/sysevent_email_action') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'n2', 'name' => 'Test Notification' } }]
      end
      result = @instance.create_notification(name: 'Test Notification', event_name: 'incident.created')
      expect(result[:notification]['sys_id']).to eq('n2')
    end
  end

  describe '#delete_notification' do
    it 'deletes a notification' do
      @stubs.delete('/api/now/table/sysevent_email_action/n1') { [204, {}, nil] }
      expect(@instance.delete_notification(sys_id: 'n1')[:deleted]).to be true
    end
  end
end
