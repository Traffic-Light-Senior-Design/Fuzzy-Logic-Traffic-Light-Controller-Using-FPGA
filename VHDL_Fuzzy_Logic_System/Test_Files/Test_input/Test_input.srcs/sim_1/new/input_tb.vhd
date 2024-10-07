library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Import the package that contains fuzzy logic types and functions
use work.Fuzzy_Package.ALL;

entity input_tb is
end input_tb;

architecture Behavioral of input_tb is

    -- Component declaration for the taste_input module
    component taste_input
      generic (
            mf_num : natural := 3           -- Number of membership functions (you can set this to any number)
          );
      Port (
            crisp_input : in std_logic_vector(7 downto 0);  -- The input signal that we want to fuzzify (an 8-bit value)
            reset: in std_logic;                            -- Reset signal (not used in this module, but can be added for future use)
            
            -- Arrays for the points and slopes of all membership functions
            -- Each array entry corresponds to a specific membership function. For example, mf_point1_array(0)
            -- corresponds to the starting point of the first membership function, mf_point1_array(1) is for the second, and so on.
            mf_point1_array : integer_array(0 to mf_num-1);  -- Starting points of each membership function
            mf_point2_array : integer_array(0 to mf_num-1); -- Ending points of each membership function
            mf_slope1_array : integer_array(0 to mf_num-1); -- Slopes for the increasing parts of the membership functions
            mf_slope2_array : integer_array(0 to mf_num-1);  -- Slopes for the decreasing parts of the membership functions
            
            membership_degrees : out member_outputs(0 to mf_num-1)  -- Outputs the membership degrees after fuzzification
            );
    end component;

    -- Signals to drive inputs and capture outputs
    signal crisp_input_tb : std_logic_vector(7 downto 0);
    signal reset : std_logic := '0';
    signal membership_degrees_tb : member_outputs(0 to 2);  -- Adjust this to match the number of membership functions

    -- Test values for membership function generics
    constant mf_point1_array_tb : integer_array(0 to 2) := (0, 60, 160);
    constant mf_point2_array_tb : integer_array(0 to 2) := (50, 120, 200);
    constant mf_slope1_array_tb : integer_array(0 to 2) := (510, 425, 637);
    constant mf_slope2_array_tb : integer_array(0 to 2) := (510, 425, 637);

begin
    -- Instantiate the taste_input module
    uut: taste_input
        generic map (
            mf_num => 3
        )
        port map (
            crisp_input => crisp_input_tb,
            reset => reset,
            mf_point1_array => mf_point1_array_tb,
            mf_point2_array => mf_point2_array_tb,
            mf_slope1_array => mf_slope1_array_tb,
            mf_slope2_array => mf_slope2_array_tb,
            membership_degrees => membership_degrees_tb
        );

    -- Test process to apply inputs and monitor outputs
    test_process: process
    begin
        -- Apply reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';  -- Deassert reset after 10 ns
        
        -- Apply some test cases
        -- Test case 1: Crisp input = 7 - should coincide with falling edge of mf1 and rising edge of mf2
        crisp_input_tb <= std_logic_vector(to_unsigned(34, 8));
        wait for 10 ns;
        
        -- Test case 2: Crisp input = 15 - should be at peak of mf2 : 255
        crisp_input_tb <= std_logic_vector(to_unsigned(73, 8));
        wait for 10 ns;

        -- Test case 3: Crisp input = 25 - should be at peak of mf2 : 255
        crisp_input_tb <= std_logic_vector(to_unsigned(154, 8));
        wait for 10 ns;

        -- Test case 4: Crisp input = 33 - should be on falling edge of mf2 and rising edge of mf3
        crisp_input_tb <= std_logic_vector(to_unsigned(178, 8));
        wait for 10 ns;

        -- Test case 5: Crisp input = 37 - should be only on falling edge of mf3
        crisp_input_tb <= std_logic_vector(to_unsigned(200, 8));
        wait for 10 ns;

        -- End simulation
        wait;
    end process;
end Behavioral;
