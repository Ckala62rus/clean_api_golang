package main

import (
	"github.com/Ckala62rus/clean_api_golang.git/pkg"
)

func main() {
	logger := pkg.MainLogger
	logger.Info("Logger initialized", "aaa", "bbb", "ccc")

	cfg := pkg.MainConfig
	environment := cfg.Env
	logger.Debug("Environment", environment)
	logger.Debug("Environment", environment)
}
