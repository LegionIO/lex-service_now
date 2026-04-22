# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::ServicePortal::Runners::ServicePortal do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_portals' do
    it 'returns portals' do
      @stubs.get('/api/sn_sp/portal') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'p1', 'title' => 'IT Service Portal' }] }]
      end
      expect(@instance.list_portals[:portals]).to be_an(Array)
    end
  end

  describe '#get_portal' do
    it 'returns a portal' do
      @stubs.get('/api/sn_sp/portal/p1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'p1', 'title' => 'IT Service Portal' } }]
      end
      expect(@instance.get_portal(sys_id: 'p1')[:portal]['sys_id']).to eq('p1')
    end
  end

  describe '#list_portal_pages' do
    it 'returns portal pages' do
      @stubs.get('/api/now/table/sp_page') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'pg1', 'title' => 'Home' }] }]
      end
      expect(@instance.list_portal_pages(portal_sys_id: 'p1')[:pages]).to be_an(Array)
    end
  end

  describe '#list_portal_widgets' do
    it 'returns portal widgets' do
      @stubs.get('/api/now/table/sp_widget') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'w1', 'name' => 'My Requests' }] }]
      end
      expect(@instance.list_portal_widgets[:widgets]).to be_an(Array)
    end
  end
end
