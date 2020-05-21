s = Runners::Testing::Smoke

s.add_test(
  "success",
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
        codefragment: [%[public class Main {
  public static void main(String[] args) {
    int day = 4;
    switch (day) {
      case 1:
        System.out.println("Monday");
        break;
      case 2:
        System.out.println("Tuesday");
        break;
      case 3:
        System.out.println("Wednesday");
        break;
      case 4:
        System.out.println("Thursday");
        break;
      case 5:
        System.out.println("Friday");
        break;
      case 6:
        System.out.println("Saturday");
        break;
      case 7:
        System.out.println("Sunday");
        break;
    }
  }
}]]
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
        codefragment: [%[public class Main {
  public static void main(String[] args) {
    int day = 4;
    switch (day) {
      case 1:
        System.out.println("Monday");
        break;
      case 2:
        System.out.println("Tuesday");
        break;
      case 3:
        System.out.println("Wednesday");
        break;
      case 4:
        System.out.println("Thursday");
        break;
      case 5:
        System.out.println("Friday");
        break;
      case 6:
        System.out.println("Saturday");
        break;
      case 7:
        System.out.println("Sunday");
        break;
    }
  }
}]]
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "PMD_CPD", version: "6.21.0" }
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message: "The attribute `$.linter.pmd_cpd.files_path` in your `sideci.yml` is unsupported. Please fix and retry.",
  analyzer: nil
)

s.add_test(
  "option_files",
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
      object: {
        codefragment: [%[public class Main {
  public static void main(String[] args) {
    int day = 4;
    switch (day) {
      case 1:
        System.out.println("Monday");
        break;
      case 2:
        System.out.println("Tuesday");
        break;
      case 3:
        System.out.println("Wednesday");
        break;
      case 4:
        System.out.println("Thursday");
        break;
      case 5:
        System.out.println("Friday");
        break;
      case 6:
        System.out.println("Saturday");
        break;
      case 7:
        System.out.println("Sunday");
        break;
    }
  }
}]]
      },
      git_blame_info: nil
    },
    {
      path: "src/app.java",
      location: {
        start_line: 31,
        start_column: 1,
        end_line: 58,
        end_column: 1
      },
      id: "a0d07ccc71c5882677ebf837cc1b0fbe9a653bb3",
      message: "Duplication code",
      links: [],
      object: {
        codefragment: [%[public class Main {
  public static void main(String[] args) {
    int day = 4;
    switch (day) {
      case 1:
        System.out.println("Monday");
        break;
      case 2:
        System.out.println("Tuesday");
        break;
      case 3:
        System.out.println("Wednesday");
        break;
      case 4:
        System.out.println("Thursday");
        break;
      case 5:
        System.out.println("Friday");
        break;
      case 6:
        System.out.println("Saturday");
        break;
      case 7:
        System.out.println("Sunday");
        break;
    }
  }
}]]
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "PMD_CPD", version: "6.21.0" }
)

s.add_test(
  "option_language_ruby",
  type: "success",
  issues: [
    {
      path: "app.rb",
      location: {
        start_line: 1,
        end_line: 14
      },
      id: "87db478b31e1688ba1747bce0b9ac7ec5e447af1",
      message: "Duplication code",
      links: [],
      object: {
        codefragment: [%[def show_status_tank capacity
  case capacity
  when 0
    "You ran out of gas."
  when 1..20
    "The tank is almost empty. Quickly, find a gas station!"
  when 21..70
    "You should be ok for now."
  when 71..100
    "The tank is almost full."
  else
    "Error: capacity has an invalid value (\#{capacity})"
  end
end]]
      },
      git_blame_info: nil
    },
    {
      path: "app.rb",
      location: {
        start_line: 16,
        end_line: 29
      },
      id: "87db478b31e1688ba1747bce0b9ac7ec5e447af1",
      message: "Duplication code",
      links: [],
      object: {
        codefragment: [%[def show_status_tank capacity
  case capacity
  when 0
    "You ran out of gas."
  when 1..20
    "The tank is almost empty. Quickly, find a gas station!"
  when 21..70
    "You should be ok for now."
  when 71..100
    "The tank is almost full."
  else
    "Error: capacity has an invalid value (\#{capacity})"
  end
end]]
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "PMD_CPD", version: "6.21.0" }
)
