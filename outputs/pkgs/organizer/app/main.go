package main

import (
	"io/fs"
	"path/filepath"
)

func walk(s string, d fs.DirEntry, err error) error {
	if err != nil {
		return err
	}
	if !d.IsDir() {
		println(s)
	}
	return nil
}

func test(p string, info fs.FileInfo, err error) error {
	if err != nil {
		return err
	}

	if !info.IsDir() {
		println(p)
	}

	return nil
}

func main() {
	filepath.Walk("/home/tar/mini", test)
}
