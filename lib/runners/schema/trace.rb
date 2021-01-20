module Runners
  module Schema
    Trace = _ = StrongJSON.new do
      # @type self: TraceClass

      let :command_line, object(trace: literal(:command_line), command_line: array(string), recorded_at: string)
      let :status, object(trace: literal(:status), status: number, recorded_at: string)
      let :stdout, object(trace: literal(:stdout), string: string, recorded_at: string, truncated: boolean)
      let :stderr, object(trace: literal(:stderr), string: string, recorded_at: string, truncated: boolean)
      let :message, enum(
        object(trace: literal(:message), message: string, recorded_at: string, truncated: boolean),
        object(trace: literal(:message), message: string, recorded_at: string, truncated: boolean, duration_in_ms: integer),
      )
      let :header, object(trace: literal(:header), message: string, recorded_at: string)
      let :warning, object(trace: literal(:warning), message: string, file: string?, recorded_at: string)
      let :ci_config, object(trace: literal(:ci_config), content: any, raw_content: string, file: string, recorded_at: string)
      let :error, object(trace: literal(:error), message: string, recorded_at: string, truncated: boolean)
      let :finish, object(trace: literal(:finish), duration_in_ms: integer, started_at: string, finished_at: string, recorded_at: string)
      let :anything, enum(command_line, status, stdout, stderr, message, header, warning, ci_config, error, finish)
    end
  end
end
