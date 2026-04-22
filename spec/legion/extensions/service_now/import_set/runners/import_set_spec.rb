# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::ImportSet::Runners::ImportSet do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#import' do
    it 'imports a record' do
      @stubs.post('/api/now/import/u_import_table') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'status' => 'inserted', 'sys_id' => 'r1' }] }]
      end
      result = @instance.import(table_name: 'u_import_table', payload: { u_name: 'test' })
      expect(result[:result]).to be_an(Array)
    end
  end
end
