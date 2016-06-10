require "gipull/version"
require "gipull/config"
require "gipull/formatter"
require "thor"
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
    def list(org)
      init unless @config.access_token

      uri = URI.parse("https://api.github.com/orgs/#{org}/issues?access_token=#{@config.access_token}&state=open&filter=all")
      json = Net::HTTP.get(uri)
      result = JSON.parse(json)

      prs = []
      result.each do |issue|
        next if issue['pull_request'].nil?
        labels = issue['labels'].map{|l| l['name'] }
        prs << [issue['title'], issue['html_url'], colored_message(labels)]
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
