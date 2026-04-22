# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::KnowledgeFeedback::Runners::KnowledgeFeedback do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_knowledge_feedback' do
    it 'returns feedback' do
      @stubs.get('/api/now/table/kb_feedback') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'f1', 'rating' => '5' }] }]
      end
      expect(@instance.list_knowledge_feedback[:feedback]).to be_an(Array)
    end
  end

  describe '#create_knowledge_feedback' do
    it 'creates feedback' do
      @stubs.post('/api/now/table/kb_feedback') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'f2', 'rating' => '4' } }]
      end
      result = @instance.create_knowledge_feedback(article: 'kb1', rating: '4', comments: 'Helpful')
      expect(result[:feedback]['rating']).to eq('4')
    end
  end
end
