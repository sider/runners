package vendor

import (
	"errors"
	"fmt"
)

func Bad() {
	validate(1)
}

func validate(num int) error {
	if num < 0 {
		return errors.New("error")
	}
	fmt.Println("ok")
	return nil
}
