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

    desc "hello NAME", "say hello to NAME"
    def hello(name)
      puts "Hello #{name} #{@config.data}"
    end

    desc "list ORG/REPO", "List pull-requests"
    option :org, :required => true
    option :repo
    option :since, :type => :numeric, :default => 7
    def list
      init unless @config.access_token

      client = Octokit::Client.new(:access_token => @config.access_token)
      client.auto_paginate = true
      issues = client.org_issues options[:org], :filter => 'all', :state => 'open', :since => (Time.now - options[:since] * 86400).iso8601

      prs = []
      issues.each do |issue|
        next if issue['pull_request'].nil?
        row = [issue['title'], issue['html_url']]
        row << colored_message(issue['labels'].map{|l| l['name'] }.join(" ")) if issue['labels'].size > 0
        prs << row
      end

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
