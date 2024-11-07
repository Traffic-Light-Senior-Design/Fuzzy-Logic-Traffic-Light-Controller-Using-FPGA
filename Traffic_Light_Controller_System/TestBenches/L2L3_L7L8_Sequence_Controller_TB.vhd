library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity L2L3_L7L8_Sequence_Controller_TB is
end L2L3_L7L8_Sequence_Controller_TB;

architecture Behavioral of L2L3_L7L8_Sequence_Controller_TB is

    -- Signals for the UUT
    signal L2L3_input, L7L8_input : std_logic_vector(7 downto 0);
    signal green_light_output_tb : std_logic_vector(7 downto 0);
    signal reset : std_logic := '0';  

    component L2L3_L7L8_Sequence_Controller is
    Port ( 
        L2L3 : in std_logic_vector(7 downto 0);
        L7L8 : in std_logic_vector(7 downto 0);
        green_light_output : out std_logic_vector(7 downto 0);
        reset : in std_logic
    );
    end component L2L3_L7L8_Sequence_Controller;

begin

    -- Instantiate UUT
    UUT : L2L3_L7L8_Sequence_Controller
        port map(
            L2L3 => L2L3_input,
            L7L8 => L7L8_input,
            reset => reset,
            green_light_output => green_light_output_tb
        );

    process
    begin
        -- Apply reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';  -- Deassert reset after 10 ns
        
        -- Test Case 1: L2L3 (0), L7L8 (0), expected (20)
        L2L3_input <= std_logic_vector(to_unsigned(0, 8));
        L7L8_input <= std_logic_vector(to_unsigned(0, 8));
        wait for 10 ns;
        -- verify that the output was correct
        assert (green_light_output_tb = std_logic_vector(to_unsigned(20, 8))) 
          report "Test Case 1 Failed: L2L3=0, L7L8=0, expected C=20" severity error;
        
        -- Test Case 2: L2L3 (21), L7L8 (42), expected (33)
        L2L3_input <= std_logic_vector(to_unsigned(21, 8));
        L7L8_input <= std_logic_vector(to_unsigned(42, 8));
        wait for 10 ns;
        
        -- Test Case 3: L2L3 (21), L7L8 (85), expected (45)
        L2L3_input <= std_logic_vector(to_unsigned(21, 8));
        L7L8_input <= std_logic_vector(to_unsigned(85, 8));
        wait for 10 ns;
        
        -- Test Case 4: L2L3 (50), L7L8 (57), expected (45)
        L2L3_input <= std_logic_vector(to_unsigned(50, 8));
        L7L8_input <= std_logic_vector(to_unsigned(57, 8));
        wait for 10 ns;
        
        -- Test Case 5: L2L3 (53), L7L8 (50), expected (44)
        L2L3_input <= std_logic_vector(to_unsigned(53, 8));
        L7L8_input <= std_logic_vector(to_unsigned(50, 8));
        wait for 10 ns;
        
        -- Test Case 6: L2L3 (42), L7L8 (71), expected (46)
        L2L3_input <= std_logic_vector(to_unsigned(42, 8));
        L7L8_input <= std_logic_vector(to_unsigned(71, 8));
        wait for 10 ns;
        
        -- Test Case 7: L2L3 (43), L7L8 (43), expected (39)
        L2L3_input <= std_logic_vector(to_unsigned(43, 8));
        L7L8_input <= std_logic_vector(to_unsigned(43, 8));
        wait for 10 ns;
        
        -- Test Case 8: L2L3 (43), L7L8 (21), expected (33)
        L2L3_input <= std_logic_vector(to_unsigned(43, 8));
        L7L8_input <= std_logic_vector(to_unsigned(21, 8));
        wait for 10 ns;
        
        -- Test Case 9: L2L3 (86), L7L8 (28), expected (46)
        L2L3_input <= std_logic_vector(to_unsigned(86, 8));
        L7L8_input <= std_logic_vector(to_unsigned(28, 8));
        wait for 10 ns;
        
        -- Test Case 10: L2L3 (12), L7L8 (37), expected (29)
        L2L3_input <= std_logic_vector(to_unsigned(12, 8));
        L7L8_input <= std_logic_vector(to_unsigned(37, 8));
        wait for 10 ns;
        
        
        -- Test Case 11: L2L3 (86), L7L8 (86), expected (60)
        L2L3_input <= std_logic_vector(to_unsigned(86, 8));
        L7L8_input <= std_logic_vector(to_unsigned(86, 8));
        wait for 10 ns;
        
        -- Finish simulation
        wait;
    end process;

end Behavioral;
