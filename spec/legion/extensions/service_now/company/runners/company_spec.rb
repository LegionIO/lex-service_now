# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Company::Runners::Company do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_companies' do
    it 'returns companies' do
      @stubs.get('/api/now/table/core_company') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'c1', 'name' => 'Acme' }] }]
      end
      expect(@instance.list_companies[:companies]).to be_an(Array)
    end
  end

  describe '#get_company' do
    it 'returns a company' do
      @stubs.get('/api/now/table/core_company/c1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'c1', 'name' => 'Acme' } }]
      end
      expect(@instance.get_company(sys_id: 'c1')[:company]['sys_id']).to eq('c1')
    end
  end

  describe '#create_company' do
    it 'creates a company' do
      @stubs.post('/api/now/table/core_company') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'c2', 'name' => 'NewCo' } }]
      end
      expect(@instance.create_company(name: 'NewCo')[:company]['name']).to eq('NewCo')
    end
  end

  describe '#delete_company' do
    it 'deletes a company' do
      @stubs.delete('/api/now/table/core_company/c1') { [204, {}, nil] }
      expect(@instance.delete_company(sys_id: 'c1')[:deleted]).to be true
    end
  end
end
