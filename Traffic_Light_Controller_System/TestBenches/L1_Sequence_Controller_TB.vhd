

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity L1_Sequence_Controller_TB is
end L1_Sequence_Controller_TB;

architecture Behavioral of L1_Sequence_Controller_TB is

    -- Signals for the UUT
    signal L1_input : std_logic_vector(7 downto 0);
    signal green_light_output_tb : std_logic_vector(7 downto 0);
    signal reset : std_logic := '0';  

    component L1_Sequence_Controller is
    Port ( 
        L1 : in std_logic_vector(7 downto 0);
        green_light_output : out std_logic_vector(7 downto 0);
        reset : in std_logic
    );
    end component L1_Sequence_Controller;

begin

    -- Instantiate UUT
    UUT : L1_Sequence_Controller
        port map(
            L1 => L1_input,
            reset => reset,
            green_light_output => green_light_output_tb
        );

    process
    begin
        -- Apply reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';  -- Deassert reset after 10 ns
        
        -- Test Case 1: L1 (0), expected (15)
        L1_input <= std_logic_vector(to_unsigned(0, 8));
        wait for 10 ns;
        -- verify that the output was correct
        assert (green_light_output_tb = std_logic_vector(to_unsigned(15, 8))) 
          report "Test Case 1 Failed: L1=0, expected C=15" severity error;
        
        -- Test Case 2: L1 (21), expected (29)
        L1_input <= std_logic_vector(to_unsigned(21, 8));
        wait for 10 ns;
        
        -- Test Case 3: L1 (21), expected (40)
        L1_input <= std_logic_vector(to_unsigned(39, 8));
        wait for 10 ns;
        
        -- Test Case 4: L1 (50), L9 (57), expected (35)
        L1_input <= std_logic_vector(to_unsigned(50, 8));
        wait for 10 ns;
        
        -- Test Case 5: L1 (53), L9 (50), expected (38)
        L1_input <= std_logic_vector(to_unsigned(69, 8));
        wait for 10 ns;
        
        -- Test Case 6: L1 (42), L9 (71), expected (41)
        L1_input <= std_logic_vector(to_unsigned(88, 8));
        wait for 10 ns;
        
        -- Finish simulation
        wait;
    end process;

end Behavioral;
