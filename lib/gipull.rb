require "gipull/version"
require "gipull/config"
require "gipull/formatter"
require "thor"
require "octokit"
require "json"
require "uri"

module Gipull
  class CLI < Thor

    class_options [ :config ]

    def initialize(*args)
      super
      @config = Gipull::Config.instance
    end

    desc "list", "List pull-requests"
    option :org, :type => :array, :required => true
    option :repo, :type => :array, :default => []
    option :excluderepo, :type => :array, :default => []
    option :since, :type => :numeric, :default => 7
    def list
      init unless @config.access_token

      client = Octokit::Client.new(:access_token => @config.access_token)
      client.auto_paginate = true

      issues = []
      options[:org].each do |org|
        issues.concat client.org_issues org, :filter => 'all', :state => 'open', :since => (Time.now - options[:since] * 86400).iso8601
      end

      prs = []
      issues.each do |issue|
        next if issue['pull_request'].nil?
        next unless options[:repo].empty? && !options[:repo].include?(issue['repository']['name'])
        next unless options[:excluderepo].empty? && options[:excluderepo].include?(issue['repository']['name'])
        row = [issue['title'], issue['html_url']]
        row << colored_message(issue['labels'].map{|l| l['name'] }.join(" ")) unless issue['labels'].empty?
        prs << row
      end

      return if prs.empty?

      formatter = Gipull::Formatter.new(prs)
      say formatter.render
    end

    desc "init", "Initialized gipull"
    def init
      token = ask 'AccessToken:'
      @config.access_token = token
    end

    desc "config", "List config"
    def config
      say @config.data
    end

    no_commands do
      def colored_message(message)
        set_color message, :white, :on_red, :bold
      end
    end
  end
end
