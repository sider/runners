module Runners
  class Processor::Languagetool < Processor
    include Java

    Schema =
      StrongJSON.new do
        let :runner_config,
            Schema::BaseConfig.base.update_fields { |fields|
              fields.merge!(
                {
                  language: string?,
                  target_dir: enum?(string, array(string)),
                  target_file: enum?(string, array(string)),
                }
              )
            }
        let :issue, object(severity: string?)
      end

    register_config_schema(name: :languagetool, schema: Schema.runner_config)

    DEFAULT_TARGET = ".".freeze
    DEFAULT_LANGUAGE = "en-US".freeze

    # Output format:
    #
    #      [{:message=>
    #      "{"software":{"name":"LanguageTool","version":"4.8","buildDate":"2019-12-27 13:18","apiVersion":1,
    #      "premium":false,"premiumHint":"You might be missing errors only the Premium version can find. Contact us at support<at>languagetoolplus.com.", "status":""},
    #      "warnings":{"incompleteResults":false},
    #      "language":{"name":"English","code":"en","detectedLanguage":{"name":"English","code":"en","confidence":1.0}},
    #      "matches":[{"message":"Use "a" instead of 'an' if the following word doesn't start with a vowel sound, e.g. 'a sentence', 'a university'","shortMessage":"Wrong article",
    #      "replacements":[{"value":"a"}],"offset":192,"length":2,
    #      "context":{"text":"...on potential errors. Or use this text to see an few of the problems that LanguageTool can de...", "offset":48,"length":2},
    #      "sentence":"Or use this text to see an few of the problems that LanguageTool can detecd.",
    #      "type":{"typeName":"Other"},
    #      "rule":{"id":"EN_A_VS_AN",
    #      "description":"Use of 'a' vs. 'an'",
    #      "issueType":"misspelling","category":{"id":"MISC","name":"Miscellaneous"}},
    #      "ignoreForIncompleteSentence":false,"contextForSureMatch":1}]}",
    # {"message"=>"Use \"a\" instead of 'an' if the following word doesn't start with a vowel sound, e.g. 'a sentence', 'a university'", "shortMessage"=>"Wrong article", "replacements"=>[{"value"=>"a"}], "offset"=>192, "length"=>2, "context"=>{"text"=>"...on potential errors. or use this text to see an few of the problems that LanguageTool can de...", "offset"=>48, "length"=>2}, "sentence"=>"or use this text to see an few of the problems that LanguageTool can detecd.", "type"=>{"typeName"=>"Other"}, "rule"=>{"id"=>"EN_A_VS_AN", "description"=>"Use of 'a' vs. 'an'", "issueType"=>"misspelling", "category"=>{"id"=>"MISC", "name"=>"Miscellaneous"}}#
    def analyze(changes)
      run_analyzer
    end

    private

    def target_language
      language = config_linter[:language] || DEFAULT_LANGUAGE
      ["--language", language]
    end

    def check_target
      return config_linter[:target_file] unless config_linter[:target_file].nil?
      dir = config_linter[:target_dir] || DEFAULT_TARGET
      ["--recursive", dir]
    end

    def run_analyzer
      # todo somehow, target file will be extracted from stderr
      # "Expected text language: English (GB)\nWorking on sample.txt...\n"
      stdout, stderr, status = capture3(
        analyzer_bin,
        ## TODO --recursive can be used only if directory is specified
        "--json",
        *target_language,
        *check_target
      )

      working_files = stderr.split(/\R/)
                        .map { |output| output.match(/Working on (.*).../) }
                        .compact
                        .map { |match| match[1] }
      #analyzer_bin,
      # )
      # if recursive option is specified, the json output style is invalid.
     # output = "[#{stdout.sub!('}{', '},{')}]]]"
     #  output = stdout.sub('}{', '},{')

      output = stdout
      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        matches = JSON.parse(output)['matches']
        return result if matches.empty?
        # matches.each_with_index do |match, index|
        matches.each do |match|
          result.add_issue Issue.new(
            # TODO fix working file when multiple files
            path: relative_path(working_files[0]),
            location: nil,
            id: match['rule']['id'],
            message: "#{match['message']} -> #{match['sentence']}",
          )
        end
      end
    end
  end
end
