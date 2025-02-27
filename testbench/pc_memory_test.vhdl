-- LIBRARIES
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- TESTBENCH ENTITY
entity pc_memory_test is
end pc_memory_test;

-- ARCHITECTURE
architecture Behavioral of pc_memory_test is
    -- COMPONENTS
    component cpu
        Port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            debug_pc : out STD_LOGIC_VECTOR(15 downto 0);
            debug_inst : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    -- SIGNALS
    signal clk, rst : STD_LOGIC := '0';
    signal debug_pc, debug_inst : STD_LOGIC_VECTOR(15 downto 0);
begin
    -- INSTANTIATE CPU
    uut: cpu
        port map (
            clk      => clk,
            rst      => rst,
            debug_pc => debug_pc,
            debug_inst => debug_inst
        );

    -- CLOCK PROCESS
    process
    begin
        while now < 100 ns loop
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
        -- RESET SYSTEM
        rst <= '1';
        wait for 10 ns;
        rst <= '0';

        -- Let the PC increment
        wait for 50 ns;

        report "Test complete!";
        wait;
    end process;
end Behavioral;
