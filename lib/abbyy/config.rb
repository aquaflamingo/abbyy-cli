module Abbyy
  module Config
    class Configuration
      attr_accessor :app_id, :password, :region
    end

    class << self
      attr_writer :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield configuration
    end
  end
end
