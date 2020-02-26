package main

import (
    "fmt"
    "errors"
)

var unused int

func main() {
	awesomeText := "Hello World!"
	fmt.Printf("text", awesomeText)
	validate(1)
}

func validate(num int) error {
    if num < 0 {
        return errors.New("error")
    }
    fmt.Println("ok")
    return nil
}
