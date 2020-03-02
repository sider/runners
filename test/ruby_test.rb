require_relative 'test_helper'

class RubyTest < Minitest::Test
  include TestHelper

  GemInstaller = Runners::Ruby::GemInstaller
  Spec = GemInstaller::Spec
  Source = GemInstaller::Source
  LockfileLoader = Runners::Ruby::LockfileLoader

  def trace_writer
    @trace_writer ||= Runners::TraceWriter.new(writer: [])
  end

  def shell
    @shell ||= Runners::Shell.new(
      current_dir: __dir__,
      env_hash: {},
      trace_writer: trace_writer
    )
  end

  def processor_class
    @processor_class ||= Class.new(Runners::Processor) do
      include Runners::Ruby

      def self.ci_config_section_name
        "rubocop"
      end
    end
  end

  def new_processor(workspace:, git_ssh_path: nil, config_yaml: nil)
    processor_class.new(
      guid: SecureRandom.uuid,
      workspace: workspace,
      config: config(config_yaml),
      git_ssh_path: git_ssh_path,
      trace_writer: trace_writer,
    )
  end

  def test_gemfile_content
    specs = [
      Spec.new(name: "rubocop", version: [], source: Source::Git.new("https://github.com/rubocop-hq/rubocop.git", branch: "master")),
      Spec.new(name: "runners", version: [], source: Source::Git.new("git@github.com:sider/runners.git", ref: "e66806c02849a0d0bdea66be88b5967d5eb3305d")),
      Spec.new(name: "rubocop-rails", version: [], source: Source::Git.new("https://github.com/rubocop-hq/rubocop-rails.git", branch: "dev")),
      Spec.new(name: "rubocop-rspec", version: [], source: Source::Git.new("https://github.com/rubocop-hq/rubocop-rspec.git", tag: "v1.13.0")),
      Spec.new(name: "rubocop-sider", version: [], source: Source::Rubygems.new("https://gems.sider.review")),
      Spec.new(name: "rubocop-nyan", version: [], source: Source::Rubygems.new("https://gems.sider.review")),
      Spec.new(name: "meowcop", version: ["1.2.0"]),
      Spec.new(name: "strong_json", version: ["0.4.0", "<= 0.8"]),
    ]

    mktmpdir do |path|
      installer = GemInstaller.new(
        shell: shell,
        specs: specs,
        home: path,
        config_path_name: "sider.yml",
        constraints: { "strong_json" => ["<= 0.8"], "rubocop" => [">= 0.55.0"] },
        trace_writer: trace_writer
      )

      assert_equal <<~CONTENT, installer.gemfile_content
        source "https://rubygems.org"

        gem "meowcop", "1.2.0"
        gem "strong_json", "0.4.0", "<= 0.8"

        source "https://gems.sider.review" do
          gem "rubocop-sider"
          gem "rubocop-nyan"
        end

        git "https://github.com/rubocop-hq/rubocop.git", branch: "master" do
          gem "rubocop"
        end

        git "git@github.com:sider/runners.git", ref: "e66806c02849a0d0bdea66be88b5967d5eb3305d" do
          gem "runners"
        end

        git "https://github.com/rubocop-hq/rubocop-rails.git", branch: "dev" do
          gem "rubocop-rails"
        end

        git "https://github.com/rubocop-hq/rubocop-rspec.git", tag: "v1.13.0" do
          gem "rubocop-rspec"
        end
      CONTENT
    end
  end

  def test_gemfile_content_without_default_gems
    mktmpdir do |path|
      installer = GemInstaller.new(
        shell: shell,
        specs: [
          Spec.new(name: "rubocop-sider", version: [], source: Source::Rubygems.new("https://gems.sider.review")),
        ],
        home: path,
        config_path_name: "sider.yml",
        constraints: {},
        trace_writer: trace_writer
      )

      assert_equal <<~CONTENT, installer.gemfile_content
        source "https://rubygems.org"

        source "https://gems.sider.review" do
          gem "rubocop-sider"
        end
      CONTENT
    end
  end

  def test_no_install
    specs = []

    mktmpdir do |path|
      installer = GemInstaller.new(
        shell: shell,
        specs: specs,
        home: path,
        config_path_name: "sider.yml",
        trace_writer: trace_writer,
        constraints: {}
      )

      installer.install! do
        shell.capture3!("bundle", "exec", "gem", "list")
      end
    end
  end

  def test_install_success
    specs = [
      Spec.new(name: "strong_json", version: ["0.5.0"]),
      Spec.new(name: "rubocop-rspec", version: ["1.32.0"],
               source: Source::Git.new("https://github.com/rubocop-hq/rubocop-rspec.git", tag: "v1.32.0")),
    ]

    mktmpdir do |path|
      installer = GemInstaller.new(
        shell: shell,
        specs: specs,
        home: path,
        config_path_name: "sider.yml",
        trace_writer: trace_writer,
        constraints: { "strong_json" => ["<= 0.8.0"] }
      )

      installer.install! do |hash|
        stdout, _ = shell.capture3("bundle", "exec", "gem", "list")
        lines = stdout.lines(chomp: true)
        assert_includes lines, "strong_json (0.5.0)"
        assert_includes lines, "rubocop-rspec (1.32.0)"
        assert_equal "0.5.0", hash["strong_json"]
        assert_equal "1.32.0", hash["rubocop-rspec"]
      end

      assert_equal([<<~MSG], trace_writer.writer.select { |m| m[:trace] == :message }.map { |m| m[:message] })
        source "https://rubygems.org"

        gem "strong_json", "0.5.0", "<= 0.8.0"

        git "https://github.com/rubocop-hq/rubocop-rspec.git", tag: "v1.32.0" do
          gem "rubocop-rspec"
        end
      MSG
    end
  end

  def test_install_failure
    specs = [
      Spec.new(name: "strong_json", version: ["0.5.0"])
    ]

    mktmpdir do |path|
      installer = GemInstaller.new(
        shell: shell,
        specs: specs,
        home: path,
        config_path_name: "sider.yml",
        trace_writer: trace_writer,
        constraints: { "strong_json" => ["> 0.6.0"] }
      )

      assert_raises GemInstaller::InstallationFailure do
        installer.install! do
        end
      end
    end
  end

  def test_from_gems
    specs = Spec.from_gems([
      "rubocop",
      { name: "strong_json", version: "0.7.0", source: "https://my.gems.org" },
      { name: "rubocop-sider", git: { repo: "https://github.com/sider/rubocop-sider.git" } },
      { name: "runners", git: { repo: "git@github.com:sider/runners.git", ref: "e66806c02849a0d0bdea66be88b5967d5eb3305d" } },
      { name: "rubocop-rails", git: { repo: "https://github.com/rubocop-hq/rubocop-rails.git", branch: "dev" } },
      { name: "rubocop-rspec", git: { repo: "https://github.com/rubocop-hq/rubocop-rspec.git", tag: "v1.13.0" } },
    ])

    assert_equal [
      Spec.new(name: "rubocop", version: []),
      Spec.new(name: "strong_json", version: ["0.7.0"], source: Source::Rubygems.new("https://my.gems.org")),
      Spec.new(name: "rubocop-sider", version: [], source: Source::Git.new("https://github.com/sider/rubocop-sider.git")),
      Spec.new(name: "runners", version: [], source: Source::Git.new("git@github.com:sider/runners.git", ref: "e66806c02849a0d0bdea66be88b5967d5eb3305d")),
      Spec.new(name: "rubocop-rails", version: [], source: Source::Git.new("https://github.com/rubocop-hq/rubocop-rails.git", branch: "dev")),
      Spec.new(name: "rubocop-rspec", version: [], source: Source::Git.new("https://github.com/rubocop-hq/rubocop-rspec.git", tag: "v1.13.0")),
    ], specs
  end

  def test_ensure_lockfile_with_gemfile_lock
    mktmpdir do |path|
      (path + "Gemfile").write(<<EOF)
source "https://rubygems.org"

gem 'activerecord'
gem 'strong_json'
gem 'rspec'
gem 'rubocop', git: "https://github.com/rubocop-hq/rubocop.git", tag: "v0.63.0"
gem 'jack_and_the_elastic_beanstalk', git: 'https://github.com/sider/jack_and_the_elastic_beanstalk.git'
EOF

      shell.push_dir(path) do
        Bundler.with_clean_env do
          shell.capture3!("bundle", "lock")
        end
      end

      content = (path + "Gemfile.lock").read
      content.gsub!("https://rubygems.org", "https://my.gems.org")
      (path + "Gemfile.lock").write content

      LockfileLoader.new(root_dir: path, shell: shell).ensure_lockfile do |lockfile|
        assert lockfile.spec_exists?("activerecord")
        assert lockfile.spec_exists?("strong_json")
        assert lockfile.spec_exists?("rspec")
        assert lockfile.spec_exists?("rubocop")
        assert lockfile.spec_exists?("jack_and_the_elastic_beanstalk")
        refute lockfile.spec_exists?("goodcheck")

        refute_nil lockfile.locked_version("activerecord")
        refute_nil lockfile.locked_version("strong_json")
        refute_nil lockfile.locked_version("rspec")
        refute_nil lockfile.locked_version("rubocop")
        refute_nil lockfile.locked_version("jack_and_the_elastic_beanstalk")
        assert_nil lockfile.locked_version("goodcheck")
      end
    end
  end

  def test_ensure_lockfile_with_gemfile_lock_generated_by_bundler_v1
    mktmpdir do |path|
      (path / "Gemfile").write(<<EOF)
source 'https://rubygems.org'
gem 'rubocop', '0.60.0'
gem 'rubocop-rspec', '1.30.1'
EOF

      (path / "Gemfile.lock").write(<<EOF)
GEM
  remote: https://rubygems.org/
  specs:
    ast (2.4.0)
    jaro_winkler (1.5.2)
    parallel (1.13.0)
    parser (2.6.0.0)
      ast (~> 2.4.0)
    powerpack (0.1.2)
    rainbow (3.0.0)
    rubocop (0.60.0)
      jaro_winkler (~> 1.5.1)
      parallel (~> 1.10)
      parser (>= 2.5, != 2.5.1.1)
      powerpack (~> 0.1)
      rainbow (>= 2.2.2, < 4.0)
      ruby-progressbar (~> 1.7)
      unicode-display_width (~> 1.4.0)
    rubocop-rspec (1.30.1)
      rubocop (>= 0.60.0)
    ruby-progressbar (1.10.0)
    unicode-display_width (1.4.1)

PLATFORMS
  ruby

DEPENDENCIES
  rubocop (= 0.60.0)
  rubocop-rspec (= 1.30.1)

BUNDLED WITH
   1.17.3
EOF

      LockfileLoader.new(root_dir: path, shell: shell).ensure_lockfile do |lockfile|
        assert lockfile.spec_exists?("rubocop")
        assert lockfile.spec_exists?("rubocop-rspec")
      end
    end
  end

  def test_ensure_lockfile_with_gemspec
    mktmpdir do |path|
      (path / "Gemfile").write(<<EOF)
source "https://rubygems.org"
gemspec
EOF

      (path / "test.gemspec").write(<<EOF)
# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "test"
  spec.version       = "0.0.1"
  spec.authors       = ["Sider"]
  spec.email         = ["support@sider.review"]

  spec.summary       = %q{test gem}
  spec.description   = %q{test gem}
  spec.homepage      = "https://github.com/sider/test"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "strong_json", "~> 0.7.1"
  spec.add_development_dependency "rubocop", "0.79.0"
end
EOF

      LockfileLoader.new(root_dir: path, shell: shell).ensure_lockfile do |lockfile|
        assert lockfile.spec_exists?("rubocop")
        assert lockfile.spec_exists?("strong_json")
      end
    end
  end

  def test_ensure_lockfile_without_gemfile_lock
    mktmpdir do |path|
      (path + "Gemfile").write(<<EOF)
source "https://rubygems.org"

gem 'activerecord'
gem 'strong_json'
gem 'rspec'
EOF

      LockfileLoader.new(root_dir: path, shell: shell).ensure_lockfile do |lockfile|
        assert lockfile.spec_exists?("activerecord")
        assert lockfile.spec_exists?("strong_json")
        assert lockfile.spec_exists?("rspec")
        refute lockfile.spec_exists?("rubocop")

        refute_nil lockfile.locked_version("activerecord")
        refute_nil lockfile.locked_version("strong_json")
        refute_nil lockfile.locked_version("rspec")
        assert_nil lockfile.locked_version("rubocop")
      end
    end
  end

  def test_ensure_lockfile_with_invalid_gemfile_only
    mktmpdir do |path|
      (path + "Gemfile").write(<<EOF)
gem 'rubocop', "< 0.59.0"
gem 'rubocop', "> 0.60.0"
EOF

      LockfileLoader.new(root_dir: path, shell: shell).ensure_lockfile do |lockfile|
        assert_empty lockfile.specs
      end
    end
  end

  def test_ensure_lockfile_with_conflict_gemfile_lock
    mktmpdir do |path|
      (path + "Gemfile").write(<<EOF)
source "https://rubygems.org"

<<<<<<< HEAD
gem "rubocop"
gem "goodcheck"
=======
gem "querly"
>>>>>>> add_querly
EOF

      (path + "Gemfile.lock").write(<<EOF)
GEM
  remote: https://rubygems.org/                                                                                                                 [33/1947]
  specs:
    activesupport (5.2.2)
      concurrent-ruby (~> 1.0, >= 1.0.2)
      i18n (>= 0.7, < 2)
      minitest (~> 5.1)
      tzinfo (~> 1.1)
    ast (2.4.0)
    concurrent-ruby (1.1.4)
<<<<<<< HEAD
    goodcheck (1.4.1)
      activesupport (~> 5.0)
      httpclient (~> 2.8.3)
      rainbow (~> 3.0.0)
      strong_json (~> 0.7.1)
    httpclient (2.8.3)
    i18n (1.5.3)
      concurrent-ruby (~> 1.0)
    jaro_winkler (1.5.2)
    minitest (5.11.3)
    parallel (1.13.0)
    parser (2.6.0.0)
=======
    i18n (1.5.3)
      concurrent-ruby (~> 1.0)
    minitest (5.11.3)
    parser (2.5.3.0)
>>>>>>> add_querly
      ast (~> 2.4.0)
    querly (0.14.0)
      activesupport (~> 5.0)
      parser (~> 2.5.0)
      rainbow (>= 2.1)
      thor (>= 0.19.0, < 0.21.0)
    rainbow (3.0.0)
<<<<<<< HEAD
    rubocop (0.63.1)
      jaro_winkler (~> 1.5.1)
      parallel (~> 1.10)
      parser (>= 2.5, != 2.5.1.1)
      powerpack (~> 0.1)
      rainbow (>= 2.2.2, < 4.0)
      ruby-progressbar (~> 1.7)
      unicode-display_width (~> 1.4.0)
    ruby-progressbar (1.10.0)
    strong_json (0.7.1)
    thread_safe (0.3.6)
    tzinfo (1.2.5)
      thread_safe (~> 0.1)
    unicode-display_width (1.4.1)
=======
    thor (0.20.3)
    thread_safe (0.3.6)
    tzinfo (1.2.5)
      thread_safe (~> 0.1)
>>>>>>> add_querly

PLATFORMS
  ruby

DEPENDENCIES
<<<<<<< HEAD
  goodcheck
  rubocop
=======
  querly
>>>>>>> add_querly

BUNDLED WITH
   1.17.1
EOF

      assert_raises LockfileLoader::InvalidGemfileLock do
        LockfileLoader.new(root_dir: path, shell: shell).ensure_lockfile do
          # noop
        end
      end
    end
  end

  def test_merge_specs
    default_specs = [
      Spec.new(name: "rubocop", version: ["0.4.0"]),
      Spec.new(name: "strong_json", version: ["0.4.0"])
    ]

    user_specs = [
      Spec.new(name: "rubocop", version: ["0.5.0"], source: "https://some.source.org"),
      Spec.new(name: "rubocop-rspec", version: ["1.2.3"])
    ]

    assert_equal [
                   Spec.new(name: "rubocop", version: ["0.5.0"], source: "https://some.source.org"),
                   Spec.new(name: "strong_json", version: ["0.4.0"]),
                   Spec.new(name: "rubocop-rspec", version: ["1.2.3"])
                 ],
                 Spec.merge(default_specs, user_specs)
  end

  def test_install_no_gems
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)
      processor.install_gems([Spec.new(name: "strong_json", version: ["0.5.0"])],
                         constraints: {}) do
        stdout, _ = processor.shell.capture3!("bundle", "show")
        assert_includes stdout.lines, "  * strong_json (0.5.0)\n"
      end
    end
  end

  def test_install_gems_with_gems
    with_workspace do |workspace|
      (workspace.working_dir + "Gemfile").write(<<EOF)
source "https://rubygems.org"

gem 'meowcop'
EOF

      shell.push_dir(workspace.working_dir) do
        Bundler.with_clean_env do
          shell.capture3!("bundle", "lock")
        end
      end

      processor = new_processor(workspace: workspace, config_yaml: <<~YAML)
        linter:
          rubocop:
            gems: ["strong_json"]
      YAML
      processor.install_gems([Spec.new(name: "rubocop", version: ["0.63.0"])],
                             optionals: [Spec.new(name: "meowcop", version: ["1.17.1"])],
                             constraints: {}) do
        stdout, _ = processor.shell.capture3!("bundle", "show")
        assert_match(/\* rubocop/, stdout)
        assert_match(/\* strong_json/, stdout)
        refute_match(/\* meowcop/, stdout)
      end
    end
  end

  def test_install_gems_with_gems_failure
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace, config_yaml: <<~YAML)
        linter:
          rubocop:
            gems: ["no such gem"]
      YAML

      assert_raises GemInstaller::InstallationFailure do
        processor.install_gems([Spec.new(name: "rubocop", version: ["0.63.0"])],
                               optionals: [Spec.new(name: "meowcop", version: ["1.17.1"])],
                               constraints: {}) do
          # nop
        end
      end
    end
  end

  def test_install_gems_with_optionals
    with_workspace do |workspace|
      (workspace.working_dir + "Gemfile").write(<<EOF)
source "https://rubygems.org"

gem 'meowcop'
EOF

      shell.push_dir(workspace.working_dir) do
        Bundler.with_clean_env do
          shell.capture3!("bundle", "lock")
        end
      end

      processor = new_processor(workspace: workspace)
      processor.install_gems([Spec.new(name: "rubocop", version: ["0.63.0"])],
                             optionals: [Spec.new(name: "meowcop", version: ["1.17.1"])],
                             constraints: {}) do
        stdout, _ = processor.shell.capture3!("bundle", "show")
        assert_match(/\* rubocop/, stdout)
        assert_match(/\* meowcop/, stdout)
      end
    end
  end

  def test_install_gems_with_gemfile_lock
    with_workspace do |workspace|
      (workspace.working_dir + "Gemfile").write(<<EOF)
source "https://rubygems.org"

gem 'rubocop', '0.62.0'
gem 'strong_json', '0.7.1'
gem 'jack_and_the_elastic_beanstalk', '0.2.3'
gem 'meowcop'
gem 'activerecord'
EOF

      shell.push_dir(workspace.working_dir) do
        Bundler.with_clean_env do
          shell.capture3!("bundle", "lock")
        end
      end

      processor = new_processor(workspace: workspace, config_yaml: <<~YAML)
        linter:
          rubocop:
            gems:
              - strong_json
              - name: jack_and_the_elastic_beanstalk
                version: "0.2.2"
      YAML

      processor.install_gems([Spec.new(name: "rubocop", version: ["0.63.0"])],
                             optionals: [Spec.new(name: "meowcop", version: ["1.17.1"])],
                             constraints: { "rubocop" => ["> 0.60.0"] }) do
        stdout, _ = processor.shell.capture3!("bundle", "show")
        assert_match(/\* rubocop \(0.62.0\)/, stdout)
        assert_match(/\* strong_json \(0.7.1\)/, stdout)
        assert_match(/\* jack_and_the_elastic_beanstalk \(0.2.2\)/, stdout)
        refute_match(/\* meowcop/, stdout)
        refute_match(/\* activerecord/, stdout)
      end
    end
  end


  def test_install_gems_with_gemfile_lock_which_does_not_satisfy_constraints
    with_workspace do |workspace|
      (workspace.working_dir + "Gemfile").write(<<EOF)
source "https://rubygems.org"

gem 'rubocop', '0.62.0'
EOF

      shell.push_dir(workspace.working_dir) do
        Bundler.with_clean_env do
          shell.capture3!("bundle", "lock")
        end
      end

      processor = new_processor(workspace: workspace)
      processor.install_gems([Spec.new(name: "rubocop", version: ["0.66.0"])],
                             constraints: { "rubocop" => ["> 0.65.0"] }) do
        assert_equal 1, processor.warnings.count
        assert_equal <<~MESSAGE, processor.warnings.first[:message]
          Sider tried to install `rubocop 0.62.0` according to your `Gemfile.lock`, but it installs `0.66.0` instead.
          Because `0.62.0` does not satisfy the Sider constraints ["> 0.65.0"].

          If you want to use a different version of `rubocop`, update your `Gemfile.lock` to satisfy the constraint or specify the gem version in your `sider.yml`.
          See https://help.sider.review/getting-started/custom-configuration#gems-option
        MESSAGE

        stdout, _ = processor.shell.capture3!("bundle", "show")
        assert_match(/\* rubocop \(0.66.0\)/, stdout)
      end
    end
  end

  def test_install_gems_with_gems_which_does_not_satisfy_constraints
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace, config_yaml: <<~YAML)
        linter:
          rubocop:
            gems:
              - name: rubocop
                version: "0.62.0"
      YAML

      assert_raises GemInstaller::InstallationFailure do
        processor.install_gems([Spec.new(name: "rubocop", version: ["0.66.0"])],
                               constraints: { "rubocop" => ["> 0.65.0"] }) do
          # noop
        end
      end
    end
  end

  def test_install_gems_with_other_sources
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace, config_yaml: <<~YAML)
        linter:
          rubocop:
            gems:
              - name: rubocop-rspec
                version: "1.28.0"
                source: "https://rubygems.cae.me.uk"
      YAML

      processor.install_gems([Spec.new(name: "rubocop", version: ["0.63.0"])],
                             optionals: [],
                             constraints: {}) do
        stdout, _ = processor.shell.capture3!("bundle", "show")
        assert_includes stdout, "* rubocop-rspec ("
      end
    end
  end

  def test_install_gems_with_git_sources
    with_workspace(head: (Pathname(__dir__) + "data/foo.tgz").to_s,
                   ssh_key: (Pathname(__dir__) + "data/ruby_private_gem_deploy_key").read) do |workspace|
      workspace.open do |git_ssh_path|
        processor = new_processor(workspace: workspace, git_ssh_path: git_ssh_path, config_yaml: <<~YAML)
          linter:
            rubocop:
              gems:
                - name: jack_and_the_elastic_beanstalk
                  git:
                    repo: https://github.com/sider/jack_and_the_elastic_beanstalk.git
                    branch: master
                - name: meowcop
                  git:
                    repo: https://github.com/sider/meowcop.git
                    tag: v1.16.0
                - name: configure
                  git:
                    repo: https://github.com/sider/configure.git
                    ref: 9b4703aea9dee97fe0ada15812c46ecf622c352c
                - name: ruby_private_gem
                  git:
                    repo: git@github.com:sider/ruby_private_gem.git
                    branch: gem
        YAML
        processor.install_gems([Spec.new(name: "rubocop", version: ["0.63.0"])],
                               optionals: [],
                               constraints: {}) do
          stdout, _ = processor.shell.capture3!("bundle", "show")
          assert_match(/\* rubocop/, stdout)
          assert_match(/\* jack_and_the_elastic_beanstalk/, stdout)
          assert_match(/\* meowcop \(1.16.0 2f52514\)/, stdout)
          assert_match(/\* configure \(0.1.0 9b4703a\)/, stdout)
          assert_match(/\* ruby_private_gem/, stdout)
        end
      end
    end
  end

  def test_install_gems_with_only_git_sources
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace, config_yaml: <<~YAML)
        linter:
          rubocop:
            gems:
              - name: rubocop
                git:
                  repo: https://github.com/rubocop-hq/rubocop.git
                  tag: v0.63.1
      YAML

      processor.install_gems([], optionals: [], constraints: {}) do
        stdout, _ = processor.shell.capture3!("bundle", "show")
        assert_match(/\* rubocop/, stdout)
      end
    end
  end

  def test_install_gems_with_only_other_rubygems
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace, config_yaml: <<~YAML)
        linter:
          rubocop:
            gems:
              - name: rack
                version: "2.2.2"
                source: https://rubygems.cae.me.uk
      YAML

      processor.install_gems([], optionals: [], constraints: {}) do
        stdout, _ = processor.shell.capture3!("bundle", "show")
        assert_match(/\* rack \(2.2.2\)/, stdout)
      end
    end
  end

  def test_installed_gem_versions
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)
      mock(processor).capture3!("gem", "list", "--quiet", "--exact", "rubocop", "meowcop") do
        <<~OUTPUT
          rubocop (0.75.1, 0.75.0)
          meowcop (2.4.0)
        OUTPUT
      end
      assert_equal({ "rubocop" => ["0.75.1", "0.75.0"], "meowcop" => ["2.4.0"] },
                   processor.installed_gem_versions("rubocop", "meowcop"))

      mock(processor).capture3!("gem", "list", "--quiet", "--exact", "foo") { "" }
      assert_raises(RuntimeError) { processor.installed_gem_versions("foo") }.tap do |error|
        assert_equal 'Not found installed gem "foo"', error.message
      end

      mock(processor).capture3!("gem", "list", "--quiet", "--exact", "foo", "meowcop") do
        <<~OUTPUT
          meowcop (2.4.0)
        OUTPUT
      end
      assert_equal({ "meowcop" => ["2.4.0"] },
                   processor.installed_gem_versions("foo", "meowcop", exception: false))
    end
  end

  def test_default_gem_specs
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      mock(processor).analyzer_bin { "rubocop" }
      mock(processor).capture3!("gem", "list", "--quiet", "--exact", "rubocop").twice do
        <<~OUTPUT
          rubocop (0.75.1, 0.75.0)
        OUTPUT
      end
      assert_equal [Spec.new(name: "rubocop", version: ["0.75.1", "0.75.0"])], processor.default_gem_specs
      assert_equal [Spec.new(name: "rubocop", version: ["0.75.1", "0.75.0"])], processor.default_gem_specs("rubocop")

      mock(processor).capture3!("gem", "list", "--quiet", "--exact", "foo", "bar") do
        <<~OUTPUT
          foo (1.2.3)
          bar (4.5.6)
        OUTPUT
      end
      assert_equal [
        Spec.new(name: "foo", version: ["1.2.3"]),
        Spec.new(name: "bar", version: ["4.5.6"]),
      ], processor.default_gem_specs("foo", "bar")
    end
  end
end
