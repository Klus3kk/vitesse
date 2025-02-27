-- LIBRARIES
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Standard library for operations

-- TESTBENCH ENTITY
entity alu_test is
end alu_test;

-- IMPLEMENTATION (testbench behavior)
architecture Behavioral of alu_test is
    -- FUNCTION FOR DISPLAYING VECTORS (corrected)
    function to_string(slv : std_logic_vector) return string is
        variable result : string(1 to slv'length);
    begin
        for i in slv'range loop
            case slv(i) is
                when '0' => result(slv'length - i) := '0';
                when '1' => result(slv'length - i) := '1';
                when others => result(slv'length - i) := 'X';
            end case;
        end loop;
        return result;
    end function;
    
    -- SIGNALS FOR INPUTS, OUTPUTS, AND CONTROL
    signal A, B, Result : STD_LOGIC_VECTOR(15 downto 0); 
    signal Op : STD_LOGIC_VECTOR(2 downto 0);
    signal Zero : STD_LOGIC;
    
    -- Expected result for verification
    signal Expected_Result : STD_LOGIC_VECTOR(15 downto 0);
begin
    -- INSTANTIATE THE ALU
    uut: entity work.alu
    port map (
        A => A,
        B => B,
        Op => Op,
        Result => Result,
        Zero => Zero
    );
    
    -- TEST CASES
    process
    begin
        -- TEST 1: ADDITION
        A <= "0000000000000001"; -- 1
        B <= "0000000000000010"; -- 2
        Op <= "000"; -- ADD
        Expected_Result <= "0000000000000011"; -- 3
        wait for 10 ns;
        report "ADD: A = 1, B = 2, Result = " & to_string(Result) & 
               ", Expected = " & to_string(Expected_Result);
        assert (Result = Expected_Result) report "Addition test failed!" severity error;
        
        -- TEST 2: SUBTRACTION
        A <= "0000000000000010"; -- 2
        B <= "0000000000000001"; -- 1
        Op <= "001"; -- SUBTRACT
        Expected_Result <= "0000000000000001"; -- 1
        wait for 10 ns;
        report "SUB: A = 2, B = 1, Result = " & to_string(Result) & 
               ", Expected = " & to_string(Expected_Result);
        assert (Result = Expected_Result) report "Subtraction test failed!" severity error;
        
        -- TEST 3: NOT OPERATION
        A <= "1111111111111111"; -- All 1s
        B <= "0000000000000000"; -- Not used
        Op <= "100"; -- NOT
        Expected_Result <= "0000000000000000"; -- All 0s
        wait for 10 ns;
        report "NOT: A = -1, Result = " & to_string(Result) & 
               ", Expected = " & to_string(Expected_Result);
        assert (Result = Expected_Result) report "NOT operation test failed!" severity error;
        
        -- TEST 4: AND OPERATION
        A <= "1010101010101010"; 
        B <= "1100110011001100";
        Op <= "010"; -- AND
        Expected_Result <= "1000100010001000";
        wait for 10 ns;
        report "AND: Result = " & to_string(Result) & 
               ", Expected = " & to_string(Expected_Result);
        assert (Result = Expected_Result) report "AND operation test failed!" severity error;
        
        -- TEST 5: OR OPERATION
        A <= "1010101010101010";
        B <= "1100110011001100";
        Op <= "011"; -- OR
        Expected_Result <= "1110111011101110";
        wait for 10 ns;
        report "OR: Result = " & to_string(Result) & 
               ", Expected = " & to_string(Expected_Result);
        assert (Result = Expected_Result) report "OR operation test failed!" severity error;
        
        -- TEST 6: Zero flag test
        A <= "0000000000000000";
        B <= "0000000000000000";
        Op <= "000"; -- ADD (should result in zero)
        wait for 10 ns;
        report "Zero flag test: Result = " & to_string(Result) & ", Zero = " & std_logic'image(Zero);
        assert (Zero = '1') report "Zero flag test failed!" severity error;
        
        report "All tests completed!";
        wait;
    end process;
end Behavioral;
