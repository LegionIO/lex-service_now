# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::ServiceCatalog::Runners::ServiceCatalog do
  before do
    @stubs, conn = RunnerTestHarness.stub_connection
    @instance = RunnerTestHarness.build(described_class)
    allow(@instance).to receive(:connection).and_return(conn)
  end

  describe '#list_catalogs' do
    it 'returns catalogs' do
      @stubs.get('/api/sn_sc/servicecatalog/catalogs') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'c1', 'title' => 'Service Catalog' }] }]
      end
      expect(@instance.list_catalogs[:catalogs]).to be_an(Array)
    end
  end

  describe '#get_catalog' do
    it 'returns a catalog' do
      @stubs.get('/api/sn_sc/servicecatalog/catalogs/c1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'c1', 'title' => 'Service Catalog' } }]
      end
      expect(@instance.get_catalog(sys_id: 'c1')[:catalog]['sys_id']).to eq('c1')
    end
  end

  describe '#get_category' do
    it 'returns a category' do
      @stubs.get('/api/sn_sc/servicecatalog/categories/cat1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'cat1', 'title' => 'Hardware' } }]
      end
      expect(@instance.get_category(sys_id: 'cat1')[:category]['sys_id']).to eq('cat1')
    end
  end

  describe '#list_items' do
    it 'returns items' do
      @stubs.get('/api/sn_sc/servicecatalog/items') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'sys_id' => 'i1', 'name' => 'Laptop' }] }]
      end
      expect(@instance.list_items[:items]).to be_an(Array)
    end
  end

  describe '#get_item' do
    it 'returns an item' do
      @stubs.get('/api/sn_sc/servicecatalog/items/i1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'i1', 'name' => 'Laptop' } }]
      end
      expect(@instance.get_item(sys_id: 'i1')[:item]['sys_id']).to eq('i1')
    end
  end

  describe '#get_item_variables' do
    it 'returns variables for an item' do
      @stubs.get('/api/sn_sc/servicecatalog/items/i1/variables') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => [{ 'name' => 'color', 'type' => 'string' }] }]
      end
      expect(@instance.get_item_variables(sys_id: 'i1')[:variables]).to be_an(Array)
    end
  end

  describe '#order_now' do
    it 'places an order' do
      @stubs.post('/api/sn_sc/servicecatalog/items/i1/order_now') do
        [201, { 'Content-Type' => 'application/json' },
         { 'result' => { 'sys_id' => 'req1', 'number' => 'REQ001' } }]
      end
      expect(@instance.order_now(sys_id: 'i1', quantity: 1)[:request]['number']).to eq('REQ001')
    end
  end

  describe '#add_to_cart' do
    it 'adds item to cart' do
      @stubs.post('/api/sn_sc/servicecatalog/items/i1/add_to_cart') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'cart_id' => 'cart1' } }]
      end
      expect(@instance.add_to_cart(sys_id: 'i1', quantity: 1)[:cart]['cart_id']).to eq('cart1')
    end
  end

  describe '#get_cart' do
    it 'returns cart contents' do
      @stubs.get('/api/sn_sc/servicecatalog/cart') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'cart_id' => 'cart1', 'items' => [] } }]
      end
      expect(@instance.get_cart[:cart]).to be_a(Hash)
    end
  end

  describe '#checkout_cart' do
    it 'checks out the cart' do
      @stubs.post('/api/sn_sc/servicecatalog/cart/checkout') do
        [200, { 'Content-Type' => 'application/json' },
         { 'result' => { 'request_number' => 'REQ002' } }]
      end
      expect(@instance.checkout_cart[:order]['request_number']).to eq('REQ002')
    end
  end

  describe '#delete_cart' do
    it 'deletes the cart' do
      @stubs.delete('/api/sn_sc/servicecatalog/cart/cart1') { [204, {}, nil] }
      expect(@instance.delete_cart(cart_id: 'cart1')[:deleted]).to be true
    end
  end
end
