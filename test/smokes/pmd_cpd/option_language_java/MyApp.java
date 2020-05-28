public class MyApp {
  @SuppressWarnings("deprecation")
  public static void main(String[] args) {
    String str;
    int day = 5;
    switch (day) {
      case 1:
        str = "Monday";
        break;
      case 2:
        str = "Tuesday";
        break;
      case 3:
        str = "Wednesday";
        break;
      case 4:
        str = "Thursday";
        break;
      case 5:
        str = "Friday";
        break;
      case 6:
        str = "Saturday";
        break;
      case 7:
        str = "Sunday";
        break;
      default:
        str = null;
        break;
    }

    System.out.println(str);
  }

  private static void Bar(String msg)
  {
    System.out.println(msg);
  }
}
