# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::SystemProperty::Runners::SystemProperty do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_properties' do
    it 'returns system properties' do
      @stubs.get('/api/now/table/sys_properties') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'p1', 'name' => 'glide.ui.max_length' }] }]
      end
      expect(@instance.list_properties[:properties]).to be_an(Array)
    end
  end

  describe '#get_property_by_name' do
    it 'looks up a property by name' do
      @stubs.get('/api/now/table/sys_properties') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'p1', 'name' => 'glide.ui.max_length', 'value' => '255' }] }]
      end
      result = @instance.get_property_by_name(name: 'glide.ui.max_length')
      expect(result[:property]['name']).to eq('glide.ui.max_length')
    end
  end

  describe '#create_property' do
    it 'creates a property' do
      @stubs.post('/api/now/table/sys_properties') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'p2', 'name' => 'custom.setting', 'value' => 'true' } }]
      end
      result = @instance.create_property(name: 'custom.setting', value: 'true')
      expect(result[:property]['name']).to eq('custom.setting')
    end
  end

  describe '#update_property' do
    it 'updates a property value' do
      @stubs.patch('/api/now/table/sys_properties/p1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'p1', 'value' => '512' } }]
      end
      expect(@instance.update_property(sys_id: 'p1', value: '512')[:property]['value']).to eq('512')
    end
  end

  describe '#delete_property' do
    it 'deletes a property' do
      @stubs.delete('/api/now/table/sys_properties/p1') { [204, {}, nil] }
      expect(@instance.delete_property(sys_id: 'p1')[:deleted]).to be true
    end
  end
end
