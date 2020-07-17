type Runners::Schema::Types::location = {
  start_line: Integer,
  start_column: Integer?,
  end_line: Integer?,
  end_column: Integer?
}

type Runners::Schema::Types::git_blame_info = {
  commit: String,
  original_line: Integer,
  final_line: Integer,
  line_hash: String,
}

type Runners::Schema::Types::issue = {
  id: String,
  path: String,
  location: location,
  message: String,
  links: Array<String>,
  object: any?,
  git_blame_info: git_blame_info?,
}

class Runners::Schema::Types::Issue < StrongJSON
  def location: -> StrongJSON::Type::Enum<location>
  def git_blame_info: -> StrongJSON::Type::Object<git_blame_info>
  def issue: -> StrongJSON::Type::Object<issue>
end

type Runners::Schema::Types::analyzer = { name: String, version: String }

type Runners::Schema::Types::success_result = {
  guid: String,
  timestamp: String,
  type: "success",
  issues: Array<issue>,
  analyzer: analyzer
}

type Runners::Schema::Types::failure_result = {
  guid: String,
  timestamp: String,
  type: "failure",
  message: String,
  analyzer: analyzer?
}

type Runners::Schema::Types::error_result = {
  guid: String,
  timestamp: String,
  type: "error",
  class: String,
  backtrace: Array<String>,
  inspect: String
}

type Runners::Schema::Types::warning = { message: String, file: String? }

class Runners::Schema::Types::Result < StrongJSON
  def warning: -> StrongJSON::Type::Object<warning>
  def analyzer: -> StrongJSON::Type::Object<analyzer>
  def success: -> StrongJSON::Type::Object<success_result>
  def failure: -> StrongJSON::Type::Object<failure_result>
  def error: -> StrongJSON::Type::Object<error_result>
  def envelope: -> StrongJSON::Type::Object<{
    result: success_result | failure_result | error_result,
    warnings: Array<warning>,
    ci_config: any,
    version: String,
  }>
end

type Runners::Schema::Types::command_line_trace = {
  trace: "command_line",
  command_line: Array<String>,
  recorded_at: String
}

type Runners::Schema::Types::status_trace = {
  trace: "status",
  status: Integer,
  recorded_at: String
}

type Runners::Schema::Types::stdout_trace = {
  trace: "stdout",
  string: String,
  recorded_at: String
}

type Runners::Schema::Types::stderr_trace = {
  trace: "stderr",
  string: String,
  recorded_at: String
}

type Runners::Schema::Types::message_trace = {
  trace: "message",
  message: String,
  recorded_at: String
}

type Runners::Schema::Types::header_trace = {
  trace: "header",
  message: String,
  recorded_at: String
}

type Runners::Schema::Types::warning_trace = {
  trace: "warning",
  string: String,
  file: String?,
  recorded_at: String
}

type Runners::Schema::Types::ci_config_trace = {
  trace: "ci_config",
  content: any,
  recorded_at: String
}

type Runners::Schema::Types::error_trace = {
  trace: "error",
  message: String,
  recorded_at: String
}

type Runners::Schema::Types::any_trace = command_line_trace
                                           | status_trace
                                           | stdout_trace
                                           | stderr_trace
                                           | message_trace
                                           | header_trace
                                           | warning_trace
                                           | ci_config_trace
                                           | error_trace

class Runners::Schema::Types::Trace < StrongJSON
  def command_line: -> StrongJSON::Type::Object<command_line_trace>
  def status: -> StrongJSON::Type::Object<status_trace>
  def stdout: -> StrongJSON::Type::Object<stdout_trace>
  def stderr: -> StrongJSON::Type::Object<stderr_trace>
  def message: -> StrongJSON::Type::Object<message_trace>
  def header: -> StrongJSON::Type::Object<header_trace>
  def warning: -> StrongJSON::Type::Object<warning_trace>
  def ci_config: -> StrongJSON::Type::Object<ci_config_trace>
  def error: -> StrongJSON::Type::Object<error_trace>
  def anything: -> StrongJSON::Type::Enum<any_trace>
end

type Runners::Schema::Types::base_runner_config = {
  root_dir: String?
}

type Runners::Schema::Types::git_branch_runner_config = {
  repo: String,
  branch: String
}

type Runners::Schema::Types::git_tag_runner_config = {
  repo: String,
  tag: String
}

type Runners::Schema::Types::git_ref_runner_config = {
  repo: String,
  ref: String
}

type Runners::Schema::Types::git_runner_config = git_branch_runner_config | git_tag_runner_config | git_ref_runner_config

type Runners::Schema::Types::gem_source_runner_config = {
  name: String,
  version: String,
  source: String?
}

type Runners::Schema::Types::gem_git_runner_config = {
  name: String,
  git: git_runner_config
}

type Runners::Schema::Types::gem_runner_config = String | gem_source_runner_config | gem_git_runner_config

type Runners::Schema::Types::ruby_runner_config = {
  root_dir: String?,
  gems: Array<gem_runner_config>?
}

type Runners::Schema::Types::npm_install_runner_config = bool | "development" | "production"

type Runners::Schema::Types::npm_runner_config = {
  root_dir: String?,
  npm_install: npm_install_runner_config?
}

type Runners::Schema::Types::array_or_string = Array<String> | String

type Runners::Schema::Types::config_payload = {
  linter: StrongJSON::Type::Object?, # OK
  ignore: StrongJSON::Type::Enum<array_or_string>?,
  branches: StrongJSON::Type::Object<{
    branches: StrongJSON::Type::Enum<array_or_string>?
  }>?,
}

class Runners::Schema::Types::BaseConfig < StrongJSON
  def base: -> StrongJSON::Type::Object<base_runner_config>
  def git: -> StrongJSON::Type::Enum<git_runner_config>
  def ruby: -> StrongJSON::Type::Object<ruby_runner_config>
  def npm_install: -> StrongJSON::Type::Enum<npm_install_runner_config>
  def npm: -> StrongJSON::Type::Object<npm_runner_config>
end

class Runners::Schema::Types::Config < StrongJSON
  def payload: -> StrongJSON::Type::Object<config_payload>
  def register: (name: Symbol, schema: any) -> void
end

Runners::Schema::Issue: Runners::Schema::Types::Issue
Runners::Schema::Result: Runners::Schema::Types::Result
Runners::Schema::Trace: Runners::Schema::Types::Trace
Runners::Schema::BaseConfig: Runners::Schema::Types::BaseConfig
Runners::Schema::Config: Runners::Schema::Types::Config
