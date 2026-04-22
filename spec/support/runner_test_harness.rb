# frozen_string_literal: true

module RunnerTestHarness
  def self.build(*runner_modules)
    klass = Class.new do
      include Legion::Extensions::ServiceNow::Helpers::Client

      runner_modules.each { |mod| include mod }

      attr_reader :opts

      def initialize(**opts)
        @opts = opts
      end

      def connection(**override)
        super(**@opts.merge(override))
      end
    end
    klass.new(
      url:      'https://test.service-now.com',
      username: 'admin',
      password: 'secret'
    )
  end

  def self.stub_connection
    stubs = Faraday::Adapter::Test::Stubs.new
    conn = Faraday.new(url: 'https://test.service-now.com') do |c|
      c.request :json
      c.response :json, content_type: /\bjson$/
      c.adapter :test, stubs
    end
    [stubs, conn]
  end
end
