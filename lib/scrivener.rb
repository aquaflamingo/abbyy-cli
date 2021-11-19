# frozen_string_literal: true

require_relative "scrivener/version"
require_relative "vendors/abbyy/command"
require 'thor'

module Scrivener
  class CLI < Thor

    desc 'process FILE', 'Processes an image of a file'
    method_option vendor: :string, required: true
    def process(file = '')
      raise "vendor must be specified" if options[:vendor].nil? || options[:vendor].empty?

      case options[:vendor].to_sym
      when
        cmd = Abbyy::Command.new
        cmd.process(file)
      end
    end

    def self.exit_on_failure?
      true
    end
  end
end
