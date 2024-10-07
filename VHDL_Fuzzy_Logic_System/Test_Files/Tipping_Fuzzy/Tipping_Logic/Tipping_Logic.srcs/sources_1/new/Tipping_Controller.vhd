library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Fuzzy_Package.ALL;

entity Tipping_Controller is
    port(
        taste : in std_logic_vector(7 downto 0);
        service : in std_logic_vector(7 downto 0);
        tip_output : out std_logic_vector(7 downto 0);
        reset : in std_logic -- Add a reset input
    );
end Tipping_Controller;

architecture Behavioral of Tipping_Controller is
    
    -- generic constants
    constant mf_num : natural := 2; --only using one since both inputs have 2 mf
    constant rule_num : natural := 4;  -- Number of rules
    constant input_num : natural := 4;  -- Total number of mf of all inputs
    constant output_num : natural := 3; -- Number of output membership functions
    
    -- Membership degree outputs for taste and service
    signal taste_mf_degrees : member_outputs(0 to mf_num-1);
    signal service_mf_degrees : member_outputs(0 to mf_num-1);
    signal mf_degrees_all : member_outputs (0 to input_num-1);

    -- Membership function points for taste input
    constant taste_point1 : integer_array(0 to mf_num-1) := (0, 42);
    constant taste_point2 : integer_array(0 to mf_num-1) := (0, 255);
    constant taste_slope1 : integer_array(0 to mf_num-1) := (0, 120);
    constant taste_slope2 : integer_array(0 to mf_num-1) := (120, 0);
    
    -- Membership function points for service input
    constant service_point1 : integer_array(0 to mf_num-1) := (0, 42);
    constant service_point2 : integer_array(0 to mf_num-1) := (0, 255);
    constant service_slope1 : integer_array(0 to mf_num-1) := (0, 120);
    constant service_slope2 : integer_array(0 to mf_num-1) := (120, 0);
    
    -- signals required for the rule base
    signal rule_type_array : integer_array(0 to rule_num-1); -- decide between [AND(0), OR(1)]
    signal rule_conditions_array : integer_matrix(0 to rule_num-1, 0 to input_num-1); --decide which mf to use per rule
    signal output_notation: integer_array(0 to rule_num-1); -- indicates what output mf each rule has
    signal combined_outputs : rule_outputs(0 to output_num-1); -- the final membership degrees for each output mf
    
    -- signals required for the output
    constant singleton_values : singletons(0 to output_num-1) := (x"00", x"32", x"64"); -- the values of the output mf on the universe of discourse

begin
    
    mf_degrees_all <= taste_mf_degrees & service_mf_degrees; -- concatenate the membership degrees of truth
    
    -- Initialize the rule type array (0 for AND, 1 for OR)
    rule_type_array <= (0, 0, 0, 0);  -- All rules use conjunction (AND)
        
    --Initialize the output notation (1 for low, 2 for med, 3 for high)
    output_notation <= (1, 2, 2, 3); -- rule 2 and 3 share the same output mapping
    
    -- Initialize the rule conditions array
    rule_conditions_array <= ((1, 0, 1, 0),  -- Rule 1: taste Inedible AND service Poor
                              (1, 0, 0, 1),  -- Rule 2: taste Inedible AND service Excellent
                              (0, 1, 1, 0),  -- Rule 3: taste Delicious AND service Poor
                              (0, 1, 0, 1)); -- Rule 4: taste Delicious AND service Excellent
    
    taste_input : entity work.input
        generic map (
            mf_num => mf_num
        )
        port map (
            crisp_input => taste,
            reset => reset,
            mf_point1_array => taste_point1,
            mf_point2_array => taste_point2,
            mf_slope1_array => taste_slope1,
            mf_slope2_array => taste_slope2,
            membership_degrees => taste_mf_degrees
        );
    
    
    service_input : entity work.input
        generic map (
            mf_num => mf_num
        )
        port map (
            crisp_input => service,
            reset => reset,
            mf_point1_array => service_point1,
            mf_point2_array => service_point2,
            mf_slope1_array => service_slope1,
            mf_slope2_array => service_slope2,
            membership_degrees => service_mf_degrees
        );
        
    rules : entity work.rule_base 
        generic map (
            rule_num => rule_num,
            input_num => input_num,
            final_num => output_num
        )
        port map (
            rule_type_array => rule_type_array,
            rule_conditions_array => rule_conditions_array,
            output_notation => output_notation,
            reset => reset,
            membership_degrees => mf_degrees_all,
            rule_output => open, --not required for this project
            combined_outputs => combined_outputs
        );
    
    final_output : entity work.output
        generic map (
            output_num => output_num
        )
        port map (
            output_mf_values => combined_outputs,
            singleton_values => singleton_values,
            crisp_output => tip_output
        );
    
end Behavioral;
