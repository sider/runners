module Runners
  module Schema
    Options = _ = StrongJSON.new do
      # @type self: Types::Options

      let :source, object?(
        head: string,
        base: string?,
        git_http_url: string,
        git_http_userinfo: string?,
        owner: string,
        repo: string,
        pull_number: number?,
      )

      let :payload, object(
        source: source,
        outputs: array?(string),
        ssh_key: string?,
      )
    end
  end
end
