-- LIBRARIES
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Standard library for arithmetic operations

-- ENTITY DECLARATION (Register File)
entity register_file is
    Port (
        clk         : in  STD_LOGIC; -- Clock signal
        rst         : in  STD_LOGIC; -- Reset signal
        read_reg1   : in  STD_LOGIC_VECTOR(2 downto 0); -- Select register 1
        read_reg2   : in  STD_LOGIC_VECTOR(2 downto 0); -- Select register 2
        write_reg   : in  STD_LOGIC_VECTOR(2 downto 0); -- Select register to write
        write_data  : in  STD_LOGIC_VECTOR(15 downto 0); -- Data to write
        reg_write   : in  STD_LOGIC; -- Write enable
        read_data1  : out STD_LOGIC_VECTOR(15 downto 0); -- Output of register 1
        read_data2  : out STD_LOGIC_VECTOR(15 downto 0)  -- Output of register 2
    );
end register_file;

-- ARCHITECTURE (Behavior of the Register File)
architecture Behavioral of register_file is
    type reg_array is array (0 to 7) of STD_LOGIC_VECTOR(15 downto 0); -- 8 registers
    signal registers : reg_array := (others => (others => '0')); -- Initialize all to 0
begin
    -- REGISTER READING (ASYNC)
    read_data1 <= registers(to_integer(unsigned(read_reg1)));
    read_data2 <= registers(to_integer(unsigned(read_reg2)));

    -- REGISTER WRITING (SYNC with CLOCK)
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                registers <= (others => (others => '0')); -- Reset all registers
            elsif reg_write = '1' then
                registers(to_integer(unsigned(write_reg))) <= write_data;
            end if;
        end if;
    end process;
end Behavioral;
