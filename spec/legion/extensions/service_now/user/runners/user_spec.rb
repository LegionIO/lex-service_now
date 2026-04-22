# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::User::Runners::User do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_users' do
    it 'returns a list of users' do
      @stubs.get('/api/now/table/sys_user') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'u1', 'user_name' => 'jdoe' }] }]
      end
      expect(@instance.list_users[:users]).to be_an(Array)
    end
  end

  describe '#get_user' do
    it 'returns a single user' do
      @stubs.get('/api/now/table/sys_user/u1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'u1', 'user_name' => 'jdoe' } }]
      end
      expect(@instance.get_user(sys_id: 'u1')[:user]['sys_id']).to eq('u1')
    end
  end

  describe '#get_user_by_username' do
    it 'looks up a user by username' do
      @stubs.get('/api/now/table/sys_user') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'u1', 'user_name' => 'jdoe' }] }]
      end
      expect(@instance.get_user_by_username(user_name: 'jdoe')[:user]['user_name']).to eq('jdoe')
    end
  end

  describe '#create_user' do
    it 'creates a user' do
      @stubs.post('/api/now/table/sys_user') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'u2', 'user_name' => 'jsmith' } }]
      end
      expect(@instance.create_user(user_name: 'jsmith', email: 'jsmith@example.com')[:user]['user_name']).to eq('jsmith')
    end
  end

  describe '#update_user' do
    it 'updates a user' do
      @stubs.patch('/api/now/table/sys_user/u1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'u1', 'email' => 'new@example.com' } }]
      end
      expect(@instance.update_user(sys_id: 'u1', email: 'new@example.com')[:user]['email']).to eq('new@example.com')
    end
  end

  describe '#delete_user' do
    it 'returns deleted true on 204' do
      @stubs.delete('/api/now/table/sys_user/u1') { [204, {}, nil] }
      expect(@instance.delete_user(sys_id: 'u1')[:deleted]).to be true
    end
  end
end
