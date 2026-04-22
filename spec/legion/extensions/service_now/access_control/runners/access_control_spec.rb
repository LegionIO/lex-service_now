# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::AccessControl::Runners::AccessControl do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_acls' do
    it 'returns ACLs' do
      @stubs.get('/api/now/table/sys_security_acl') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'acl1', 'name' => 'incident.*' }] }]
      end
      expect(@instance.list_acls[:acls]).to be_an(Array)
    end
  end

  describe '#create_acl' do
    it 'creates an ACL' do
      @stubs.post('/api/now/table/sys_security_acl') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'acl2', 'name' => 'problem.write' } }]
      end
      result = @instance.create_acl(name: 'problem.write', type: 'record', operation: 'write')
      expect(result[:acl]['name']).to eq('problem.write')
    end
  end

  describe '#delete_acl' do
    it 'deletes an ACL' do
      @stubs.delete('/api/now/table/sys_security_acl/acl1') { [204, {}, nil] }
      expect(@instance.delete_acl(sys_id: 'acl1')[:deleted]).to be true
    end
  end
end
