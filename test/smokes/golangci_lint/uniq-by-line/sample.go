package main

import (
	"crypto/sha1"
	"fmt"
)

func main() {
	x := true
	if x == true {
	}
	redundant_append()
	h := sha1.New()
	fmt.Printf("% x", h.Sum(nil))
}

//This is a comment
func redundant_append() []int {
	var xs []int
	xs = append(xs, 1)
	xs = append(xs, 2)
	return xs
}
