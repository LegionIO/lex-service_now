# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Cmdb::Meta::Runners::Meta do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#get_hierarchy' do
    it 'returns class hierarchy' do
      @stubs.get('/api/now/doc/meta/hierarchy') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'name' => 'cmdb_ci', 'label' => 'Configuration Item' }] }]
      end
      expect(@instance.get_hierarchy[:hierarchy]).to be_an(Array)
    end
  end

  describe '#get_class_meta' do
    it 'returns metadata for a class' do
      @stubs.get('/api/now/doc/meta/cmdb_ci_server') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'name' => 'cmdb_ci_server', 'label' => 'Server', 'attributes' => [] } }]
      end
      expect(@instance.get_class_meta(class_name: 'cmdb_ci_server')[:meta]['name']).to eq('cmdb_ci_server')
    end
  end
end
