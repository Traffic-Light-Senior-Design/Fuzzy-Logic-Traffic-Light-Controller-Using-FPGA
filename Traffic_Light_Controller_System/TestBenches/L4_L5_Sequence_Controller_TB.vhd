library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity L4_L5_Sequence_Controller_TB is
end L4_L5_Sequence_Controller_TB;

architecture Behavioral of L4_L5_Sequence_Controller_TB is

    -- Signals for the UUT
    signal L5_input, L4_input : std_logic_vector(7 downto 0);
    signal green_light_output_tb : std_logic_vector(7 downto 0);
    signal reset : std_logic := '0';  

    component L4_L5_Sequence_Controller is
    Port ( 
        L4 : in std_logic_vector(7 downto 0);
        L5 : in std_logic_vector(7 downto 0);
        green_light_output : out std_logic_vector(7 downto 0);
        reset : in std_logic
    );
    end component L4_L5_Sequence_Controller;

begin

    -- Instantiate UUT
    UUT : L4_L5_Sequence_Controller
        port map(
            L4 => L4_input,
            L5 => L5_input,
            reset => reset,
            green_light_output => green_light_output_tb
        );

    process
    begin
        -- Apply reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';  -- Deassert reset after 10 ns
        
        -- Test Case 1: L5 (0), L4 (0), expected (15)
        L5_input <= std_logic_vector(to_unsigned(0, 8));
        L4_input <= std_logic_vector(to_unsigned(0, 8));
        wait for 10 ns;
        -- verify that the output was correct
        assert (green_light_output_tb = std_logic_vector(to_unsigned(15, 8))) 
          report "Test Case 1 Failed: L5=0, L4=0, expected C=15" severity error;
        
        -- Test Case 2: L5 (72), L4 (34), expected (16)
        L5_input <= std_logic_vector(to_unsigned(72, 8));
        L4_input <= std_logic_vector(to_unsigned(34, 8));
        wait for 10 ns;
        
        -- Test Case 3: L5 (54), L4 (7), expected (21)
        L5_input <= std_logic_vector(to_unsigned(54, 8));
        L4_input <= std_logic_vector(to_unsigned(7, 8));
        wait for 10 ns;
        
        -- Test Case 4: L5 (6), L4 (65), expected (15)
        L5_input <= std_logic_vector(to_unsigned(6, 8));
        L4_input <= std_logic_vector(to_unsigned(65, 8));
        wait for 10 ns;
        
        -- Test Case 5: L5 (99), L4 (51), expected (29)
        L5_input <= std_logic_vector(to_unsigned(99, 8));
        L4_input <= std_logic_vector(to_unsigned(51, 8));
        wait for 10 ns;
        
        -- Test Case 6: L5 (80), L4 (29), expected (15)
        L5_input <= std_logic_vector(to_unsigned(80, 8));
        L4_input <= std_logic_vector(to_unsigned(29, 8));
        wait for 10 ns;
        
        -- Test Case 7: L5 (45), L4 (56), expected (28)
        L5_input <= std_logic_vector(to_unsigned(45, 8));
        L4_input <= std_logic_vector(to_unsigned(56, 8));
        wait for 10 ns;
        
        -- Test Case 8: L5 (17), L4 (76), expected (15)
        L5_input <= std_logic_vector(to_unsigned(17, 8));
        L4_input <= std_logic_vector(to_unsigned(76, 8));
        wait for 10 ns;

        
        -- Finish simulation
        wait;
    end process;

end Behavioral;
