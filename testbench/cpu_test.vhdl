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
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        reg_write : in STD_LOGIC;
        opcode : in STD_LOGIC_VECTOR(2 downto 0);
        reg_src1 : in STD_LOGIC_VECTOR(2 downto 0);
        reg_src2 : in STD_LOGIC_VECTOR(2 downto 0);
        reg_dest : in STD_LOGIC_VECTOR(2 downto 0);
        -- Debug ports (would need to be added to CPU entity)
        debug_reg1 : out STD_LOGIC_VECTOR(15 downto 0);
        debug_reg2 : out STD_LOGIC_VECTOR(15 downto 0);
        debug_reg3 : out STD_LOGIC_VECTOR(15 downto 0)
    );
    end component;
    
    -- SIGNALS
    signal clk, rst, reg_write : STD_LOGIC := '0';
    signal opcode : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal reg_src1, reg_src2, reg_dest : STD_LOGIC_VECTOR(2 downto 0) := "000";
    
    -- Debug signals
    signal debug_reg1, debug_reg2, debug_reg3 : STD_LOGIC_VECTOR(15 downto 0);
begin
    -- INSTANTIATE THE CPU
    uut: cpu
    port map (
        clk => clk,
        rst => rst,
        reg_write => reg_write,
        opcode => opcode,
        reg_src1 => reg_src1,
        reg_src2 => reg_src2,
        reg_dest => reg_dest,
        debug_reg1 => debug_reg1,
        debug_reg2 => debug_reg2,
        debug_reg3 => debug_reg3
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
        -- RESET CPU
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        
        -- WRITE 10 TO R1
        reg_dest <= "001"; -- R1
        reg_src1 <= "000"; -- Unused
        reg_src2 <= "000"; -- Unused
        opcode <= "000"; -- ADD (using as a pass-through)
        reg_write <= '1';
        wait until rising_edge(clk);
        reg_write <= '0';
        
        -- WRITE 5 TO R2
        reg_dest <= "010"; -- R2
        reg_write <= '1';
        wait until rising_edge(clk);
        reg_write <= '0';
        
        -- ADD R1 + R2 (10 + 5)
        reg_src1 <= "001"; -- Read from R1
        reg_src2 <= "010"; -- Read from R2
        reg_dest <= "011"; -- Store in R3
        opcode <= "000"; -- ADD operation
        reg_write <= '1';
        wait until rising_edge(clk);
        reg_write <= '0';
        
        -- Allow time for result to propagate
        wait for 5 ns;
        
        -- Verify result (if debug ports are available)
        -- assert (debug_reg3 = "0000000000001111") report "ADD operation failed!" severity error;
        
        report "CPU test completed!";
        wait;
    end process;
end Behavioral;