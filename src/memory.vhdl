-- LIBRARIES
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ENTITY DECLARATION
entity memory is
    Port (
        clk     : in  STD_LOGIC;
        address : in  STD_LOGIC_VECTOR(15 downto 0); -- Memory address
        write_enable : in  STD_LOGIC;
        write_data   : in  STD_LOGIC_VECTOR(15 downto 0);
        read_data    : out STD_LOGIC_VECTOR(15 downto 0) -- Instruction/Data output
    );
end memory;

-- ARCHITECTURE
architecture Behavioral of memory is
    type ram_type is array (0 to 255) of STD_LOGIC_VECTOR(15 downto 0); -- 256 words of 16-bit memory
    signal ram : ram_type := (others => (others => '0')); -- Initialize with zeroes
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if write_enable = '1' then
                ram(to_integer(unsigned(address))) <= write_data; -- Write to memory
            end if;
        end if;
    end process;

    read_data <= ram(to_integer(unsigned(address))); -- Read from memory
end Behavioral;
