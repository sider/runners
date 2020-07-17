module Runners
  module Schema
    Options = _ = StrongJSON.new do
      # @type self: Types::Options

      let :source, enum(
        object(head: string, base: string?, git_http_url: string, owner: string, repo: string, git_http_userinfo: string?, pull_number: number?),
      )

      let :payload, object(
        source: source,
        outputs: array?(string),
        ssh_key: string?,
      )
    end
  end
end
