# Vitesse
This project implements a basic 16-bit RISC (Reduced Instruction Set Computer) processor named **Vitesse** using VHDL (VHSIC Hardware Description Language). Designed for simplicity and educational purposes, this processor executes essential arithmetic and logical operations.
## Features:
* 16-bit ALU (Arithmetic Logic Unit): Performs basic arithmetic operations (addition, subtraction) and logical operations (AND, OR, NOT).
* Simple Instruction Set Architecture (ISA): Comprises a minimal set of instructions focusing on arithmetic, logic, and data movement.
* Register File: Contains a small set of general-purpose registers (e.g., 8 registers).
* Program Counter (PC): Maintains the address of the next instruction to be executed.
* Control Unit: Decodes instructions and generates control signals for the processor's components.
* Memory Interface: Interfaces with a basic RAM model for instruction and data storage.
* Single-Cycle Execution: Executes one instruction per clock cycle for simplicity.
## Technologies: 
* VHDL: Primary language used for describing the processor's hardware.
* GHDL: An open-source VHDL simulator for running and testing the processor.

**Status: In progress.**
