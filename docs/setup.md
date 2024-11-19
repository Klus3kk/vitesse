# **How to Enable and Run the ALU Simulation**

This guide explains how to compile, simulate, and visualize the **Vitesse ALU** program using **GHDL** and **GTKWave**.

## **Step 1: Directory Setup**

Ensure the following directory structure is in place:
```
Vitesse/
├── src/         # VHDL source files (e.g., alu.vhdl)
├── testbench/   # Testbench files (e.g., alu_test.vhdl)
├── build/       # Compiled outputs and waveform files
├── docs/        # Documentation files
```

Place the **ALU** source file (`alu.vhdl`) in the `src` directory and the testbench file (`alu_test.vhdl`) in the `testbench` directory.

## **Step 2: Compile the Code**

Navigate to the project directory and run the following commands:

1. **Analyze the Source Files**:

   ```bash
   ghdl -a src/alu.vhdl testbench/alu_test.vhdl
   ```
   This compiles the source (`alu.vhdl`) and the testbench (`alu_test.vhdl`).

2. **Elaborate the Testbench**:

   ```bash
   ghdl -e alu_test
   ```
   This creates an executable for the testbench.

## **Step 3: Run the Simulation**

To simulate the ALU and generate a waveform file:
```bash
ghdl -r alu_test --vcd=build/alu_test.vcd
```
- The `--vcd` flag generates a `alu_test.vcd` file in the `build` directory. This file contains the signal transitions for visualization.

## **Step 4: Visualize the Results**

Open the waveform file (`alu_test.vcd`) in GTKWave to analyze the ALU operations:

1. Launch GTKWave:

   ```bash
   gtkwave build/alu_test.vcd
   ```

2. In GTKWave:

   - Drag and drop signals (`A`, `B`, `Op`, `Result`, `Zero`) from the left panel to the waveform view.
   - Zoom in and out to inspect signal transitions at each time interval.

## **Step 5: Verify Signal Changes**

In GTKWave, verify the following:
- **`A` and `B`**: Input operands for the ALU.
- **`Op`**: Operation selector (`ADD`, `SUB`, `NOT`, etc.).
- **`Result`**: Output of the operation.
- **`Zero`**: Flag indicating if the result is zero.


## **Troubleshooting**

1. If the signals are static:

   - Ensure you’ve added proper `wait for X ns;` delays in your testbench.
   - Confirm the `alu_test.vcd` file is generated successfully in the `build` directory.

2. Recompile and rerun:

   ```bash
   ghdl -a src/alu.vhdl testbench/alu_test.vhdl
   ghdl -e alu_test
   ghdl -r alu_test --vcd=build/alu_test.vcd
   ```
