# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Attachment::Runners::Attachment do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_attachments' do
    it 'returns a list of attachments' do
      @stubs.get('/api/now/attachment') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'a1', 'file_name' => 'log.txt' }] }]
      end
      expect(@instance.list_attachments[:attachments]).to be_an(Array)
    end
  end

  describe '#get_attachment' do
    it 'returns a single attachment record' do
      @stubs.get('/api/now/attachment/a1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'a1', 'file_name' => 'log.txt' } }]
      end
      expect(@instance.get_attachment(sys_id: 'a1')[:attachment]['sys_id']).to eq('a1')
    end
  end

  describe '#get_attachment_file' do
    it 'returns file content' do
      @stubs.get('/api/now/attachment/a1/file') do
        [200, { 'Content-Type' => 'text/plain' }, 'file contents']
      end
      result = @instance.get_attachment_file(sys_id: 'a1')
      expect(result[:status]).to eq(200)
    end
  end

  describe '#delete_attachment' do
    it 'returns deleted true on 204' do
      @stubs.delete('/api/now/attachment/a1') { [204, {}, nil] }
      expect(@instance.delete_attachment(sys_id: 'a1')[:deleted]).to be true
    end
  end
end
