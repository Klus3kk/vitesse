-- LIBRARIES
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Standard library for operations

-- TESTBENCH ENTITY
entity alu_test is
end alu_test;

-- IMPLEMENTATION (testbench behavior)
architecture Behavioral of alu_test is
    -- FUNCTION DEFINITION INSIDE THE ARCHITECTURE
    function to_string(slv : std_logic_vector) return string is
        variable result : string(1 to slv'length); -- Create a string of the same length as the input vector
    begin
        for i in slv'range loop
            if slv(i) = '1' then
                result(i + 1) := '1';
            else
                result(i + 1) := '0';
            end if;
        end loop;
        return result;
    end function;

    -- SIGNALS FOR INPUTS, OUTPUTS, AND CONTROL
    signal A, B, Result : STD_LOGIC_VECTOR(15 downto 0); -- Operands and result
    signal Op           : STD_LOGIC_VECTOR(2 downto 0); -- Operation selector
    signal Zero         : STD_LOGIC; -- Zero flag
begin
    -- INSTANTIATE THE ALU (Unit Under Test)
    uut: entity work.alu
        port map (
            A => A, -- Connect input A
            B => B, -- Connect input B
            Op => Op, -- Connect operation selector
            Result => Result, -- Connect result output
            Zero => Zero -- Connect Zero flag output
        );

    -- TEST CASES (execution of operations)
    process
    begin
        -- -- TEST 1: ADDITION
        -- A <= "0000000000000001"; 
        -- B <= "0000000000000010"; 
        -- Op <= "000"; -- ADD
        -- wait for 1 ns; -- Ensure Op is applied
        -- report "ADD: A = 1, B = 2, Op = " & to_string(Op);
        -- wait for 10 ns;

        -- -- TEST 2: SUBTRACTION
        -- A <= "0000000000000010"; 
        -- B <= "0000000000000001"; 
        -- Op <= "001"; -- SUBTRACT
        -- wait for 1 ns; -- Ensure Op is applied
        -- report "SUB: A = 2, B = 1, Op = " & to_string(Op);
        -- wait for 10 ns;

        -- -- TEST 3: NOT OPERATION
        -- A <= "1111111111111111"; 
        -- B <= "0000000000000000"; 
        -- Op <= "100"; -- NOT
        -- wait for 1 ns; -- Ensure Op is applied
        -- report "NOT: A = -1, B = 0, Op = " & to_string(Op);
        -- wait for 10 ns;

        -- END TESTBENCH
        wait;
    end process;
end Behavioral;
