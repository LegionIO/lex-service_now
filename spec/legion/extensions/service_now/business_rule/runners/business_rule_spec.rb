# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::BusinessRule::Runners::BusinessRule do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_business_rules' do
    it 'returns business rules' do
      @stubs.get('/api/now/table/sys_script') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'br1', 'name' => 'Set Priority' }] }]
      end
      expect(@instance.list_business_rules[:business_rules]).to be_an(Array)
    end
  end

  describe '#get_business_rule' do
    it 'returns a business rule' do
      @stubs.get('/api/now/table/sys_script/br1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'br1', 'name' => 'Set Priority' } }]
      end
      expect(@instance.get_business_rule(sys_id: 'br1')[:business_rule]['sys_id']).to eq('br1')
    end
  end

  describe '#create_business_rule' do
    it 'creates a business rule' do
      @stubs.post('/api/now/table/sys_script') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'br2', 'name' => 'Auto Assign' } }]
      end
      result = @instance.create_business_rule(
        name:       'Auto Assign',
        collection: 'incident',
        script:     'current.assigned_to = gs.getUserID();'
      )
      expect(result[:business_rule]['name']).to eq('Auto Assign')
    end
  end

  describe '#delete_business_rule' do
    it 'deletes a business rule' do
      @stubs.delete('/api/now/table/sys_script/br1') { [204, {}, nil] }
      expect(@instance.delete_business_rule(sys_id: 'br1')[:deleted]).to be true
    end
  end
end
