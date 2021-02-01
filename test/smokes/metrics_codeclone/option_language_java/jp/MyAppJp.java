

public class MyAppJp {
  public static void main(String[] args) {
    String str;
    int day = 5;
    switch (day) {
      case 1:
        str = "月曜日";
        break;
      case 2:
        str = "火曜日";
        break;
      case 3:
        str = "水曜日";
        break;
      case 4:
        str = "木曜日";
        break;
      case 5:
        str = "金曜日";
        break;
      case 6:
        str = "土曜日";
        break;
      case 7:
        str = "日曜日";
        break;
      default:
        str = null;
        break;
    }

    System.out.println(str);
  }

  @Deprecated
  private static void Foo(String text)
  {
    System.out.println(text);
  }
}
