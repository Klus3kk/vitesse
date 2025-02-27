-- LIBRARIES
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ENTITY DECLARATION
entity memory is
    Port (
        clk          : in  STD_LOGIC;
        address      : in  STD_LOGIC_VECTOR(15 downto 0); -- Memory address
        write_enable : in  STD_LOGIC;
        write_data   : in  STD_LOGIC_VECTOR(15 downto 0);
        read_data    : out STD_LOGIC_VECTOR(15 downto 0) -- Instruction/Data output
    );
end memory;

-- ARCHITECTURE
architecture Behavioral of memory is
    type ram_type is array (0 to 255) of STD_LOGIC_VECTOR(15 downto 0); -- 256 words of 16-bit memory
    signal ram : ram_type := (
        0  => "0000001001001000", -- ADD R1, R2, R3 (R1 = R2 + R3)
        1  => "0001001001010000", -- SUB R2, R3, R4 (R2 = R3 - R4)
        2  => "0010001000011000", -- AND R1, R3, R6 (R1 = R3 AND R6)
        3  => "0011001001100000", -- OR R3, R4, R5 (R3 = R4 OR R5)
        4  => "0101001000100000", -- LOAD R1, Mem[R2] (R1 = Mem[R2])
        5  => "0110001000100000", -- STORE Mem[R2] = R1
        6  => "0111000000000001", -- JUMP to address 1
        7  => "1000000000000010", -- BEQ (Branch if Equal) to address 2
        others => (others => '0')  -- Default 0 (NOP)
    );

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
