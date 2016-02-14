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
# Lonline is a great tool to log your program into the cloud.
# This module provides methods to get the stored logs from your account in Dynamicloud.
#
# Lonline::Report executes queries provided from Dynamicloud library and will
# fetch until 100 records by default, if you want to increase this set the number
# of records in report_limit (lonline.yml)
#
# Additionally, Lonline::Record provides a method to count how many logs were printed
# in a specific time.
#
# How to use:
#
# Lonline::Report.fetch(:error) do |report| # This call will fetch the error logs from now
#   puts log[:text] # Log you have sent
#   puts log[:trace] # Trace you have sent
#   puts log[:when] # When this log was created
#   puts report['additional'] #This could be an additional field you have sent
# end
#
# Lonline::Report.fetch(:fatal, Time.new.utc) do |report| # This call will fetch the fatal logs from 2 days ago
#   puts log[:text] # Log you have sent
#   puts log[:trace] # Trace you have sent
#   puts log[:when] # When this log was created
# end
#
# Fetch how many logs were printed from Time.new.utc (Today)
#
# count = Lonline::Report.count(:fatal, Time.new.utc)
# puts count

require 'dynamic_api'
require 'dynamic_criteria'

module Lonline
  module Report
    # This method counts the logs between a specific time according to 'from and to' params
    #
    # How to use:
    #
    # Fetch how many logs were printed from Time.new.utc (Today)
    # count = Lonline::Report.count(:fatal, Time.new.utc)
    # puts count
    def self.count(level, from, to = Time.new.utc)
      provider = get_provider

      query = provider.create_query Lonline::SETUP::SETTINGS[:config]['model_identifier']
      condition = Dynamicloud::API::Criteria::Conditions.and(Dynamicloud::API::Criteria::Conditions.equals('lonlinelevel', level.to_s),
                                                             Dynamicloud::API::Criteria::Conditions.between('added_at', from.strftime('%Y-%m-%d %T'),
                                                                                                            to.strftime('%Y-%m-%d %T')))

      results = query.add(condition).get_results(['count(*) as count'])

      results.records[0]['count'].to_i
    end

    # This method fetches the logs according to level param and will be those created from date param.
    #
    # How to use:
    #
    # Lonline::Report.fetch(:fatal, Time.new.utc - 2.days) do |report| # This call will fetch the fatal logs from 2 days ago
    #   puts log[:text] # Log you have sent
    #   puts log[:trace] # Trace you have sent
    #   puts log[:when] # When this log was created
    # end
    def self.fetch(level, from, to = Time.new.utc, &block)
      provider = get_provider

      query = provider.create_query Lonline::SETUP::SETTINGS[:config]['model_identifier']
      condition = Dynamicloud::API::Criteria::Conditions.and(Dynamicloud::API::Criteria::Conditions.equals('lonlinelevel', level.to_s),
                                                             Dynamicloud::API::Criteria::Conditions.between('added_at', from.strftime('%Y-%m-%d %T'),
                                                                                                            to.strftime('%Y-%m-%d %T')))
      results = query.add(condition).get_results

      handle_results(query, block, results, results.fast_returned_size)
    end

    private
    # returns the dynamicloud provider using the CSK and ACI provided from lonline.yml
    def self.get_provider
      Dynamicloud::API::DynamicProvider.new(
          {
              :csk => Lonline::SETUP::SETTINGS[:config]['csk'],
              :aci => Lonline::SETUP::SETTINGS[:config]['aci']
          })
    end

    # This method normalizes the records and will call the block passing the normalized record.
    def self.handle_results(query, block, results, how_much_so_far)
      results.records.each do |r|
        block.call(normalize_record(r))
      end

      if how_much_so_far >= Lonline::SETUP::SETTINGS[:config]['report_limit'].to_i
        return
      end

      results = query.next

      if results.fast_returned_size > 0
        handle_results(query, block, results, how_much_so_far + results.fast_returned_size)
      end
    end

    # This method normalizes the record from Dynamicloud replacing the real field names to readable names
    # For example: lonlinetext => text
    #              created_at => when
    def self.normalize_record(log)
      normalized = {
          :level => log['lonlinelevel'],
          :text => log['lonlinetext'],
          :trace => log['lonlinetrace'],
          :when => log['added_at']
      }

      log.each do |k, v|
        unless k.eql?('lonlinelevel') || k.eql?('lonlinetext') ||
            k.eql?('lonlinetrace') || k.eql?('added_at') ||
            k.eql?('id') || k.eql?('owner_id') || k.eql?('model_id') ||
            k.eql?('changed_at')

          normalized[k.to_sym] = v

        end
      end

      normalized
    end

  end
end