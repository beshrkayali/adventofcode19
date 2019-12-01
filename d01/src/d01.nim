import strutils, sequtils
import math

type
  Module = object
    mass: int
    fuel: int
    
proc newModule(mass: int): Module =
  let fuel = int floor(mass / 3) - 2
  Module(mass: mass, fuel: fuel)

when isMainModule:
  const fuelCounterUpper = splitLines(readFile("input.txt"))
  .map(proc (line: string): int =
           try: parseInt line
           except: 0)
  .filter(proc (mass: int): bool = mass > 0)
  .map(proc (mass: int): Module = newModule(mass))
  .map(proc (module: Module): int = module.fuel)
  .foldr(a + b)

  echo(fuelCounterUpper)
