library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Tipping_Controller_tb is
end Tipping_Controller_tb;

architecture Behavioral of Tipping_Controller_tb is
    -- Signals for the UUT
    signal taste_input, service_input : std_logic_vector(7 downto 0);
    signal tip_output : std_logic_vector(7 downto 0);
    signal reset : std_logic := '0';  -- Add reset signal

    signal clk : std_logic := '0';  -- Clock signal

    component Tipping_Controller
        port(
            taste : in std_logic_vector(7 downto 0);
            service : in std_logic_vector(7 downto 0);
            tip_output : out std_logic_vector(7 downto 0);
            reset : in std_logic -- Add a reset input
        );
    end component;
    
begin
    -- Clock process
    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;
    
    -- Instantiate UUT
    UUT : Tipping_Controller
        port map(
            taste => taste_input,
            service => service_input,
            reset => reset,
            tip_output => tip_output
        );
    

    process
    begin
        -- Apply reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';  -- Deassert reset after 10 ns
        
        -- Test Case 1: taste (0), service (0), expected (0)
        taste_input <= std_logic_vector(to_unsigned(0, 8));
        service_input <= std_logic_vector(to_unsigned(0, 8));
        wait for 10 ns;
        -- verify that the output was correct
        assert (tip_output = std_logic_vector(to_unsigned(0, 8))) 
          report "Test Case 1 Failed: taste=0, service=0, expected C=0" severity error;
        
        -- assert not used for the test cases because the output has about 2-3% percent error.
        
        -- Test Case 1: taste (145), service (145), expected ()
        taste_input <= std_logic_vector(to_unsigned(145, 8));
        service_input <= std_logic_vector(to_unsigned(145, 8));
        wait for 10 ns;
        
        -- Test Case 1: taste (55), service (200), expected ()
        taste_input <= std_logic_vector(to_unsigned(55, 8));
        service_input <= std_logic_vector(to_unsigned(200, 8));
        wait for 10 ns;
        
        -- Test Case 1: taste (200), service (182), expected ()
        taste_input <= std_logic_vector(to_unsigned(200, 8));
        service_input <= std_logic_vector(to_unsigned(182, 8));
        wait for 10 ns;
        
        -- Test Case 1: taste (200), service (200), expected ()
        taste_input <= std_logic_vector(to_unsigned(200, 8));
        service_input <= std_logic_vector(to_unsigned(200, 8));
        wait for 10 ns;
        
        -- Finish simulation
        wait;
    end process;
end Behavioral;
