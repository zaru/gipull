require "singleton"
require "yaml"

module Gipull
  class Config
    include Singleton

    attr_reader :path, :data
    FILE_NAME = ".gipull".freeze

    def initialize
      @path = File.join(File.expand_path('~'), FILE_NAME)
      @data = load_file
    end

    def load_file
      YAML.load_file(@path)
    rescue Errno::ENOENT
      default_structure
    end

    def access_token
      @data["access_token"]
    end

    def access_token=(access_token)
      @data["access_token"] = access_token
      write
    end

    private

    def default_structure
      { "access_token" => nil }
    end

    def write
      File.open(@path, File::RDWR | File::TRUNC | File::CREAT, 0600) do |file|
        file.write @data.to_yaml
      end
    end
  end
end