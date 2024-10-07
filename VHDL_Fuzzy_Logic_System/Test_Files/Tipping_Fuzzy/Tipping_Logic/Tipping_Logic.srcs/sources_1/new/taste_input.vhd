library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Fuzzy_Package.ALL;

-- This input module is now dynamic and can handle any number of membership functions
-- by passing arrays of points and slopes. The module automatically assigns values 
-- to each membership function, making it very reusable.
entity taste_input is
  generic (
    mf_num : natural := 2;           -- Number of membership functions (you can set this to any number)
    
    -- Arrays for the points and slopes of all membership functions
    -- Each array entry corresponds to a specific membership function. For example, mf_point1_array(0)
    -- corresponds to the starting point of the first membership function, mf_point1_array(1) is for the second, and so on.
    mf_point1_array : integer_array(0 to mf_num-1) := (others => 0);  -- Starting points of each membership function
    mf_point2_array : integer_array(0 to mf_num-1) := (others => 50); -- Ending points of each membership function
    mf_slope1_array : integer_array(0 to mf_num-1) := (others => 10); -- Slopes for the increasing parts of the membership functions
    mf_slope2_array : integer_array(0 to mf_num-1) := (others => 20)  -- Slopes for the decreasing parts of the membership functions
  );
  Port (
        crisp_input : in std_logic_vector(7 downto 0);  -- The input signal that we want to fuzzify (an 8-bit value)
        reset: in std_logic;                            -- Reset signal (not used in this module, but can be added for future use)
        membership_degrees : out member_outputs(0 to mf_num-1)  -- Outputs the membership degrees after fuzzification
        );
end taste_input;

architecture Behavioral of taste_input is
 
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
            membership_f(i).slope1 <= std_logic_vector(to_unsigned(mf_slope1_array(i), 8));
            
            -- Assign the ending point for the i-th membership function.
            membership_f(i).point2 <= std_logic_vector(to_unsigned(mf_point2_array(i), 8));
            
            -- Assign the slope for the falling edge of the i-th membership function.
            membership_f(i).slope2 <= std_logic_vector(to_unsigned(mf_slope2_array(i), 8));
        end loop;

        -- Fuzzification: Now that the membership functions are configured with their respective points and slopes,
        -- we pass the crisp input value and the array of membership functions to the fuzzification function.
        -- This function calculates the fuzzy membership degrees for each membership function.
        v_membership_degrees := Membership_Fuzzification(crisp_input, membership_f);
        
        -- Store the computed fuzzy membership degrees in a signal that can be passed to the output.
        -- We assign the degrees to a signal first, then pass it to the output port.
        s_membership_degrees <= v_membership_degrees;
        membership_degrees <= s_membership_degrees;  -- Output the membership degrees

    end process;

end Behavioral;
