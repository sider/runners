module Runners
  class Workspace
    include Tmpdir

    def self.prepare(options:, working_dir:, trace_writer:)
      Workspace::Git.new(options: options, working_dir: working_dir, trace_writer: trace_writer)
    end

    attr_reader :options, :working_dir, :trace_writer, :shell

    def initialize(options:, working_dir:, trace_writer:)
      @options = options
      @working_dir = working_dir
      @trace_writer = trace_writer
      @shell = Shell.new(current_dir: working_dir, trace_writer: trace_writer, env_hash: {})
    end

    def open
      prepare_ssh do |git_ssh_path|
        trace_writer.header "Set up source code"

        trace_writer.message "Preparing head commit tree..."
        prepare_head_source

        changes =
          if options.source.base
            trace_writer.message "Calculating changes between head and base..." do
              Changes.calculate_by_patches(working_dir: working_dir, patches: patches)
            end
          else
            trace_writer.message "Calculating changes..." do
              Changes.calculate(working_dir: working_dir)
            end
          end

        yield git_ssh_path, changes
      end
    end

    def range_git_blame_info(path_string, start_line, end_line, trace: false)
      []
    end

    def prepare_head_source
      raise NotImplementedError
    end

    def patches
      raise NotImplementedError
    end

    private

    def prepare_ssh
      ssh_key = options.ssh_key
      if ssh_key
        mktmpdir do |dir|
          trace_writer.message "Preparing SSH config..."

          known_hosts_path = dir / 'known_hosts'
          known_hosts_path.write ''
          known_hosts_path.chmod 0600

          key_path = dir / 'key'
          key_path.write ssh_key
          key_path.chmod 0600

          config_path = dir / 'config'
          config_path.write <<~SSH_CONFIG
            Host *
              CheckHostIP no
              ConnectTimeout 30
              UserKnownHostsFile #{known_hosts_path}
              StrictHostKeyChecking no
              IdentitiesOnly yes
              IdentityFile #{key_path}
          SSH_CONFIG
          config_path.chmod 0600

          yield config_path
        end
      else
        yield nil
      end
    end
  end
end
