library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity L9_Sequence_Controller_TB is
end L9_Sequence_Controller_TB;

architecture Behavioral of L9_Sequence_Controller_TB is

    -- Signals for the UUT
    signal L9_input : std_logic_vector(7 downto 0);
    signal green_light_output_tb : std_logic_vector(7 downto 0);
    signal reset : std_logic := '0';  

    component L9_Sequence_Controller is
    Port ( 
        L9 : in std_logic_vector(7 downto 0);
        green_light_output : out std_logic_vector(7 downto 0);
        reset : in std_logic
    );
    end component L9_Sequence_Controller;

begin

    -- Instantiate UUT
    UUT : L9_Sequence_Controller
        port map(
            L9 => L9_input,
            reset => reset,
            green_light_output => green_light_output_tb
        );

    process
    begin
        -- Apply reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';  -- Deassert reset after 10 ns
        
        -- Test Case 1: L9 (0), expected (15)
        L9_input <= std_logic_vector(to_unsigned(0, 8));
        wait for 10 ns;
        -- verify that the output was correct
        assert (green_light_output_tb = std_logic_vector(to_unsigned(15, 8))) 
          report "Test Case 1 Failed: L9=0, expected C=15" severity error;
        
        -- Test Case 2: L9 (21), expected (29)
        L9_input <= std_logic_vector(to_unsigned(21, 8));
        wait for 10 ns;
        
        -- Test Case 3: L9 (39), expected (40)
        L9_input <= std_logic_vector(to_unsigned(39, 8));
        wait for 10 ns;
        
        -- Test Case 4: L9 (50), L9 (57), expected (35)
        L9_input <= std_logic_vector(to_unsigned(50, 8));
        wait for 10 ns;
        
        -- Test Case 5: L9 (69), L9 (50), expected (38)
        L9_input <= std_logic_vector(to_unsigned(69, 8));
        wait for 10 ns;
        
        -- Test Case 6: L9 (88), L9 (71), expected (41)
        L9_input <= std_logic_vector(to_unsigned(88, 8));
        wait for 10 ns;
        
        -- Finish simulation
        wait;
    end process;

end Behavioral;
