package main

import (
	"context"
	"fmt"
	"io"
	"os"
	"os/signal"
)

func run(
	ctx context.Context,
	args []string,
	stdout io.Writer,
) error {
	ctx, cancel := signal.NotifyContext(ctx, os.Interrupt)
	defer cancel()

	var name string

	if len(args) > 1 {
		name = args[1]
	}

	if name == "" {
		return fmt.Errorf("name must not be empty")
	}

	fmt.Fprintf(stdout, "Hello, %s!", name)
	return nil
}

func main() {
	ctx := context.Background()

	if err := run(ctx, os.Args, os.Stdout); err != nil {
		fmt.Fprintf(os.Stderr, "%s\n", err)
		os.Exit(1)
	}
}
