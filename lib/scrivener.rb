# frozen_string_literal: true

require_relative "scrivener/version"
require_relative "vendors/abbyy/command"
require 'thor'

module Scrivener
  class CLI < Thor

    desc 'process [vendor] [file]', 'Processes an image of a file'
    def process(vendor, file)
      case vendor.to_sym
      when :abbyy
        cmd = Abbyy::Command.new
        cmd.process(file)
      else
        puts "vendor #{vendor} is not supported"
      end
    end

    def self.exit_on_failure?
      true
    end
  end
end
