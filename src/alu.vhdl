-- LIBRARIES
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Standard library for arithmetic and logical operations

-- DECLARATION (definition of ports and entity)
entity alu is
    Port (
        A      : in STD_LOGIC_VECTOR(15 downto 0); -- First input operand
        B      : in STD_LOGIC_VECTOR(15 downto 0); -- Second input operand
        Op     : in STD_LOGIC_VECTOR(2 downto 0);  -- Selection of operation
        Result : out STD_LOGIC_VECTOR(15 downto 0); -- Output result of operation
        Zero   : out STD_LOGIC -- Zero flag (set when Result is zero)
    );
end alu;

-- IMPLEMENTATION (behavior of the ALU)
architecture Behavioral of alu is
begin
    process (A, B, Op) -- Sensitive to changes in A, B, or Op
        variable int_A, int_B : signed(15 downto 0); -- Signed integers for arithmetic
        variable int_Result   : signed(15 downto 0); -- Result of the operation
    begin 
        -- CONVERT INPUTS TO SIGNED FOR CALCULATIONS
        int_A := signed(A);
        int_B := signed(B);

        -- SELECT OPERATION BASED ON Op
        case Op is
            when "000" => int_Result := signed(A) + signed(B); -- Add
            when "001" => int_Result := signed(A) - signed(B); -- Subtract
            when "010" => int_Result := signed(A and B); -- AND (logical)
            when "011" => int_Result := signed(A or B); -- OR (logical)
            when "100" => int_Result := signed(not A); -- NOT (logical)
            when others => int_Result := (others => '0'); -- Default: Set to 0
        end case;

        -- CONVERT RESULT BACK TO STD_LOGIC_VECTOR
        Result <= std_logic_vector(int_Result);

        -- SETTING Zero FLAG BASED ON RESULT
        if int_Result = 0 then
            Zero <= '1'; -- Set Zero flag if Result is zero
        else
            Zero <= '0'; -- Clear Zero flag otherwise
        end if;
    end process;
end Behavioral;
