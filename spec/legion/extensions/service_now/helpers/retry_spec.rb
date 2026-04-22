# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Extensions::ServiceNow::Helpers::Retry do
  let(:obj) { Object.new.extend(described_class) }

  describe '#with_retry' do
    it 'returns block result on success' do
      result = obj.with_retry { 42 }
      expect(result).to eq(42)
    end

    it 'retries on RateLimitError and eventually raises' do
      allow(obj).to receive(:sleep)
      calls = 0
      expect do
        obj.with_retry(max_retries: 3) do
          calls += 1
          raise Legion::Extensions::ServiceNow::Errors::RateLimitError, 'rate limited'
        end
      end.to raise_error(Legion::Extensions::ServiceNow::Errors::RateLimitError)
      expect(calls).to eq(3)
    end

    it 'retries on ServerError and eventually raises' do
      allow(obj).to receive(:sleep)
      calls = 0
      expect do
        obj.with_retry(max_retries: 2) do
          calls += 1
          raise Legion::Extensions::ServiceNow::Errors::ServerError, 'server error'
        end
      end.to raise_error(Legion::Extensions::ServiceNow::Errors::ServerError)
      expect(calls).to eq(2)
    end

    it 'does not retry on AuthenticationError' do
      calls = 0
      expect do
        obj.with_retry do
          calls += 1
          raise Legion::Extensions::ServiceNow::Errors::AuthenticationError, 'unauthorized'
        end
      end.to raise_error(Legion::Extensions::ServiceNow::Errors::AuthenticationError)
      expect(calls).to eq(1)
    end
  end
end
