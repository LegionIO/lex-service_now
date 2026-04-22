# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Tag::Runners::Tag do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_tags' do
    it 'returns tags' do
      @stubs.get('/api/now/table/label') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 't1', 'name' => 'production' }] }]
      end
      expect(@instance.list_tags[:tags]).to be_an(Array)
    end
  end

  describe '#create_tag' do
    it 'creates a tag' do
      @stubs.post('/api/now/table/label') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 't2', 'name' => 'critical' } }]
      end
      expect(@instance.create_tag(name: 'critical')[:tag]['name']).to eq('critical')
    end
  end

  describe '#add_tag_to_record' do
    it 'tags a record' do
      @stubs.post('/api/now/table/label_entry') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'te1' } }]
      end
      result = @instance.add_tag_to_record(tag_sys_id: 't1', table_name: 'incident', record_sys_id: 'i1')
      expect(result[:tag_entry]['sys_id']).to eq('te1')
    end
  end

  describe '#delete_tag' do
    it 'deletes a tag' do
      @stubs.delete('/api/now/table/label/t1') { [204, {}, nil] }
      expect(@instance.delete_tag(sys_id: 't1')[:deleted]).to be true
    end
  end
end
