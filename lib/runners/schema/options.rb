module Runners
  module Schema
    Options = _ = StrongJSON.new do
      # @type self: Types::Options

      let :source, object?(
        head: string,
        base: string?,
        git_url: string,
        git_url_userinfo: string?,
        refspec: enum?(string, array(string)),
      )

      let :payload, object(
        source: source,
        outputs: array?(string),
        ssh_key: string?,
        s3: object?(endpoint: string),
        new_issue_schema: boolean?,
      )
    end
  end
end
