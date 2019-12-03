# Advent of Code 2019
# Day 2: 1202 Program Alarm

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

proc newCPU(rom: seq[Instruction]): CPU =
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
    of 1:
      cpu.rom[operands[2]] = cpu.rom[operands[0]] + cpu.rom[operands[1]]
    of 2:
      cpu.rom[operands[2]] = cpu.rom[operands[0]] * cpu.rom[operands[1]]
    of 99:
      discard
    else:
      echo("Unknown: ", instruction)

proc process(cpu: CPU) =
  while cpu.state == CPUState.on:
     let (inst, operands) = read cpu
     cpu.exec(inst, operands)

proc readCode(): seq[Instruction]  =
  return readFile("intcode.txt").split(",")
  .map(proc (line: string): int =
    try: parseInt line
    except: -1)
  .filter(proc (instruction: int): bool = instruction > -1)
  .map(proc (code: int): Instruction = code)
     
when isMainModule:
  var code = readCode()

  for n in 0 .. 99:    
    code[1] = n
    for v in 0 .. 99:
      code[2] = v

      let cpu = newCPU(code)
      cpu.turnOn()
      cpu.process()
      if cpu.rom[0] == 19690720:
        echo("Noun: ", n)
        echo("Verb: ", v)
