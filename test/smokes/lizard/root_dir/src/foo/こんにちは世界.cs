
class HelloWorld
{
  public static int ReturnInt()
  {
    if (true)
    {
      return 1;
    }

    return 2;
  }

  public static void Main()
  {
    int a = 1;
    if (a == 0)
    {
      PrintHelloWorld();
    }
  }

  public static void PrintHelloWorld()
  {
    int a = 1;
    int b = 2;

    for (int i = 0; i < 10; i++)
    {
      if (a == 3)
      {
        if (b == 4)
        {
          return;
        }
      }
    }

/* Hello world in C# */
    System.Console.WriteLine("Hello, World!");
  }
}

