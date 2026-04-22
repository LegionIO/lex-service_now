# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Extensions::ServiceNow::Errors do
  describe 'ServiceNowError' do
    it 'stores status and detail' do
      err = described_class::ServiceNowError.new('oops', status: 500, detail: { 'error' => 'boom' })
      expect(err.message).to eq('oops')
      expect(err.status).to eq(500)
      expect(err.detail).to eq({ 'error' => 'boom' })
    end
  end

  describe 'error hierarchy' do
    it 'AuthenticationError is a ServiceNowError' do
      expect(described_class::AuthenticationError.ancestors).to include(described_class::ServiceNowError)
    end

    it 'AuthorizationError is a ServiceNowError' do
      expect(described_class::AuthorizationError.ancestors).to include(described_class::ServiceNowError)
    end

    it 'NotFoundError is a ServiceNowError' do
      expect(described_class::NotFoundError.ancestors).to include(described_class::ServiceNowError)
    end

    it 'UnprocessableError is a ServiceNowError' do
      expect(described_class::UnprocessableError.ancestors).to include(described_class::ServiceNowError)
    end

    it 'RateLimitError is a ServiceNowError' do
      expect(described_class::RateLimitError.ancestors).to include(described_class::ServiceNowError)
    end

    it 'ServerError is a ServiceNowError' do
      expect(described_class::ServerError.ancestors).to include(described_class::ServiceNowError)
    end
  end
end
