require "net/http"
require "json"
require "yaml"

namespace :bump do
  desc "Bump analyzers and create new pull requests"
  task :analyzers do
    dry_run = ENV.key?("DRY_RUN")

    BumpAnalyzers.each do |t|
      puts "Bumping #{t.analyzer}..."

      t.update_version! dry_run: dry_run
      if t.updated
        puts "  --> #{t.current_version} => #{t.latest_version}"
        next if dry_run
      else
        puts "  --> none"
        next
      end

      if t.branch_exist? t.head_branch
        puts "  --> `#{t.head_branch}` branch exists. Skipped."
      else
        t.commit_and_push_changes!
        t.create_pull_request!
        t.add_labels!
        puts "  --> #{t.pull_request_url}"
      end
    end

    puts "This is a dry-run mode. No changes." if dry_run
  end
end

BumpAnalyzers = Struct.new(
  :analyzer, :analyzer_name, :github_repo,
  :current_version, :updated, :pull_request_url,
  keyword_init: true
) do

  class GitHubAPIFailed < StandardError
    attr_reader :response_code
    attr_reader :response_body

    def initialize(response)
      super(<<~MSG)
        #{response.code} #{response.message}
        #{response.body}
      MSG
      @response_code = response.code
      @response_body = response.body
    end
  end

  def self.each
    analyzers = YAML.safe_load(Pathname(__dir__).join("..", "..", "analyzers.yml").read, symbolize_names: true).fetch(:analyzers)
    analyzers.keep_if { |_, meta| meta[:dependabot] == false && !meta[:deprecated]  }
    analyzers.each do |analyzer, meta|
      yield new(
        analyzer: analyzer,
        analyzer_name: meta.fetch(:name),
        github_repo: meta.fetch(:github),
      )
    end
  end

  def github_token
    ENV.fetch("GITHUB_TOKEN")
  end

  def call_github_api(method, path, body = nil)
    uri = URI.join("https://api.github.com", path)
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "token #{github_token}",
      }
      response =
        case method
        when :get
          http.request_get uri.path, headers
        when :post
          http.request_post uri.path, body.to_json, headers
        else
          raise ArgumentError, "Unknown method: #{method.inspect}"
        end
      if response.kind_of? Net::HTTPSuccess
        JSON.parse response.body, symbolize_names: true
      else
        raise GitHubAPIFailed.new(response)
      end
    end
  end

  # @see https://docs.github.com/en/rest/reference/git#list-matching-references
  def tags
    @tags ||= call_github_api(:get, "/repos/#{github_repo}/git/refs/tags")
      .reject { |tag| tag.fetch(:ref).include?("beta") }
      .map { |tag| tag.fetch(:ref).delete_prefix("refs/tags/") }
  end

  def latest_version
    @latest_version ||= tags.last.delete_prefix("v")
  end

  def original_github_repo
    ENV.fetch("GITHUB_REPOSITORY")
  end

  # @see https://docs.github.com/en/rest/reference/git#get-a-tree
  def branch_exist?(branch)
    call_github_api(:get, "/repos/#{original_github_repo}/git/trees/#{branch}")
    true
  rescue GitHubAPIFailed => exn
    if exn.response_code == "404"
      false
    else
      raise
    end
  end

  # @see https://docs.github.com/en/rest/reference/pulls#create-a-pull-request
  def create_pull_request!
    call_github_api(:post, "/repos/#{original_github_repo}/pulls", {
      title: pull_request_title,
      body: pull_request_body,
      head: head_branch,
      base: default_branch,
    }).tap do |pull_request|
      self.pull_request_url = pull_request.fetch(:html_url)
    end
  end

  def pull_request_title
    "Bump #{analyzer_name} from #{current_version} to #{latest_version}"
  end

  def pull_request_body
    latest_tag = tags.last
    current_tag = tags.find { |tag| tag.include? current_version }

    <<~MARKDOWN
      - Release: https://github.com/#{github_repo}/releases/tag/#{latest_tag}
      - Compare: https://github.com/#{github_repo}/compare/#{current_tag}...#{latest_tag}
    MARKDOWN
  end

  def head_branch
    "bump-#{analyzer}-#{current_version}-to-#{latest_version}"
  end

  def default_branch
    "master"
  end

  def update_version!(dry_run: false)
    updated = false
    current_version = nil

    Pathname.glob("images/#{analyzer}/Dockerfile*").each do |file|
      old_content = file.read

      new_content = old_content.sub(/\b(ARG|ENV) (\w+)=(\d+\.\d+(\.\d+)?)\b/) do
        type = $1
        name = $2
        current_version = $3
        "#{type} #{name}=#{latest_version}"
      end
      if old_content != new_content
        file.write(new_content) unless dry_run
        updated = true
      end

      new_content = old_content.sub(/ --from=(.+):v(\d+\.\d+\.\d+)/) do
        current_version = $2
        " --from=#{$1}:v#{latest_version}"
      end
      if old_content != new_content
        file.write(new_content) unless dry_run
        updated = true
      end
    end

    self.current_version = current_version
    self.updated = updated
  end

  def github_remote_repo
    "https://#{ENV.fetch('GITHUB_ACTOR')}:#{github_token}@github.com/#{original_github_repo}.git"
  end

  def commit_and_push_changes!
    run "git", "config", "user.name", ENV.fetch("GITHUB_AUTHOR_NAME")
    run "git", "config", "user.email", ENV.fetch("GITHUB_AUTHOR_EMAIL")
    run "git", "checkout", "--quiet", default_branch
    run "git", "checkout", "--quiet", "-B", head_branch
    run "git", "commit", "--quiet", "--all", "--message", <<~MSG
      #{pull_request_title}

      #{pull_request_body}
    MSG
    run "git", "push", "--quiet", github_remote_repo, "HEAD:#{head_branch}"
  end

  def run(*cmd)
    system(*cmd, exception: true)
  end

  # @see https://docs.github.com/en/rest/reference/issues#add-labels-to-an-issue
  def add_labels!
    pull_number = Integer(self.pull_request_url.split("/").last)
    call_github_api(:post, "/repos/#{original_github_repo}/issues/#{pull_number}/labels", {
      labels: ["dependencies"],
    })
  end
end
