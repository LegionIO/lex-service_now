# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::License::Runners::License do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_licenses' do
    it 'returns licenses' do
      @stubs.get('/api/now/table/license_agreement') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'l1', 'name' => 'Office 365' }] }]
      end
      expect(@instance.list_licenses[:licenses]).to be_an(Array)
    end
  end

  describe '#list_installed_software' do
    it 'returns software installations' do
      @stubs.get('/api/now/table/cmdb_sam_sw_install') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'sw1', 'name' => 'Office 365' }] }]
      end
      expect(@instance.list_installed_software[:installations]).to be_an(Array)
    end
  end
end
