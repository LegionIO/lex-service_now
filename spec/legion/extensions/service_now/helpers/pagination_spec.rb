# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Extensions::ServiceNow::Helpers::Pagination do
  let(:obj) do
    klass = Class.new do
      include Legion::Extensions::ServiceNow::Helpers::Pagination

      def list_things(sysparm_limit: 100, sysparm_offset: 0, **)
        case sysparm_offset
        when 0
          { things: (1..sysparm_limit).map { |i| { id: i } } }
        when 100
          { things: (101..150).map { |i| { id: i } } }
        else
          { things: [] }
        end
      end
    end
    klass.new
  end

  describe '#paginate' do
    it 'fetches all pages and combines results' do
      results = obj.paginate(:list_things, sysparm_limit: 100)
      expect(results.size).to eq(150)
    end

    it 'stops when a partial page is returned' do
      results = obj.paginate(:list_things, sysparm_limit: 100)
      expect(results.last[:id]).to eq(150)
    end

    it 'returns empty array when no results' do
      klass = Class.new do
        include Legion::Extensions::ServiceNow::Helpers::Pagination

        def list_empty(**)
          { items: [] }
        end
      end
      expect(klass.new.paginate(:list_empty)).to eq([])
    end
  end
end
