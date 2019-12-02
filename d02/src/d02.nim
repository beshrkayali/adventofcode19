# Advent of Code 2019
# Day 2:

import strutils, sequtils

const instructionLength: int = 4

type
  Instruction = int

type
  CPUState = enum
    on, off

type CPU = ref object
  state: CPUState
  rom: seq[Instruction]
  pc: int

proc newCPU(intcode: string): CPU =
  let rom = intcode.split(",")
  .map(proc (line: string): int =
    try: parseInt line
    except: -1)
  .filter(proc (instruction: int): bool = instruction > -1)
  .map(proc (code: int): Instruction = code)

  CPU(rom: rom, state: CPUState.off, pc: 0)

proc turnOn(cpu: CPU) =
  cpu.state = CPUState.on

proc read(cpu: CPU): (Instruction, seq[Instruction]) =
  let inst = cpu.rom[cpu.pc]
  let operands = cpu.rom[cpu.pc + 1 .. cpu.pc + instructionLength - 1] 
  cpu.pc += instructionLength
  if int(cpu.pc + instructionLength - 1) > len(cpu.rom):
    cpu.state = CPUState.off
  return (inst, operands)

proc exec(cpu: CPU, instruction: Instruction, operands: seq[Instruction]) =
  case instruction:
    # Adding
    of 1:
      echo("Add: ", operands,  " / ", cpu.rom[operands[0]], " + ", cpu.rom[operands[1]] , " - Before: ", cpu.rom[operands[2]])
      cpu.rom[operands[2]] = cpu.rom[operands[0]] + cpu.rom[operands[1]]
      echo("After: ", cpu.rom[operands[2]])
    of 2:
      echo("Multiply: ", operands,  " / ", cpu.rom[operands[0]], " * ", cpu.rom[operands[1]] , " - Before: ", cpu.rom[operands[2]])
      cpu.rom[operands[2]] = cpu.rom[operands[0]] * cpu.rom[operands[1]]
      echo("After: ", cpu.rom[operands[2]])
    of 99:
      echo("Done")
    else:
      echo("Unknown: ", instruction)

proc process(cpu: CPU) =
  while cpu.state == CPUState.on:
     let (inst, operands) = read cpu
     cpu.exec(inst, operands)

when isMainModule:
  let cpu = newCPU(readFile("intcode.txt"))
  cpu.turnOn()
  cpu.process()
  echo(cpu.rom[0])
