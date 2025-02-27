-- LIBRARIES
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- TESTBENCH ENTITY
entity cpu_test is
end cpu_test;

-- ARCHITECTURE
architecture Behavioral of cpu_test is
    -- COMPONENT UNDER TEST
    component cpu
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        -- Debug ports
        debug_pc   : out STD_LOGIC_VECTOR(15 downto 0); -- Program Counter
        debug_inst : out STD_LOGIC_VECTOR(15 downto 0); -- Instruction Register
        debug_reg1 : out STD_LOGIC_VECTOR(15 downto 0);
        debug_reg2 : out STD_LOGIC_VECTOR(15 downto 0);
        debug_reg3 : out STD_LOGIC_VECTOR(15 downto 0)
    );
    end component;

    component memory
    Port (
        clk          : in  STD_LOGIC;
        address      : in  STD_LOGIC_VECTOR(15 downto 0);
        write_enable : in  STD_LOGIC;
        write_data   : in  STD_LOGIC_VECTOR(15 downto 0);
        read_data    : out STD_LOGIC_VECTOR(15 downto 0)
    );
    end component;
    
    -- SIGNALS
    signal clk, rst : STD_LOGIC := '0';
    signal debug_pc, debug_inst : STD_LOGIC_VECTOR(15 downto 0);
    signal debug_reg1, debug_reg2, debug_reg3 : STD_LOGIC_VECTOR(15 downto 0);
    signal mem_address, mem_data : STD_LOGIC_VECTOR(15 downto 0);
    signal mem_write_enable : STD_LOGIC := '0';

begin
    -- INSTANTIATE THE CPU
    uut: cpu
    port map (
        clk        => clk,
        rst        => rst,
        debug_pc   => debug_pc,
        debug_inst => debug_inst,
        debug_reg1 => debug_reg1,
        debug_reg2 => debug_reg2,
        debug_reg3 => debug_reg3
    );

    -- INSTANTIATE MEMORY (For instruction loading)
    mem_unit: memory
    port map (
        clk          => clk,
        address      => mem_address,
        write_enable => mem_write_enable,
        write_data   => mem_data,
        read_data    => open
    );

    -- CLOCK PROCESS
    process
    begin
        while now < 500 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- TEST CASES
    process
    begin
        -- RESET CPU
        rst <= '1';
        wait for 10 ns;
        rst <= '0';

        report "---------------------------";
        report "TEST START: CPU EXECUTION";
        report "---------------------------";

        -- LOAD INSTRUCTIONS INTO MEMORY
        mem_write_enable <= '1';
        
        -- Instruction 1: LOAD R1, #10
        mem_address <= "0000000000000000"; -- Memory address 0
        mem_data <= "0000000100001010"; -- Opcode for LOAD R1, 10
        wait for 10 ns;

        -- Instruction 2: LOAD R2, #5
        mem_address <= "0000000000000001"; -- Memory address 1
        mem_data <= "0000001000000101"; -- Opcode for LOAD R2, 5
        wait for 10 ns;

        -- Instruction 3: ADD R3, R1, R2 (R3 = R1 + R2)
        mem_address <= "0000000000000010"; -- Memory address 2
        mem_data <= "0001001100000000"; -- Opcode for ADD R3 = R1 + R2
        wait for 10 ns;

        -- Instruction 4: STORE R3 to Memory[5]
        mem_address <= "0000000000000011"; -- Memory address 3
        mem_data <= "0010001100000101"; -- Opcode for STORE R3 -> Mem[5]
        wait for 10 ns;

        mem_write_enable <= '0'; -- Disable writing

        -- LET THE CPU EXECUTE
        wait for 200 ns;

        -- DEBUG OUTPUTS TO VERIFY EXECUTION
        report "Final Register Values:";
        report "Register 1: " & integer'image(to_integer(unsigned(debug_reg1)));
        report "Register 2: " & integer'image(to_integer(unsigned(debug_reg2)));
        report "Register 3: " & integer'image(to_integer(unsigned(debug_reg3)));

        -- CHECK PC VALUE (SHOULD INCREMENT CORRECTLY)
        report "Final PC: " & integer'image(to_integer(unsigned(debug_pc)));

        -- CHECK INSTRUCTION EXECUTION
        report "Last Executed Instruction: " & integer'image(to_integer(unsigned(debug_inst)));

        report "---------------------------";
        report "TEST COMPLETE";
        report "---------------------------";
        wait;
    end process;
end Behavioral;
