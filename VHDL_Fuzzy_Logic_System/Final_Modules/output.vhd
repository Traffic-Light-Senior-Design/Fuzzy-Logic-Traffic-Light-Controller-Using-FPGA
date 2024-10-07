library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Fuzzy_Package.ALL;

-- ##############################################################################
-- # Module: output
-- # Description:
-- # The 'output' module performs the defuzzification process, converting the 
-- # fuzzy logic rule outputs into a single crisp value that can be used by external
-- # systems. This is done using the centroid method via the 'Defuzzification' function 
-- # from the Fuzzy_Package.
-- #
-- # The defuzzification process takes the following inputs:
-- #   - 'output_mf_values': The membership function values for the output from 
-- #     the fuzzy rule base, representing the fuzzy degrees of the output membership functions.
-- #   - 'singleton_values': The corresponding singleton values for each output 
-- #     membership function, representing the crisp values associated with each fuzzy degree.
-- #
-- # The 'Defuzzification' function computes the centroid of the output membership
-- # functions' fuzzy degrees and singleton values, producing a crisp output value.
-- #
-- # Input/Output:
-- #   - Inputs:
-- #     - 'output_mf_values': Array of fuzzy degrees from the output membership functions.
-- #     - 'singleton_values': Array of singleton values associated with each output membership function.
-- #   - Output:
-- #     - 'crisp_output': The calculated crisp output value after defuzzification.
-- #
-- # How it works:
-- #   - The 'Defuzzification' function is called concurrently to calculate the crisp output 
-- #     based on the weighted average (centroid) of the fuzzy outputs and their associated singletons.
-- ##############################################################################


entity output is
  generic ( 
    output_num : natural := 3
  );
  Port ( 
    output_mf_values : in rule_outputs(0 to output_num-1);
    singleton_values : in singletons(0 to output_num-1);
    crisp_output : out std_logic_vector(7 downto 0)
  );
end output;

architecture Behavioral of output is
begin
    -- Concurrent signal assignment for crisp output
    crisp_output <= Defuzzification(output_mf_values, singleton_values);
    
end Behavioral;