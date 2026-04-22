# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Project::Runners::Project do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_projects' do
    it 'returns projects' do
      @stubs.get('/api/now/table/pm_project') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'p1', 'name' => 'Cloud Migration' }] }]
      end
      expect(@instance.list_projects[:projects]).to be_an(Array)
    end
  end

  describe '#get_project' do
    it 'returns a project' do
      @stubs.get('/api/now/table/pm_project/p1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'p1', 'name' => 'Cloud Migration' } }]
      end
      expect(@instance.get_project(sys_id: 'p1')[:project]['sys_id']).to eq('p1')
    end
  end

  describe '#create_project' do
    it 'creates a project' do
      @stubs.post('/api/now/table/pm_project') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'p2', 'name' => 'New Initiative' } }]
      end
      expect(@instance.create_project(name: 'New Initiative')[:project]['name']).to eq('New Initiative')
    end
  end

  describe '#list_project_tasks' do
    it 'returns project tasks' do
      @stubs.get('/api/now/table/pm_project_task') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'pt1', 'short_description' => 'Plan phase' }] }]
      end
      expect(@instance.list_project_tasks(project_sys_id: 'p1')[:project_tasks]).to be_an(Array)
    end
  end

  describe '#delete_project' do
    it 'deletes a project' do
      @stubs.delete('/api/now/table/pm_project/p1') { [204, {}, nil] }
      expect(@instance.delete_project(sys_id: 'p1')[:deleted]).to be true
    end
  end
end
