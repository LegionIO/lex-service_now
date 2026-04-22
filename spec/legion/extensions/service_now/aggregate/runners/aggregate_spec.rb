# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Aggregate::Runners::Aggregate do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#aggregate' do
    it 'returns aggregate stats' do
      @stubs.get('/api/now/stats/incident') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'stats' => { 'count' => '42' } } }]
      end
      expect(@instance.aggregate(table_name: 'incident', sysparm_count: true)[:stats]).to be_a(Hash)
    end
  end
end
