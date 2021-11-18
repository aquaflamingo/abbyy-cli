require 'rexml/document'
require_relative 'client'

module Abbyy
  VENDOR = 'ABBYY'

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

  class Command < Thor
    class Region
      def initialize(location)
        @location = location
      end

      def eu?
        @location = :eu
      end
    end

    def initialize
      super
      # Hydrate from environment
      config = Config.configure do |conf|
        conf.app_id = ENV['APP_ID']
        conf.password = ENV['APP_PASSOWRD']
        conf.region = Region.new(ENV['APP_REGION'])
      end

      @client = Client.new(config)
    end

    desc 'process FILE', 'Processes an image of a file'
    def process(file = '')
      task = @client.process_image_file(file)
      result = @client.poll_for_completion(task)
      raise 'An error occurred in processing. Check the Abbyy Cloud OCR Console.' if task.failed?
      raise 'Not enough credits to process the task' if task.no_credits?

      text = @client.download_text(task.result_url)

      puts 'Resulting recognized text:'
      puts text
    end
  end
end
