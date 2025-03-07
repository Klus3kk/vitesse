-- LIBRARIES
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- TESTBENCH ENTITY (Ensure this matches the GHDL command)
entity register_test is
end register_test;

-- ARCHITECTURE (Testbench behavior)
architecture Behavioral of register_test is
    -- COMPONENT UNDER TEST
    component register_file
        Port (
            clk         : in  STD_LOGIC;
            rst         : in  STD_LOGIC;
            read_reg1   : in  STD_LOGIC_VECTOR(2 downto 0);
            read_reg2   : in  STD_LOGIC_VECTOR(2 downto 0);
            write_reg   : in  STD_LOGIC_VECTOR(2 downto 0);
            write_data  : in  STD_LOGIC_VECTOR(15 downto 0);
            reg_write   : in  STD_LOGIC;
            read_data1  : out STD_LOGIC_VECTOR(15 downto 0);
            read_data2  : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    -- SIGNALS
    signal clk, rst, reg_write : STD_LOGIC := '0';
    signal read_reg1, read_reg2, write_reg : STD_LOGIC_VECTOR(2 downto 0);
    signal write_data, read_data1, read_data2 : STD_LOGIC_VECTOR(15 downto 0);

begin
    -- INSTANTIATE THE REGISTER FILE
    uut: register_file
        port map (
            clk => clk,
            rst => rst,
            read_reg1 => read_reg1,
            read_reg2 => read_reg2,
            write_reg => write_reg,
            write_data => write_data,
            reg_write => reg_write,
            read_data1 => read_data1,
            read_data2 => read_data2
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
        -- RESET REGISTERS
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        
        -- WRITE 42 TO REGISTER 2
        write_reg <= "010"; -- Select register R2
        write_data <= "0000000000101010"; -- Decimal 42
        reg_write <= '1';
        wait until rising_edge(clk); -- Wait for clock edge
        reg_write <= '0';
        
        -- READ FROM REGISTER 2
        read_reg1 <= "010"; -- Read from R2
        wait for 5 ns; -- Allow time for read to complete
        assert (read_data1 = "0000000000101010") report "Read from R2 failed!" severity error;
        
        -- WRITE 99 TO REGISTER 4
        write_reg <= "100"; -- Select register R4
        write_data <= "0000000001100011"; -- Decimal 99
        reg_write <= '1';
        wait until rising_edge(clk); -- Wait for clock edge
        reg_write <= '0';
        
        -- READ FROM REGISTER 2 AND 4 SIMULTANEOUSLY
        read_reg1 <= "010"; -- Read from R2
        read_reg2 <= "100"; -- Read from R4
        wait for 5 ns; -- Allow time for read to complete
        assert (read_data1 = "0000000000101010") report "Read from R2 failed!" severity error;
        assert (read_data2 = "0000000001100011") report "Read from R4 failed!" severity error;
        
        -- TEST REGISTER 0 (SHOULD ALWAYS BE 0)
        read_reg1 <= "000"; -- Read from R0
        wait for 5 ns;
        assert (read_data1 = "0000000000000000") report "R0 is not zero!" severity error;
        
        -- TEST WRITE TO REGISTER 0 (SHOULD REMAIN 0)
        write_reg <= "000"; -- Select register R0
        write_data <= "1111111111111111"; -- Try to write all 1s
        reg_write <= '1';
        wait until rising_edge(clk);
        reg_write <= '0';
        read_reg1 <= "000"; -- Read from R0
        wait for 5 ns;
        assert (read_data1 = "0000000000000000") report "R0 was modified!" severity error;
        
        report "Register file test completed!";
        wait;
    end process;
end Behavioral;
