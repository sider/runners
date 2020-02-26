package main

import (
	"errors"
	"fmt"
)

var unused int

func main() {
	awesome_text := "Hello World!"
	fmt.Printf("text", awesome_text)
	validate(1)
}

func validate(num int) error {
	if num < 0 {
		return errors.New("error")
	}
	fmt.Println("ok")
	return nil
}
