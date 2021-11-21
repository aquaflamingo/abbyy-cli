require 'rexml/document'
require 'cgi'
require_relative 'task'

module Abbyy
  class Client
    LANGUAGE = 'English'

    def initialize(config)
      @app_id = CGI.escape(config.app_id)
      @password = CGI.escape(config.password)
      @region = config.region
    end

    def process_image_file(path)
      raise ArgumentError, "file #{path} does not exist" if File.exist?(path)

      file = File.new(path, 'rb')

      begin
        resp = @rest_client.post(
          "#{base_url}/processImage?language=#{LANGUAGE}&exportFormat=txt",
          upload: { file: file }
        )
      rescue RestClient::ExceptionWithResponse => e
        # Show processImage errors
        err = output_response_error(e.response)
        raise err.text
      else
        # Get task id from response xml to check task status later
        ProcessImage.from_xml_document(resp)
      end
    end

    def poll_for_completion(task, interval = 2)
      raise 'Invalid task id provided' if task.id.nil? || task.id.empy? || task.id.include?(Task::INVALID_TASK_ID)

      local_task = task.clone
      # Per documentation TODO
      # Wait at least 2 seconds before making a getTaskStatus request
      # https://ocrsdk.com/documentation/apireference/getTaskStatus/).
      while local_task.in_progress? or local_task.queued?
        begin
          task.wait(interval)

          response = @restclient.get("#{@baseurl}/getTaskStatus?taskid=#{task.id}")
        rescue RestClient::ExceptionWithResponse => e
          # Show getTaskStatus errors
          err = output_response_error(e.response)
          raise err.txt
        else
          local_task = ProcessImage.from_xml_document(response)
        end
      end

      # Return the completed task
      # which should contain the result url
      local_task
    end

    def download_text(url)
      @restclient.get(url)
    end

    private

    def base_url
      if @region.eu?
        "http://#{@app_id}:#{@password}@cloud-eu.ocrsdk.com"
      else
        raise 'Only EU region supported'
      end
    end

    # Routine for OCR SDK error output
    def output_response_error(response)
      # See https://ocrsdk.com/documentation/specifications/status-codes
      xml_data = REXML::Document.new(response)

      # Access the error via +text+ method
      xml_data.elements['error/message']
    end
  end
end
