require_relative "../test_helper"

class WorkspaceHTTPTest < Minitest::Test
  include TestHelper

  def remote_file
    "https://raw.githubusercontent.com/sider/runners/master/test/data/foo.tgz"
  end

  def test_prepare_source
    with_workspace(head: remote_file, head_key: nil, base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::HTTP, workspace
      mktmpdir do |dest|
        workspace.send(:prepare_head_source, dest)
        refute_empty dest.children
      end
    end
  end

  def test_prepare_head_source_with_retry_on_download_error
    with_workspace(head: remote_file, head_key: nil, base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::HTTP, workspace
      any_instance_of(Net::HTTP) do |http|
        stub(http).request_get.with_any_args.yields(Net::HTTPResponse.new('1.1', 500, 'error'))
      end
      stub(workspace).retryable_sleep { 0 }
      assert_raises(Runners::Workspace::DownloadError) do
        mktmpdir do |dest|
          workspace.send(:prepare_head_source, dest)
        end
      end
      assert_equal [
        "Downloading source code...",
        "Retrying download... (attempt: 1)",
        "Retrying download... (attempt: 2)",
        "Retrying download... (attempt: 3)",
        "Retrying download... (attempt: 4)",
      ], workspace.trace_writer.writer.map { |t| t[:message] }.compact
    end
  end

  def test_prepare_head_source_with_retry_on_net_open_timeout
    with_workspace(head: remote_file, head_key: nil, base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::HTTP, workspace
      stub(Net::HTTP).start.with_any_args { raise Net::OpenTimeout }
      stub(workspace).retryable_sleep { 0 }
      assert_raises(Net::OpenTimeout) do
        mktmpdir do |dest|
          workspace.send(:prepare_head_source, dest)
        end
      end
      assert_equal [
        "Downloading source code...",
        "Retrying download... (attempt: 1)",
        "Retrying download... (attempt: 2)",
        "Retrying download... (attempt: 3)",
        "Retrying download... (attempt: 4)",
      ], workspace.trace_writer.writer.map { |t| t[:message] }.compact
    end
  end

  def test_prepare_head_source_with_redirect
    with_workspace(head: remote_file, head_key: nil, base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::HTTP, workspace
      redirect = Net::HTTPRedirection.new('1.1', 303, 'redirect')
      stub(redirect)['Location'] { remote_file }
      any_instance_of(Net::HTTP) do |http|
        stub(http).request_get.with_any_args.yields(redirect)
      end
      error = assert_raises(ArgumentError) do
        mktmpdir do |dest|
          workspace.send(:prepare_head_source, dest)
        end
      end
      assert_equal "Too many HTTP redirects: #{remote_file}", error.message
    end
  end

  def test_prepare_base_source_raise_if_base_is_nil
    with_workspace(head: remote_file, head_key: nil, base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::HTTP, workspace
      mktmpdir do |dest|
        assert_raises do
          workspace.send(:prepare_base_source, dest)
        end
      end
    end
  end
end
