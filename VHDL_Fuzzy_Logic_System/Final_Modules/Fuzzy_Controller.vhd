library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Fuzzy_Package.ALL;

entity Fuzzy_Controller is
    port(
        input_signal : in std_logic_vector(7 downto 0);  -- Generalized input signal to fuzzify
        fuzzy_output : out std_logic_vector(7 downto 0); -- Final crisp output after defuzzification
        reset : in std_logic                           -- Reset signal to reset the system
    );
end Fuzzy_Controller;

architecture Behavioral of Fuzzy_Controller is

    -- Generic constants for configuration
    constant mf_num : natural := 2;      -- Number of membership functions for the input
    constant rule_num : natural := 4;    -- Number of rules in the system
    constant input_num : natural := mf_num; -- Total number of membership functions for the input
    constant output_num : natural := 3;  -- Number of output membership functions (Low, Medium, High)

    -- The fuzzified degrees for the input signal
    signal input_mf_degrees : member_outputs(0 to mf_num-1);

    -- Membership function points for the input signal (these define the shape of the fuzzy logic input functions)
    constant mf_point1_array : integer_array(0 to mf_num-1) := (0, 42);   -- Starting points of membership functions
    constant mf_point2_array : integer_array(0 to mf_num-1) := (0, 255);  -- Peak points (where the function value is 1)
    constant mf_slope1_array : integer_array(0 to mf_num-1) := (0, 120);  -- Slopes for increasing parts of the membership functions
    constant mf_slope2_array : integer_array(0 to mf_num-1) := (120, 0);  -- Slopes for decreasing parts of the membership functions

    -- Rule base signals: These define how the fuzzy rules are evaluated
    signal rule_type_array : integer_array(0 to rule_num-1); -- Defines if the rule uses AND(0) or OR(1)
    signal rule_conditions_array : integer_matrix(0 to rule_num-1, 0 to input_num-1); -- Defines which membership functions are used in each rule
    signal output_notation: integer_array(0 to rule_num-1);  -- Maps each rule to an output membership function
    signal combined_outputs : rule_outputs(0 to output_num-1); -- Final fuzzy degrees for each output membership function

    -- Defuzzification parameters: singleton values (crisp outputs) for each fuzzy output
    constant singleton_values : singletons(0 to output_num-1) := (x"00", x"32", x"64"); -- Low, Medium, High crisp values

begin
    
    -- Initialize the rule type array
    -- Here, all rules use conjunction (AND) logic (0 = AND, 1 = OR)
    rule_type_array <= (0, 0, 0, 0);  -- All rules will perform an AND operation
    
    -- Define the mapping of rules to output membership functions
    -- 1 for Low, 2 for Medium, 3 for High
    output_notation <= (1, 2, 2, 3);  -- Rules 2 and 3 share the same output (Medium)

    -- Set up the conditions for each rule
    -- Each row defines which membership functions are used in a rule:
    -- 1 means the MF is involved in the rule, 0 means it's not
    rule_conditions_array <= ((1, 0),  -- Rule 1: Input MF1 (only one membership function involved)
                              (1, 1),  -- Rule 2: Input MF1 AND MF2 (both involved)
                              (0, 1),  -- Rule 3: Input MF2 (only MF2 involved)
                              (0, 0)); -- Rule 4: No valid inputs (this rule does nothing)

    -- Fuzzification process for the input signal
    -- This block applies the membership functions to the input signal
    -- It will output the fuzzy membership degrees for each input MF
    input_fuzzification : entity work.input
        generic map (
            mf_num => mf_num  -- We're using 2 membership functions here
        )
        port map (
            crisp_input => input_signal,  -- The input signal we want to fuzzify
            reset => reset,               -- Reset signal to clear the system
            mf_point1_array => mf_point1_array,  -- Starting points for the membership functions
            mf_point2_array => mf_point2_array,  -- Peak points for the membership functions
            mf_slope1_array => mf_slope1_array,  -- Slopes for the increasing sides
            mf_slope2_array => mf_slope2_array,  -- Slopes for the decreasing sides
            membership_degrees => input_mf_degrees  -- Output: fuzzified degrees
        );

    -- Rule base processing
    -- This block applies the rules defined above to the fuzzified membership degrees
    -- It will combine the results of the rules into the output membership functions
    rules : entity work.rule_base 
        generic map (
            rule_num => rule_num,     -- Number of rules to evaluate
            input_num => input_num,   -- Number of input membership functions
            final_num => output_num   -- Number of output membership functions (Low, Medium, High)
        )
        port map (
            rule_type_array => rule_type_array,  -- AND/OR logic for each rule
            rule_conditions_array => rule_conditions_array,  -- Which MFs are involved in each rule
            output_notation => output_notation,  -- Maps rules to output MFs
            reset => reset,  -- Reset signal to clear the system
            membership_degrees => input_mf_degrees,  -- Fuzzified degrees from the input
            rule_output => open,  -- Intermediate output (not used here)
            combined_outputs => combined_outputs  -- Final combined outputs for the output MFs
        );

    -- Defuzzification process
    -- This block converts the fuzzy membership degrees of the output into a single crisp output
    -- It uses the singleton values (predefined crisp values) to calculate the final crisp output
    final_output : entity work.output
        generic map (
            output_num => output_num  -- Number of output membership functions
        )
        port map (
            output_mf_values => combined_outputs,  -- The fuzzy membership degrees from the rule base
            singleton_values => singleton_values,  -- The predefined crisp values for the outputs (Low, Medium, High)
            crisp_output => fuzzy_output  -- The final crisp output value
        );
    
end Behavioral;

