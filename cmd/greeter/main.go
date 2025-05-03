// Package main is our application's entrypoint
package main

import (
	"context"
	"fmt"
	"os"
	"os/signal"
)

func run(
	ctx context.Context,
) error {
	_, cancel := signal.NotifyContext(ctx, os.Interrupt)
	defer cancel()

	fmt.Println("Hello, World!")

	return nil
}

func main() {
	ctx := context.Background()

	if err := run(ctx); err != nil {
		fmt.Fprintf(os.Stderr, "%s\n", err)
		os.Exit(1)
	}
}
