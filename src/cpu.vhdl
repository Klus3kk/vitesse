-- LIBRARIES
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ENTITY DECLARATION
entity cpu is
    Port (
        clk        : in  STD_LOGIC; -- Clock
        rst        : in  STD_LOGIC; -- Reset
        -- Debug outputs
        debug_pc   : out STD_LOGIC_VECTOR(15 downto 0); -- Program Counter
        debug_inst : out STD_LOGIC_VECTOR(15 downto 0); -- Current Instruction
        debug_reg1 : out STD_LOGIC_VECTOR(15 downto 0); -- Debug Register Output 1
        debug_reg2 : out STD_LOGIC_VECTOR(15 downto 0); -- Debug Register Output 2
        debug_reg3 : out STD_LOGIC_VECTOR(15 downto 0)  -- Debug Register Output 3
    );
end cpu;

-- ARCHITECTURE
architecture Behavioral of cpu is
    -- COMPONENTS
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
            Op     : in  STD_LOGIC_VECTOR(3 downto 0);
            Result : out STD_LOGIC_VECTOR(15 downto 0);
            Zero   : out STD_LOGIC
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

    component pc
        Port (
            clk       : in  STD_LOGIC;
            rst       : in  STD_LOGIC;
            enable    : in  STD_LOGIC;
            jump      : in  STD_LOGIC;
            jump_addr : in  STD_LOGIC_VECTOR(15 downto 0);
            pc_out    : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    -- SIGNALS
    signal pc_value, instruction : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal opcode : STD_LOGIC_VECTOR(3 downto 0);
    signal reg_dest, reg_src1, reg_src2 : STD_LOGIC_VECTOR(2 downto 0);
    signal data1, data2, alu_result : STD_LOGIC_VECTOR(15 downto 0);
    signal zero_flag, reg_write, mem_write, jump_enable : STD_LOGIC;

begin
    -- PROGRAM COUNTER (PC)
    pc_unit: pc
        port map (
            clk       => clk,
            rst       => rst,
            enable    => '1',  -- Always increment PC
            jump      => jump_enable,
            jump_addr => data1,
            pc_out    => pc_value
        );

    -- MEMORY (FETCH INSTRUCTION)
    mem_unit: memory
        port map (
            clk          => clk,
            address      => pc_value,
            write_enable => mem_write,
            write_data   => data2, -- Store value when needed
            read_data    => instruction
        );

    -- REGISTER FILE
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

    -- ALU
    alu_unit: alu
        port map (
            A => data1,
            B => data2,
            Op => opcode,
            Result => alu_result,
            Zero => zero_flag
        );

    -- INSTRUCTION DECODER
    process (instruction)
    begin
        -- Extract fields
        opcode   <= instruction(15 downto 12);
        reg_dest <= instruction(11 downto 9);
        reg_src1 <= instruction(8 downto 6);
        reg_src2 <= instruction(5 downto 3);

        -- Default control signals
        reg_write <= '0';
        mem_write <= '0';
        jump_enable <= '0';

        case opcode is
            -- ADD
            when "0000" =>
                reg_write <= '1';

            -- SUB
            when "0001" =>
                reg_write <= '1';

            -- AND
            when "0010" =>
                reg_write <= '1';

            -- OR
            when "0011" =>
                reg_write <= '1';

            -- NOT
            when "0100" =>
                reg_write <= '1';

            -- LOAD
            when "0101" =>
                reg_write <= '1';

            -- STORE
            when "0110" =>
                mem_write <= '1';

            -- JUMP
            when "0111" =>
                jump_enable <= '1';

            -- BEQ (Branch if Equal)
            when "1000" =>
                if zero_flag = '1' then
                    jump_enable <= '1';
                end if;

            -- DEFAULT (NOP)
            when others =>
                null;
        end case;
    end process;

    -- DEBUG OUTPUTS
    debug_pc   <= pc_value;
    debug_inst <= instruction;
    debug_reg1 <= data1;
    debug_reg2 <= data2;
    debug_reg3 <= alu_result;

end Behavioral;
