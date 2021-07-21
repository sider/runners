module Runners
  module Schema
    Metrics = _ = StrongJSON.new do
      extend ConfigTypes
      # @type self: MetricsClass

      let :config, object?(
        ignore: one_or_more_strings?,
      )
    end

    Config.register(name: :metrics, schema: Metrics.config)
  end
end
