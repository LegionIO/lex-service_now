# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::CatalogVariable::Runners::CatalogVariable do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_catalog_variables' do
    it 'returns variables for a catalog item' do
      @stubs.get('/api/now/table/item_option_new') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'cv1', 'name' => 'justification' }] }]
      end
      expect(@instance.list_catalog_variables(cat_item_sys_id: 'ci1')[:variables]).to be_an(Array)
    end
  end

  describe '#get_catalog_variable' do
    it 'returns a catalog variable' do
      @stubs.get('/api/now/table/item_option_new/cv1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'cv1', 'name' => 'justification' } }]
      end
      expect(@instance.get_catalog_variable(sys_id: 'cv1')[:variable]['sys_id']).to eq('cv1')
    end
  end

  describe '#create_catalog_variable' do
    it 'creates a catalog variable' do
      @stubs.post('/api/now/table/item_option_new') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'cv2', 'name' => 'reason' } }]
      end
      result = @instance.create_catalog_variable(
        cat_item: 'ci1', name: 'reason',
        question_text: 'Why do you need this?'
      )
      expect(result[:variable]['name']).to eq('reason')
    end
  end

  describe '#delete_catalog_variable' do
    it 'deletes a catalog variable' do
      @stubs.delete('/api/now/table/item_option_new/cv1') { [204, {}, nil] }
      expect(@instance.delete_catalog_variable(sys_id: 'cv1')[:deleted]).to be true
    end
  end
end
