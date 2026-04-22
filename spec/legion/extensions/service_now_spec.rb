# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Extensions::ServiceNow do
  it 'is defined' do
    expect(described_class).to be_a(Module)
  end

  describe Legion::Extensions::ServiceNow::Client do
    let(:client) do
      described_class.new(
        url:      'https://test.service-now.com',
        username: 'admin',
        password: 'secret'
      )
    end

    it 'instantiates with credentials' do
      expect(client).to be_a(described_class)
    end

    it 'includes Change runner' do
      expect(client).to respond_to(:list_changes)
      expect(client).to respond_to(:create_normal)
      expect(client).to respond_to(:get_change)
    end

    it 'includes CMDB Instance runner' do
      expect(client).to respond_to(:list_cis)
      expect(client).to respond_to(:get_ci)
    end

    it 'includes CMDB Meta runner' do
      expect(client).to respond_to(:get_hierarchy)
      expect(client).to respond_to(:get_class_meta)
    end

    it 'includes Knowledge runner' do
      expect(client).to respond_to(:list_articles)
      expect(client).to respond_to(:get_article)
    end

    it 'includes Service Catalog runner' do
      expect(client).to respond_to(:list_catalogs)
      expect(client).to respond_to(:order_now)
    end

    it 'includes Account runner' do
      expect(client).to respond_to(:list_accounts)
      expect(client).to respond_to(:get_account)
    end

    it 'stores opts compactly' do
      expect(client.opts[:url]).to eq('https://test.service-now.com')
      expect(client.opts[:username]).to eq('admin')
      expect(client.opts.keys).not_to include(:client_id)
    end
  end
end
