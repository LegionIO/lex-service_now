# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::UserGroup::Runners::UserGroup do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_groups' do
    it 'returns a list of groups' do
      @stubs.get('/api/now/table/sys_user_group') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'g1', 'name' => 'Network' }] }]
      end
      expect(@instance.list_groups[:groups]).to be_an(Array)
    end
  end

  describe '#get_group' do
    it 'returns a single group' do
      @stubs.get('/api/now/table/sys_user_group/g1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'g1', 'name' => 'Network' } }]
      end
      expect(@instance.get_group(sys_id: 'g1')[:group]['sys_id']).to eq('g1')
    end
  end

  describe '#create_group' do
    it 'creates a group' do
      @stubs.post('/api/now/table/sys_user_group') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'g2', 'name' => 'Security' } }]
      end
      expect(@instance.create_group(name: 'Security')[:group]['name']).to eq('Security')
    end
  end

  describe '#list_group_members' do
    it 'returns group members' do
      @stubs.get('/api/now/table/sys_user_grmember') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'm1', 'user' => { 'value' => 'u1' } }] }]
      end
      expect(@instance.list_group_members(group_sys_id: 'g1')[:members]).to be_an(Array)
    end
  end

  describe '#add_group_member' do
    it 'adds a member to a group' do
      @stubs.post('/api/now/table/sys_user_grmember') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'm1', 'group' => { 'value' => 'g1' } } }]
      end
      expect(@instance.add_group_member(group_sys_id: 'g1', user_sys_id: 'u1')[:member]['sys_id']).to eq('m1')
    end
  end

  describe '#remove_group_member' do
    it 'returns deleted true on 204' do
      @stubs.delete('/api/now/table/sys_user_grmember/m1') { [204, {}, nil] }
      expect(@instance.remove_group_member(membership_sys_id: 'm1')[:deleted]).to be true
    end
  end
end
