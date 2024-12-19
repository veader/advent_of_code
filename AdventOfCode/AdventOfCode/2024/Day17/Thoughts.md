## Day 17: Part 2

What value of the `A` register has to be set to get the output to match the original 
instruction set.

Instructions: `2,4,1,1,7,5,1,5,0,3,4,3,5,5,3,0`

We know then that we have to make the program loop `16` times to output all values.


### Instruction Breakdown

1. `2,4` - **BST**
    * `combo(4) % 8 => B` -> `A % 8 => B`
    * Creating a 3 bit number `0...7` based on value of `A`
    * `B` is in `0...7`
    * Updates `B
2. `1,1` - **BXL**
    * `B XOR 1 => B`
    * Even numbers +1, Odd number -1 for values of `B`
    * Updates `B`
3. `7,5` - **CDV**
    * `A / 2^combo(5) => C` -> `A / 2^B => C`
    * Value cast to `int`
    * Updates `C`
4. `1,5` - **BXL**
    * `B XOR 5 => B`
    * `B` is still in `0...7`
    * Updates `B`
5. `0,3` - **ADV**
    * `A / 2^combo(3) => A` -> `A / 2^3 => A` -> `A / 8 => A`
    * Value cast to `int`
    * Updates `A`
    * This step determines how many loops we make...
6. `4,3` - **BXC**
    * `B XOR C => B`
    * Updates `B`
7. `5,5` - **OUT**
    * `combo(5) % 8` -> `B % 8`
    * Print out `B` as a 3 bit number `0...7`
8. `3,0` - **JNZ**
    * If `A != 0`, jump to step 1.
    * We should hit this 15 times based on step 5
    * Otherwise _HALT_
    
