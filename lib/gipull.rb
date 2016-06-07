require "gipull/version"
require "gipull/config"
require "thor"

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
    def list(org_repo)
      init unless @config.access_token

      say "これがプルリクだ！　#{org_repo} #{colored_message}"
    end

    desc "init", "Initialized gipull"
    def init
      token = ask 'AccessToken:'
      @config.access_token = token
    end

    no_commands do
      def colored_message
        set_color "レビュー待ち", :white, :on_red, :bold
      end
    end
  end
end
