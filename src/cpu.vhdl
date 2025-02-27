-- LIBRARIES
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ENTITY DECLARATION
entity cpu is
    Port (
        clk        : in  STD_LOGIC; -- Clock
        rst        : in  STD_LOGIC; -- Reset
        reg_write  : in  STD_LOGIC; -- Enable register write
        opcode     : in  STD_LOGIC_VECTOR(2 downto 0); -- ALU operation code
        reg_src1   : in  STD_LOGIC_VECTOR(2 downto 0); -- Register 1 (source)
        reg_src2   : in  STD_LOGIC_VECTOR(2 downto 0); -- Register 2 (source)
        reg_dest   : in  STD_LOGIC_VECTOR(2 downto 0)  -- Register to store result
    );
end cpu;

-- ARCHITECTURE
architecture Behavioral of cpu is
    -- COMPONENTS (REGISTER FILE & ALU)
    component register_file
        Port (
            clk        : in  STD_LOGIC;
            rst        : in  STD_LOGIC;
            read_reg1  : in  STD_LOGIC_VECTOR(2 downto 0);
            read_reg2  : in  STD_LOGIC_VECTOR(2 downto 0);
            write_reg  : in  STD_LOGIC_VECTOR(2 downto 0);
            write_data : in  STD_LOGIC_VECTOR(15 downto 0);
            reg_write  : in  STD_LOGIC;
            read_data1 : out STD_LOGIC_VECTOR(15 downto 0);
            read_data2 : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    component alu
        Port (
            A      : in  STD_LOGIC_VECTOR(15 downto 0);
            B      : in  STD_LOGIC_VECTOR(15 downto 0);
            Op     : in  STD_LOGIC_VECTOR(2 downto 0);
            Result : out STD_LOGIC_VECTOR(15 downto 0);
            Zero   : out STD_LOGIC
        );
    end component;

    -- SIGNALS TO CONNECT COMPONENTS
    signal data1, data2, alu_result : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal zero_flag : STD_LOGIC := '0';

begin
    -- REGISTER FILE INSTANCE
    regfile: register_file
        port map (
            clk => clk,
            rst => rst,
            read_reg1 => reg_src1,
            read_reg2 => reg_src2,
            write_reg => reg_dest,
            write_data => alu_result,
            reg_write => reg_write,
            read_data1 => data1,
            read_data2 => data2
        );

    -- ALU INSTANCE
    alu_unit: alu
        port map (
            A => data1,
            B => data2,
            Op => opcode,
            Result => alu_result,
            Zero => zero_flag
        );

end Behavioral;
