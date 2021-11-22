# frozen_string_literal: true

require_relative "abbyy/version"
require_relative "abbyy/client"
require_relative "abbyy/config"
require 'thor'

module Abbyy
  class Runner 
    def initialize
      # Hydrate from environment
      config = Config.configure do |conf|
        raise "APP_ID must be specified" unless ENV['APP_ID']
        raise "APP_PASSWORD must be specified" unless ENV['APP_PASSWORD']
        raise "APP_REGION must be specified" unless ENV['APP_REGION']

        conf.app_id = ENV['APP_ID']
        conf.password = ENV['APP_PASSWORD']
        conf.region = Region.new(ENV['APP_REGION'])
        conf
      end

      @client = Client.new(config)
    end

    def process(file)
      task = @client.process_image_file(file)
      result = @client.poll_for_completion(task)

      raise "An error occurred in processing. Check the Abbyy Cloud OCR Console." if result.failed?
      raise "Not enough credits to process the task" if result.no_credits?

      @client.download_text(result.result_url)
    end

    class Region
      def initialize(location)
        @location = location
      end

      def eu?
        @location = :eu
      end
    end
  end

  class CLI < Thor

    desc 'process [file]', 'Processes an image of a file'
    def process(file)
      runner = Runner.new
      result = runner.process(file)
      puts result
    end

    def self.exit_on_failure?
      true
    end
  end
end
