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
        report "---------------------------";
        report "TEST START: CPU EXECUTION";
        report "---------------------------";

        -- RESET CPU
        rst <= '1';
        wait for 10 ns;
        rst <= '0';

        -- Load Instructions into Memory
        mem_write_enable <= '1';

        report "Loading Instructions into Memory...";
        
        mem_address <= "0000000000000000"; mem_data <= "0000000100001010"; wait for 10 ns; -- LOAD R1, #10
        mem_address <= "0000000000000001"; mem_data <= "0000001000000101"; wait for 10 ns; -- LOAD R2, #5
        mem_address <= "0000000000000010"; mem_data <= "0001001100000000"; wait for 10 ns; -- ADD R3 = R1 + R2
        mem_address <= "0000000000000011"; mem_data <= "0010001100000101"; wait for 10 ns; -- STORE R3 -> Mem[5]

        mem_write_enable <= '0';

        report "Instructions Loaded. Starting Execution.";

        -- LET THE CPU EXECUTE
        for i in 0 to 10 loop
            wait until rising_edge(clk);
            report "Cycle " & integer'image(i);
            report "PC: " & integer'image(to_integer(unsigned(debug_pc)));
            report "INST: " & integer'image(to_integer(unsigned(debug_inst)));
            report "Register 1: " & integer'image(to_integer(unsigned(debug_reg1)));
            report "Register 2: " & integer'image(to_integer(unsigned(debug_reg2)));
            report "Register 3: " & integer'image(to_integer(unsigned(debug_reg3)));
        end loop;

        report "---------------------------";
        report "TEST COMPLETE";
        report "---------------------------";
        wait;
    end process;

end Behavioral;
