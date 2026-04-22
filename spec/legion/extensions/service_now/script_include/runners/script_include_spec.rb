# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::ScriptInclude::Runners::ScriptInclude do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_script_includes' do
    it 'returns script includes' do
      @stubs.get('/api/now/table/sys_script_include') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 's1', 'name' => 'Utils' }] }]
      end
      expect(@instance.list_script_includes[:script_includes]).to be_an(Array)
    end
  end

  describe '#get_script_include' do
    it 'returns a script include' do
      @stubs.get('/api/now/table/sys_script_include/s1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 's1', 'name' => 'Utils' } }]
      end
      expect(@instance.get_script_include(sys_id: 's1')[:script_include]['sys_id']).to eq('s1')
    end
  end

  describe '#create_script_include' do
    it 'creates a script include' do
      @stubs.post('/api/now/table/sys_script_include') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 's2', 'name' => 'MyHelper' } }]
      end
      result = @instance.create_script_include(name: 'MyHelper', script: 'var MyHelper = Class.create();')
      expect(result[:script_include]['name']).to eq('MyHelper')
    end
  end

  describe '#delete_script_include' do
    it 'deletes a script include' do
      @stubs.delete('/api/now/table/sys_script_include/s1') { [204, {}, nil] }
      expect(@instance.delete_script_include(sys_id: 's1')[:deleted]).to be true
    end
  end
end
