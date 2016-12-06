package main

import (
  "fmt"
  "math"
  "os"
  "strings"
)

func move_elevator(input string) (int, int) {
  floor := 0
  basement_transition := math.MinInt8
  for idx, char := range strings.Split(input, "") {
    switch char {
    case "(":
      floor++
    case ")":
      floor--
      if floor < 0 && basement_transition == math.MinInt8 {
        basement_transition = idx + 1
      }
    }
  }
  return floor, basement_transition
}

func main() {
  if len(os.Args) < 2 {
    fmt.Println("No input given.")
    os.Exit(1)
  }

  input := os.Args[1]
  final_floor, basement_transition := move_elevator(input)
  fmt.Printf("Final Floor: %d, moved to basement on %d\n", final_floor, basement_transition)
}
