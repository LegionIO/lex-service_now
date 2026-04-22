# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Incident::Runners::Incident do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_incidents' do
    it 'returns a list of incidents' do
      @stubs.get('/api/now/table/incident') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'i1', 'number' => 'INC001' }] }]
      end
      expect(@instance.list_incidents[:incidents]).to be_an(Array)
    end
  end

  describe '#get_incident' do
    it 'returns a single incident' do
      @stubs.get('/api/now/table/incident/i1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'i1', 'number' => 'INC001' } }]
      end
      expect(@instance.get_incident(sys_id: 'i1')[:incident]['sys_id']).to eq('i1')
    end
  end

  describe '#create_incident' do
    it 'creates an incident' do
      @stubs.post('/api/now/table/incident') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'i2', 'number' => 'INC002' } }]
      end
      expect(@instance.create_incident(short_description: 'Server down')[:incident]['number']).to eq('INC002')
    end
  end

  describe '#update_incident' do
    it 'updates an incident' do
      @stubs.patch('/api/now/table/incident/i1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'i1', 'state' => '2' } }]
      end
      expect(@instance.update_incident(sys_id: 'i1', state: '2')[:incident]['state']).to eq('2')
    end
  end

  describe '#resolve_incident' do
    it 'resolves an incident' do
      @stubs.patch('/api/now/table/incident/i1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'i1', 'state' => '6' } }]
      end
      result = @instance.resolve_incident(sys_id: 'i1', close_code: 'Solved (Permanently)',
                                          close_notes: 'Fixed the server')
      expect(result[:incident]['state']).to eq('6')
    end
  end

  describe '#delete_incident' do
    it 'returns deleted true on 204' do
      @stubs.delete('/api/now/table/incident/i1') { [204, {}, nil] }
      expect(@instance.delete_incident(sys_id: 'i1')[:deleted]).to be true
    end
  end

  describe 'error handling' do
    it 'raises NotFoundError on 404' do
      @stubs.get('/api/now/table/incident/bad') do
        [404, { 'Content-Type' => 'application/json' },
         { 'error'  => { 'message' => 'No Record found', 'detail' => 'Record does not exist' },
           'status' => 'failure' }]
      end
      expect { @instance.get_incident(sys_id: 'bad') }
        .to raise_error(Legion::Extensions::ServiceNow::Errors::NotFoundError)
    end

    it 'raises AuthenticationError on 401' do
      @stubs.get('/api/now/table/incident/i1') do
        [401, { 'Content-Type' => 'application/json' },
         { 'error'  => { 'message' => 'User Not Authenticated', 'detail' => 'Required to provide Auth information' },
           'status' => 'failure' }]
      end
      expect { @instance.get_incident(sys_id: 'i1') }
        .to raise_error(Legion::Extensions::ServiceNow::Errors::AuthenticationError)
    end

    it 'raises ServerError on 500' do
      @stubs.post('/api/now/table/incident') do
        [500, { 'Content-Type' => 'application/json' },
         { 'error' => { 'message' => 'Internal Server Error' }, 'status' => 'failure' }]
      end
      expect { @instance.create_incident(short_description: 'Test') }
        .to raise_error(Legion::Extensions::ServiceNow::Errors::ServerError)
    end

    it 'raises RateLimitError on 429' do
      @stubs.get('/api/now/table/incident') do
        [429, { 'Content-Type' => 'application/json' },
         { 'error' => { 'message' => 'Too Many Requests' }, 'status' => 'failure' }]
      end
      expect { @instance.list_incidents }
        .to raise_error(Legion::Extensions::ServiceNow::Errors::RateLimitError)
    end
  end
end
