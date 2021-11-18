# frozen_string_literal: true

require_relative "scrivener/version"
require_relative "vendors/abbyy/command"

module Scrivener
  class CLI < Thor
    package_name 'Scrivener'
    register(Abbyy::Command, 'abby', 'abby [something]', 'Type scrivener abby for more help.')

    def self.exit_on_failure?
      true
    end
  end
end
