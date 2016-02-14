#Copyright (c) 2016 Dynamicloud
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
#
#Lonline module provides the main functions to log and send data to the cloud
#
#The uses of Lonline are the followings:
#
#Lonline.log.trace('Calling method Y')
#Lonline.log.debug('Creating new object')
#Lonline.log.info('Process has finished')
#Lonline.log.warn('It could'n create this object, the process will try later.)
#Lonline.log.error('Unable to load setting file')
#Lonline.log.fatal('The app has crashed and its state is unavailable')
#
#If you active warning in lonline, every rejected request from Dynamicloud will be printed in stdout.
#
#Lonline will verify the level of logging to avoid unnecessary request to Dynamicloud
#
#Important: Dynamicloud offers in its free version 5.000 monthly requests and 500Mb of disk space.
#
#Dynamicloud is a powerful service that offers a dynamic way to add attributes to your business.
#To send additional data, you need to pass a hash with the additional attributes (Fields)
#
#For example:
#
#Lonline.log.fatal('Testing trace', {:module => 'Logging from financial module.'})
#
#The above call, indicates to lonline that you need to send an additional field called 'module'.
#
#For further information, visit lonline's repository on https://github.com/dynamicloud/lonline_for_ruby

require 'dynamic_api'
require 'yaml'

module Lonline
  # The available levels in lonline.
  LEVELS = {
      :false => 7,
      :off => 7,
      :fatal => 6,
      :error => 5,
      :warn => 4,
      :info => 3,
      :debug => 2,
      :trace => 1
  }

  # This class provides the four methods to log and send data to the cloud.
  class Log
    attr_accessor :logger

    def initialize
      @logger = nil
    end

    # The DEBUG Level designates fine-grained informational events that are most useful to debug an application.
    def debug(text, additional_data = {})
      begin
        @logger.debug(text)
      rescue
        #ignore
      ensure
        send_log(:debug, text, additional_data)
      end
    end

    # The INFO level designates informational messages that highlight the progress of the application at coarse-grained level.
    def info(text, additional_data = {})
      begin
        @logger.info(text)
      rescue
        #ignore
      ensure
        send_log(:info, text, additional_data)
      end
    end

    # The WARN level designates potentially harmful situations.
    def warn(text, additional_data = {})
      begin
        @logger.warn(text)
      rescue
        #ignore
      ensure
        send_log(:warn, text, additional_data)
      end
    end

    # The ERROR level designates error events that might still allow the application to continue running.
    def error(text, additional_data = {})
      begin
        @logger.error(text)
      rescue
        #ignore
      ensure
        send_log(:error, text, additional_data)
      end
    end

    # The FATAL level designates very severe error events that will presumably lead the application to abort.
    def fatal(text, additional_data = {})
      begin
        @logger.fatal(text)
      rescue
        #ignore
      ensure
        send_log(:fatal, text, additional_data)
      end
    end

    # The TRACE Level designates finer-grained informational events than the DEBUG
    def trace(text, additional_data = {})
      begin
        @logger.trace(text)
      rescue
        #ignore
      ensure
        send_log(:trace, text, additional_data)
      end
    end

    # This method sends the log to Dynamicloud
    # Dynamic provider will be created using the configuration in lonline.yml (csk and aci)
    # If any error occurs a warning will be printed only if warning flag is true
    # The additional_data param are additional data you need to send.
    def send_log(level, text, additional_data = {})
      unless Lonline::SETUP::SETTINGS[:config].nil?
        # Verify logging level
        allowed_level = Lonline::LEVELS[:off]
        if Lonline::SETUP::SETTINGS[:config]['level'].nil?
          Lonline.warn_it('Lonline is using default level :off')
        else
          allowed_level = Lonline::LEVELS[Lonline::SETUP::SETTINGS[:config]['level'].to_s.to_sym]
          if allowed_level.nil?
            Lonline.warn_it('Lonline is using default level :off')
            allowed_level = Lonline::LEVELS[:off]
          end
        end

        current_level = Lonline::LEVELS[level]

        unless current_level >= allowed_level
          return
        end
        # End of level verification

        trace = {
            :lonlinelevel => level.to_s,
            :lonlinetext => text
        }

        trace.merge!(additional_data)

        if Lonline::SETUP::SETTINGS[:config]['backtrace']
          sub_array = caller[1..caller.length]
          trace[:lonlinetrace] = sub_array.join("\n")
        end

        if Lonline::SETUP::SETTINGS[:config]['async']
          Lonline.warn_it 'Async mode'

          t = schedule(trace)

          # For test environment the async mode is disabled.
          if Lonline::SETUP::SETTINGS[:config]['env'].eql?('test')
            Lonline.warn_it 'For test environment, the async process is disabled'

            t.join
          end
        else
          Lonline.warn_it 'Sync mode'
          call_dynamicloud_service(trace)
        end
      end
    end

    def schedule(trace)
      Thread.new {
        call_dynamicloud_service(trace)
      }
    end

    def call_dynamicloud_service(trace)
      provider = Dynamicloud::API::DynamicProvider.new(
          {
              :csk => Lonline::SETUP::SETTINGS[:config]['csk'],
              :aci => Lonline::SETUP::SETTINGS[:config]['aci']
          })
      begin
        provider.save_record Lonline::SETUP::SETTINGS[:config]['model_identifier'], trace
      rescue Exception => e
        Lonline.warn_it(e.message)
      end
    end
  end

  # Global logger
  LOGGER = Log.new

  # This method returns the global logger.
  def self.log
    LOGGER
  end

  # Prints the warning
  def self.warn_it(text)
    if Lonline::SETUP::SETTINGS[:config]['warning']
      puts "[Lonline WARN @ #{Time.new.utc.strftime('%d %B, %Y %T')}] - #{text}"
    end
  end

  # This module provides methods to setup lonline
  module SETUP
    def self.logger=(logger)
      LOGGER.logger = logger;
    end

    SETTINGS = {:config => {}}

    # Load yml file with the settings to setup lonline
    def self.load(file_name, env = ENV['LONLINE_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development')
      begin
        SETTINGS[:config] = YAML.load_file(file_name)[env]
        SETTINGS[:config]['env'] = env
      rescue Exception => e
        Lonline.warn_it("It couldn't setup lonline.")
        Lonline.warn_it(e.message)
      end
    end
  end
end