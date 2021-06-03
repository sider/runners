require "forwardable"

module Runners
  class Analyzers
    extend Forwardable

    def_delegators :@content, :each, :map, :size

    def initialize
      file = File.expand_path("../../../analyzers.yml", __FILE__)
      @content = YAML.safe_load(File.read(file), symbolize_names: true, filename: file).fetch(:analyzers).freeze
    end

    def include?(id)
      @content.include?(id.to_sym)
    end

    def name(id)
      name = analyzer(id).fetch(:name)
      return name if name.is_a? String
      raise "must be a string: #{name.inspect}"
    end

    def github(id)
      analyzer(id)[:github]&.then { |repo| "https://github.com/#{repo}" }
    end

    def doc(id)
      analyzer(id).fetch(:doc).then { |path| "https://help.sider.review/#{path}" }
    end

    def website(id)
      url = analyzer(id)[:website]
      return nil if url.nil?
      return url if url.is_a? String
      raise "Must be string or nil: #{url.inspect}"
    end

    def docker(id)
      "https://hub.docker.com/r/sider/runner_#{id}"
    end

    def deprecated?(id)
      !!analyzer(id).fetch(:deprecated, false)
    end

    def beta?(id)
      !!analyzer(id).fetch(:beta, false)
    end

    private

    def analyzer(id)
      @content.fetch(id.to_sym)
    end
  end
end
