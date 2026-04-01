package main

import "fmt"

func main() {
	fmt.Println("work!")
	fmt.Println("test")
	logger := pkg.MainLogger
	logger.Info("Logger initialized", "aaa", "bbb", "ccc")
}
