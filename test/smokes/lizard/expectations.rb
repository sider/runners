s = Runners::Testing::Smoke

default_version = "1.17.7"

s.add_test(
  "success",
  type: "success",
  issues: [],
  analyzer: { name: "Pylint", version: default_version }
)

# $ lizard -t 2 -V -o results.csv .
# $ cat results.csv
# NLOC,CCN,token,PARAM,length,location,file,function,long_name,start,end
# 3,1,10,0,4,"hello_world@1-4@./src/foo/bar/hello.swift","./src/foo/bar/hello.swift","hello_world","hello_world",1,4
# 5,1,15,0,6,"hello_world@3-8@./src/foo/bar/hello.m","./src/foo/bar/hello.m","hello_world","hello_world()",3,8
# 4,1,21,1,4,"main@10-13@./src/foo/bar/hello.m","./src/foo/bar/hello.m","main","main( int argc , const char * argv [ ])",10,13
# 3,1,11,0,4,"hello_world@1-4@./src/foo/hello.js","./src/foo/hello.js","hello_world","hello_world ( )",1,4
# 5,1,13,1,5,"main@6-10@./src/foo/hello.cpp","./src/foo/hello.cpp","main","main( void)",6,10
# 4,1,13,0,5,"print_hello_world@12-16@./src/foo/hello.cpp","./src/foo/hello.cpp","print_hello_world","print_hello_world()",12,16
# 5,1,13,1,5,"main@6-10@./src/foo/hello.c","./src/foo/hello.c","main","main( void)",6,10
# 4,1,10,0,5,"print_hello_world@12-16@./src/foo/hello.c","./src/foo/hello.c","print_hello_world","print_hello_world()",12,16
# 3,1,13,0,3,"HelloWorld::main@2-4@./src/foo/hello.java","./src/foo/hello.java","HelloWorld::main","HelloWorld::main( String args [ ])",2,4
# 3,1,14,0,4,"HelloWorld::printHelloWorld@6-9@./src/foo/hello.java","./src/foo/hello.java","HelloWorld::printHelloWorld","HelloWorld::printHelloWorld()",6,9
# 4,1,9,0,4,"HelloWorld::Main@4-7@./src/foo/hello.cs","./src/foo/hello.cs","HelloWorld::Main","HelloWorld::Main()",4,7
# 4,1,14,0,5,"HelloWorld::PrintHelloWorld@9-13@./src/foo/hello.cs","./src/foo/hello.cs","HelloWorld::PrintHelloWorld","HelloWorld::PrintHelloWorld()",9,13
# 3,1,9,0,3,"main@5-7@./src/baz/qux/hello.go","./src/baz/qux/hello.go","main","main",5,7
# 3,1,12,0,4,"hello_world@9-12@./src/baz/qux/hello.go","./src/baz/qux/hello.go","hello_world","hello_world",9,12
# 3,1,10,0,3,"main@2-4@./src/baz/qux/hello.rs","./src/baz/qux/hello.rs","main","main",2,4
# 3,1,12,0,4,"print_hello@6-9@./src/baz/qux/hello.rs","./src/baz/qux/hello.rs","print_hello","print_hello",6,9
# 3,1,6,0,4,"hello_world@2-5@./src/baz/qux/hello.lua","./src/baz/qux/hello.lua","hello_world","hello_world )",2,5
# 4,1,7,0,5,"hello_world@2-6@./src/baz/hello.php","./src/baz/hello.php","hello_world","hello_world ( )",2,6
# 3,1,10,0,4,"hello_world@2-5@./src/baz/hello.scala","./src/baz/hello.scala","hello_world","hello_world",2,5
# 3,1,4,0,4,"hello_world@1-4@./src/baz/hello.rb","./src/baz/hello.rb","hello_world","hello_world",1,4
# 5,1,13,1,5,"main@7-11@./example.c","./example.c","main","main( void)",7,11
# 4,1,10,0,4,"print_hello_world@13-16@./example.c","./example.c","print_hello_world","print_hello_world()",13,16
# 2,1,8,0,3,"hello_world@1-3@./src/baz/hello.py","./src/baz/hello.py","hello_world","hello_world( )",1,3
