require 'rexml/document'

module Abbyy
  class Task
    attr_reader :id, :status, :result_url

    INVALID_TASK_ID = '00000000-0'

    def initialize(id, status, url)
      @id = id
      @result_url = url
      @status = status
    end

    class << self
      def from_xml_document(xml)
        xml_data = REXML::Document.new(xml)
        task_element = xml_data.elements['response/task']

        new(
          task_element.attributes['id'],
          task_element.attributes['status'],
          task_element.attributes['resultUrl']
        )
      end
    end
  end

  class ProcessImageTask < Task
    # See https://support.abbyy.com/hc/en-us/articles/360017269940-Task-statuses
    STATUS_IN_PROGRESS = 'InProgress'
    STATUS_QUEUED = 'Queued'
    STATUS_FAILED = 'ProcessingFailed'
    STATUS_NO_CREDITS = 'NotEnoughCredits'
    STATUS_COMPLETED = 'Completed'

    def completed?
      @status == STATUS_COMPLETED
    end

    def queued?
      @status == STATUS_QUEUED
    end

    def wait(count = 5)
      sleep(count)
    end

    def in_progress?
      @status == STATUS_IN_PROGRESS
    end

    def failed?
      @status == STATUS_FAILED
    end

    def no_credits?
      @status == STATUS_NO_CREDITS
    end
  end
end
