#
# FizzBuzz in Python
#

def do_nothing(dummy):
	pass

def do_fizz_Buzz(n, dummy1, dummy2):
# FizzBuzz in Python
  for i in range(n):
    divBy3 = i % 3 == 0
    divBy5 = i % 5 == 0

# print FizzBuzz
    if divBy3 and divBy5:
        print("FizzBuzz")
    elif divBy3:
        print("Fizz")
    elif divBy5:
        print("Buzz")
    else:
        print(i)

  do_nothing(dummy1)
  print("End")

if __name__ == '__main__':
  do_fizz_Buzz(100, None, None)
