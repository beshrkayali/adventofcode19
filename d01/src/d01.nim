# Advent of Code 2019
# Day 1: The Tyranny of the Rocket Equation

import strutils, sequtils
import math

type
  Module = object
    mass: int
    fuel: int

proc fuelForMass(mass: int): int =
  var fuel = int floor(mass / 3) - 2

  if fuel > 0:
    fuel += fuelForMass(fuel)
    return fuel
  return 0

proc newModule(mass: int): Module =
  let fuel = fuelForMass mass

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
