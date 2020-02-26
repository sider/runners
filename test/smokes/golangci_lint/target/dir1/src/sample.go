package dir1

import (
	"errors"
	"fmt"
)

func AnotherBad() {
	another(1)
}

func another(num int) error {
	if num < 0 {
		return errors.New("error")
	}
	fmt.Println("ok")
	return nil
}
