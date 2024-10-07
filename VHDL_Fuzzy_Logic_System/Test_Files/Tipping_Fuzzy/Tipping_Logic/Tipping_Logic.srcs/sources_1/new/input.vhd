library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Fuzzy_Package.ALL;

-- ##############################################################################
-- # Module: input
-- # Description:
-- # The 'input' module is responsible for performing the fuzzification process,
-- # converting a crisp input value into fuzzy membership degrees based on 
-- # predefined membership functions. This module is dynamic and can handle any 
-- # number of membership functions by utilizing arrays for points and slopes, 
-- # making it highly reusable and adaptable.
-- #
-- # The membership functions are defined by two points (start and peak) and 
-- # two slopes (increasing and decreasing). The module loops through the 
-- # membership functions, assigns their respective points and slopes, and 
-- # then fuzzifies the crisp input to calculate the membership degrees.
-- #
-- # Input/Output:
-- #   - Inputs:
-- #     - 'crisp_input': The crisp input value to be fuzzified (8-bit value).
-- #     - 'reset': Reset signal (currently unused, but available for future use).
-- #     - 'mf_point1_array': Array holding the starting points for each membership function.
-- #     - 'mf_point2_array': Array holding the peak points for each membership function.
-- #     - 'mf_slope1_array': Array holding the slopes for the increasing parts of each membership function.
-- #     - 'mf_slope2_array': Array holding the slopes for the decreasing parts of each membership function.
-- #   - Outputs:
-- #     - 'membership_degrees': Array of fuzzified membership degrees, where each element 
-- #       corresponds to the degree of membership for a particular membership function.
-- #
-- # How it works:
-- #   - The module iterates over the membership functions, assigning each its respective 
-- #     points and slopes (from the input arrays).
-- #   - It then calls the 'Membership_Fuzzification' function from the 'Fuzzy_Package' 
-- #     to calculate the membership degrees for each function based on the crisp input value.
-- #   - The calculated membership degrees are output through the 'membership_degrees' port.
-- ##############################################################################

entity input is
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
end input; 

architecture Behavioral of input is

    -- An array of membership functions (one for each function in mf_num).
    -- Each membership function will be configured with its point1, point2, slope1, and slope2 values.
    signal membership_f : membership_functions(0 to mf_num-1);

    -- This signal will hold the fuzzy membership degrees after the fuzzification process.
    signal s_membership_degrees : member_outputs(0 to mf_num-1);

begin
    process(crisp_input)
        -- Variable to hold the fuzzified membership degrees before assigning them to the output.
        variable v_membership_degrees : member_outputs(0 to mf_num-1); 
    begin
        -- We loop through all the membership functions (from 0 to mf_num-1) to automatically assign
        -- the points and slopes for each one. This ensures the module can handle any number of functions.
        for i in 0 to mf_num-1 loop
            -- Assign the starting point for the i-th membership function.
            membership_f(i).point1 <= std_logic_vector(to_unsigned(mf_point1_array(i), 8));
            
            -- Assign the slope for the rising edge of the i-th membership function.
            membership_f(i).slope1 <= std_logic_vector(to_unsigned(mf_slope1_array(i), 16));
            
            -- Assign the ending point for the i-th membership function.
            membership_f(i).point2 <= std_logic_vector(to_unsigned(mf_point2_array(i), 8));
            
            -- Assign the slope for the falling edge of the i-th membership function.
            membership_f(i).slope2 <= std_logic_vector(to_unsigned(mf_slope2_array(i), 16));
        end loop;

        -- Fuzzification: Now that the membership functions are configured with their respective points and slopes,
        -- we pass the crisp input value and the array of membership functions to the fuzzification function.
        -- This function calculates the fuzzy membership degrees for each membership function.
        v_membership_degrees := Membership_Fuzzification(crisp_input, membership_f);
        
        -- Store the computed fuzzy membership degrees in a signal that can be passed to the output.
        -- We assign the degrees to a signal first, then pass it to the output port.
        s_membership_degrees <= v_membership_degrees;

    end process;
    
    membership_degrees <= s_membership_degrees;  -- Output the membership degrees

end Behavioral;