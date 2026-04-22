# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Knowledge::Runners::Knowledge do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_articles' do
    it 'returns articles' do
      @stubs.get('/api/sn_km_api/knowledge') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'kb1', 'short_description' => 'How to reset password' }] }]
      end
      expect(@instance.list_articles[:articles]).to be_an(Array)
    end
  end

  describe '#get_article' do
    it 'returns a single article' do
      @stubs.get('/api/sn_km_api/knowledge/kb1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'kb1', 'short_description' => 'How to reset password' } }]
      end
      expect(@instance.get_article(sys_id: 'kb1')[:article]['sys_id']).to eq('kb1')
    end
  end

  describe '#create_article' do
    it 'creates an article' do
      @stubs.post('/api/sn_km_api/knowledge') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'kb2', 'short_description' => 'New article' } }]
      end
      expect(@instance.create_article(short_description: 'New article', text: 'Content')[:article]['sys_id']).to eq('kb2')
    end
  end

  describe '#update_article' do
    it 'updates an article' do
      @stubs.patch('/api/sn_km_api/knowledge/kb1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'kb1', 'short_description' => 'Updated title' } }]
      end
      expect(@instance.update_article(sys_id: 'kb1', short_description: 'Updated title')[:article]['short_description']).to eq('Updated title')
    end
  end

  describe '#delete_article' do
    it 'returns deleted true on 204' do
      @stubs.delete('/api/sn_km_api/knowledge/kb1') { [204, {}, nil] }
      expect(@instance.delete_article(sys_id: 'kb1')[:deleted]).to be true
    end
  end
end
