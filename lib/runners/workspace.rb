module Runners
  class Workspace
    include Tmpdir

    class DownloadError < SystemError; end

    def self.prepare(options:, working_dir:, trace_writer:)
      case options.source
      when Options::GitSource
        Workspace::Git.new(options: options, working_dir: working_dir, trace_writer: trace_writer)
      else
        raise ArgumentError, "The specified options #{options.inspect} is not supported"
      end
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

    def range_git_blame_info(path_string, start_line, end_line)
      []
    end

    def prepare_ssh
      ssh_key = options.ssh_key
      if ssh_key
        mktmpdir do |dir|
          trace_writer.message "Preparing SSH config..."

          config_path = dir / 'config'
          key_path = dir / 'key'
          script_path = dir / 'run.sh'
          known_hosts_path = dir / 'known_hosts'

          config_path.write(<<~SSH_CONFIG, perm: 0600)
            Host *
              CheckHostIP no
              ConnectTimeout 30
              UserKnownHostsFile #{known_hosts_path}
              StrictHostKeyChecking no
              IdentitiesOnly yes
              IdentityFile #{key_path}
          SSH_CONFIG
          key_path.write(ssh_key, perm: 0600)
          known_hosts_path.write('', perm: 0600)
          script_path.write(<<~GIT_SSH, perm: 0700)
            #!/bin/sh
            ssh -F #{config_path} "$@"
          GIT_SSH
          yield script_path
        end
      else
        yield nil
      end
    end

    def prepare_head_source
      raise NotImplementedError
    end

    def patches
      raise NotImplementedError
    end
  end
end
