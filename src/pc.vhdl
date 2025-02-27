-- LIBRARIES
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ENTITY DECLARATION
entity pc is
    Port (
        clk     : in  STD_LOGIC; -- Clock signal
        rst     : in  STD_LOGIC; -- Reset signal
        enable  : in  STD_LOGIC; -- Enable PC update
        jump    : in  STD_LOGIC; -- Enable manual jump
        jump_addr : in  STD_LOGIC_VECTOR(15 downto 0); -- Target jump address
        pc_out  : out STD_LOGIC_VECTOR(15 downto 0) -- Current PC value
    );
end pc;

-- ARCHITECTURE
architecture Behavioral of pc is
    signal pc_reg : STD_LOGIC_VECTOR(15 downto 0) := (others => '0'); -- PC storage
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pc_reg <= (others => '0'); -- Reset PC to 0
            elsif enable = '1' then
                if jump = '1' then
                    pc_reg <= jump_addr; -- Jump to new address
                else
                    pc_reg <= std_logic_vector(unsigned(pc_reg) + 1); -- Increment PC
                end if;
            end if;
        end if;
    end process;

    pc_out <= pc_reg; -- Output PC value
end Behavioral;
