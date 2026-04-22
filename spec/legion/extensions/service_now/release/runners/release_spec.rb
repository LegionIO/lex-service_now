# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Release::Runners::Release do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_releases' do
    it 'returns releases' do
      @stubs.get('/api/now/table/rm_release') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'r1', 'name' => 'Q1 Release' }] }]
      end
      expect(@instance.list_releases[:releases]).to be_an(Array)
    end
  end

  describe '#get_release' do
    it 'returns a release' do
      @stubs.get('/api/now/table/rm_release/r1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'r1', 'name' => 'Q1 Release' } }]
      end
      expect(@instance.get_release(sys_id: 'r1')[:release]['sys_id']).to eq('r1')
    end
  end

  describe '#create_release' do
    it 'creates a release' do
      @stubs.post('/api/now/table/rm_release') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'r2', 'name' => 'Q2 Release' } }]
      end
      expect(@instance.create_release(name: 'Q2 Release')[:release]['name']).to eq('Q2 Release')
    end
  end

  describe '#delete_release' do
    it 'deletes a release' do
      @stubs.delete('/api/now/table/rm_release/r1') { [204, {}, nil] }
      expect(@instance.delete_release(sys_id: 'r1')[:deleted]).to be true
    end
  end
end
