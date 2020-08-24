module Runners
  module Schema
    Options = _ = StrongJSON.new do
      # @type self: Types::Options

      let :source, object?(
        head: string,
        base: string?,
        git_url: string,
        git_url_userinfo: string?,
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
