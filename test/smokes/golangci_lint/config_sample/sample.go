package main

import (
	"fmt"
	"time"
)

type Person struct {
	age      int
	name     string
	birthDay time.Time
}

func main() {
	var p Person
	p.age = 28
	p.name = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0"
	fmt.Println("name:%\n", p.name)
}
