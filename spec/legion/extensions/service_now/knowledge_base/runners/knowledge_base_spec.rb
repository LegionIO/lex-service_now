# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::KnowledgeBase::Runners::KnowledgeBase do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_knowledge_bases' do
    it 'returns knowledge bases' do
      @stubs.get('/api/now/table/kb_knowledge_base') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'kb1', 'title' => 'IT Knowledge' }] }]
      end
      expect(@instance.list_knowledge_bases[:knowledge_bases]).to be_an(Array)
    end
  end

  describe '#get_knowledge_base' do
    it 'returns a knowledge base' do
      @stubs.get('/api/now/table/kb_knowledge_base/kb1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'kb1', 'title' => 'IT Knowledge' } }]
      end
      expect(@instance.get_knowledge_base(sys_id: 'kb1')[:knowledge_base]['sys_id']).to eq('kb1')
    end
  end

  describe '#create_knowledge_base' do
    it 'creates a knowledge base' do
      @stubs.post('/api/now/table/kb_knowledge_base') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'kb2', 'title' => 'HR Knowledge' } }]
      end
      expect(@instance.create_knowledge_base(title: 'HR Knowledge')[:knowledge_base]['title']).to eq('HR Knowledge')
    end
  end

  describe '#list_kb_categories' do
    it 'returns categories for a knowledge base' do
      @stubs.get('/api/now/table/kb_category') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'kbc1', 'label' => 'How To' }] }]
      end
      expect(@instance.list_kb_categories(knowledge_base_sys_id: 'kb1')[:categories]).to be_an(Array)
    end
  end

  describe '#delete_knowledge_base' do
    it 'deletes a knowledge base' do
      @stubs.delete('/api/now/table/kb_knowledge_base/kb1') { [204, {}, nil] }
      expect(@instance.delete_knowledge_base(sys_id: 'kb1')[:deleted]).to be true
    end
  end
end
