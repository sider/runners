Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "success",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "app.java",
        location: {
          start_line: 1,
          start_column: 1,
          end_line: 28,
          end_column: 1
        },
        id: "08ead55e619da352606d925fb154faa3eb678a3d",
        message: "Duplication code",
        links: [],
        object: {
          codefragment: ["public class Main {\n" +
          "  public static void main(String[] args) {\n" +
          "    int day = 4;\n" +
          "    switch (day) {\n" +
          "      case 1:\n" +
          "        System.out.println(\"Monday\");\n" +
          "        break;\n" +
          "      case 2:\n" +
          "        System.out.println(\"Tuesday\");\n" +
          "        break;\n" +
          "      case 3:\n" +
          "        System.out.println(\"Wednesday\");\n" +
          "        break;\n" +
          "      case 4:\n" +
          "        System.out.println(\"Thursday\");\n" +
          "        break;\n" +
          "      case 5:\n" +
          "        System.out.println(\"Friday\");\n" +
          "        break;\n" +
          "      case 6:\n" +
          "        System.out.println(\"Saturday\");\n" +
          "        break;\n" +
          "      case 7:\n" +
          "        System.out.println(\"Sunday\");\n" +
          "        break;\n" +
          "    }\n" +
          "  }\n" +
          "}"]
        },
        git_blame_info: nil
      },
      {
        path: "app.java",
        location: {
          start_line: 31,
          start_column: 1,
          end_line: 58,
          end_column: 1
        },
        id: "08ead55e619da352606d925fb154faa3eb678a3d",
        message: "Duplication code",
        links: [],
        object: {
          codefragment: ["public class Main {\n" +
          "  public static void main(String[] args) {\n" +
          "    int day = 4;\n" +
          "    switch (day) {\n" +
          "      case 1:\n" +
          "        System.out.println(\"Monday\");\n" +
          "        break;\n" +
          "      case 2:\n" +
          "        System.out.println(\"Tuesday\");\n" +
          "        break;\n" +
          "      case 3:\n" +
          "        System.out.println(\"Wednesday\");\n" +
          "        break;\n" +
          "      case 4:\n" +
          "        System.out.println(\"Thursday\");\n" +
          "        break;\n" +
          "      case 5:\n" +
          "        System.out.println(\"Friday\");\n" +
          "        break;\n" +
          "      case 6:\n" +
          "        System.out.println(\"Saturday\");\n" +
          "        break;\n" +
          "      case 7:\n" +
          "        System.out.println(\"Sunday\");\n" +
          "        break;\n" +
          "    }\n" +
          "  }\n" +
          "}"]
        },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "PMD_CPD", version: "6.21.0" }
  }
)


Smoke.add_test(
  "broken_sideci_yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message:
    "The attribute `$.linter.pmd_cpd.files_path` in your `sideci.yml` is unsupported. Please fix and retry.",
    analyzer: nil
  }
)

Smoke.add_test(
  "option_files",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "src/app.java",
        location: {
          start_line: 1,
          start_column: 1,
          end_line: 28,
          end_column: 1
        },
        id: "a0d07ccc71c5882677ebf837cc1b0fbe9a653bb3",
        message: "Duplication code",
        links: [],
        object: {codefragment: ["public class Main {\n" +
          "  public static void main(String[] args) {\n" +
          "    int day = 4;\n" +
          "    switch (day) {\n" +
          "      case 1:\n" +
          "        System.out.println(\"Monday\");\n" +
          "        break;\n" +
          "      case 2:\n" +
          "        System.out.println(\"Tuesday\");\n" +
          "        break;\n" +
          "      case 3:\n" +
          "        System.out.println(\"Wednesday\");\n" +
          "        break;\n" +
          "      case 4:\n" +
          "        System.out.println(\"Thursday\");\n" +
          "        break;\n" +
          "      case 5:\n" +
          "        System.out.println(\"Friday\");\n" +
          "        break;\n" +
          "      case 6:\n" +
          "        System.out.println(\"Saturday\");\n" +
          "        break;\n" +
          "      case 7:\n" +
          "        System.out.println(\"Sunday\");\n" +
          "        break;\n" +
          "    }\n" +
          "  }\n" +
          "}"]},
        git_blame_info: nil
      },
    {
      path: "src/app.java",
      location: {
        start_line: 31,
        start_column: 1, end_line: 58, end_column: 1},
      id: "a0d07ccc71c5882677ebf837cc1b0fbe9a653bb3",
      message: "Duplication code",
      links: [],
      object:
      {codefragment:
        ["public class Main {\n" +
          "  public static void main(String[] args) {\n" +
          "    int day = 4;\n" +
          "    switch (day) {\n" +
          "      case 1:\n" +
          "        System.out.println(\"Monday\");\n" +
          "        break;\n" +
          "      case 2:\n" +
          "        System.out.println(\"Tuesday\");\n" +
          "        break;\n" +
          "      case 3:\n" +
          "        System.out.println(\"Wednesday\");\n" +
          "        break;\n" +
          "      case 4:\n" +
          "        System.out.println(\"Thursday\");\n" +
          "        break;\n" +
          "      case 5:\n" +
          "        System.out.println(\"Friday\");\n" +
          "        break;\n" +
          "      case 6:\n" +
          "        System.out.println(\"Saturday\");\n" +
          "        break;\n" +
          "      case 7:\n" +
          "        System.out.println(\"Sunday\");\n" +
          "        break;\n" +
          "    }\n" +
          "  }\n" +
          "}"]},
      git_blame_info: nil}],
  analyzer: {name: "PMD_CPD", version: "6.21.0"}}
)

Smoke.add_test(
  "option_language_ruby",
  {
    guid: "test-guid",
    timestamp:  :_,
    type: "success",
    issues: 
    [
      {
        path: "app.rb",
        location: {start_line: 1, end_line: 14},
        id: "87db478b31e1688ba1747bce0b9ac7ec5e447af1",
        message: "Duplication code",
        links: [],
        object: {
          codefragment: 
          ["def show_status_tank capacity\n" +
          "  case capacity\n" +
          "  when 0\n" +
          "    \"You ran out of gas.\"\n" +
          "  when 1..20\n" +
          "    \"The tank is almost empty. Quickly, find a gas station!\"\n" +
          "  when 21..70\n" +
          "    \"You should be ok for now.\"\n" +
          "  when 71..100\n" +
          "    \"The tank is almost full.\"\n" +
          "  else\n" +
          "    \"Error: capacity has an invalid value (\#{capacity})\"\n" +
          "  end\n" +
          "end"]},
      git_blame_info: nil},
      {path: "app.rb",
      location: {start_line: 16, end_line: 29},
      id: "87db478b31e1688ba1747bce0b9ac7ec5e447af1",
      message: "Duplication code",
      links: [],
      object: {
        codefragment: 
          ["def show_status_tank capacity\n" +
          "  case capacity\n" +
          "  when 0\n" +
          "    \"You ran out of gas.\"\n" +
          "  when 1..20\n" +
          "    \"The tank is almost empty. Quickly, find a gas station!\"\n" +
          "  when 21..70\n" +
          "    \"You should be ok for now.\"\n" +
          "  when 71..100\n" +
          "    \"The tank is almost full.\"\n" +
          "  else\n" +
          "    \"Error: capacity has an invalid value (\#{capacity})\"\n" +
          "  end\n" +
          "end"]
          },
      git_blame_info: nil}],
  analyzer: {name: "PMD_CPD", version: "6.21.0"}}

)
