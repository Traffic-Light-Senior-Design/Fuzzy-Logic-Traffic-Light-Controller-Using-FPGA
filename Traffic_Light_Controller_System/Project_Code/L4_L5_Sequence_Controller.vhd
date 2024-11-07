library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Fuzzy_Package.ALL;


entity L4_L5_Sequence_Controller is
  Port ( 
    L4 : in std_logic_vector(7 downto 0);
    L5 : in std_logic_vector(7 downto 0);
    green_light_output : out std_logic_vector(7 downto 0);
    reset : in std_logic
  );
end L4_L5_Sequence_Controller;

architecture Behavioral of L4_L5_Sequence_Controller is

    -- generic constants
    constant mf_num_L5 : natural := 3; -- number of MFs in L5 input
    constant mf_num_L4 : natural := 2; -- number of MFs in L4 input
    constant rule_num : natural := 8;  -- Number of rules
    constant input_num : natural := 5;  -- Total number of mf of all inputs
    constant output_num : natural := 3; -- Number of output membership functions
    
    -- Membership degree outputs for L4, and L5
    signal L5_mf_degrees : member_outputs(0 to mf_num_L5-1);
    signal L4_mf_degrees : member_outputs(0 to mf_num_L4-1);
    signal mf_degrees_all : member_outputs (0 to input_num-1);

    -- Membership function points for L4 input
    constant L4_point1 : integer_array(0 to mf_num_L4-1) := (0, 20);
    constant L4_point2 : integer_array(0 to mf_num_L4-1) := (20, 100);
    constant L4_slope1 : integer_array(0 to mf_num_L4-1) := (0, 425);
    constant L4_slope2 : integer_array(0 to mf_num_L4-1) := (425, 0);
    
    
    -- Membership function points for L5 input
    constant L5_point1 : integer_array(0 to mf_num_L5-1) := (0, 10, 45);
    constant L5_point2 : integer_array(0 to mf_num_L5-1) := (0, 45, 100);
    constant L5_slope1 : integer_array(0 to mf_num_L5-1) := (0, 728, 728);
    constant L5_slope2 : integer_array(0 to mf_num_L5-1) := (566, 728, 0);
    
    -- signals required for the rule base
    signal rule_type_array : integer_array(0 to rule_num-1); -- decide between [AND(0), OR(1)]
    signal rule_conditions_array : integer_matrix(0 to rule_num-1, 0 to input_num-1); --decide which mf to use per rule
    signal output_notation: integer_array(0 to rule_num-1); -- indicates what output mf each rule has
    signal combined_outputs : rule_outputs(0 to output_num-1); -- the final membership degrees for each output mf
    
    -- signals required for the output
    -- the values of the output mf on the universe of discourse
    constant singleton_values : singletons(0 to output_num-1) := (x"0F", x"1E", x"2D"); -- 15, 30, 45
    
begin

    mf_degrees_all <= L4_mf_degrees & L5_mf_degrees; -- concatenate the membership degrees of truth
    
    -- Initialize the rule type array (0 for AND, 1 for OR)
    rule_type_array <= (0, 0, 0, 0, 0, 0, 0, 0);  -- All rules use conjunction (AND)
        
    --Initialize the output notation (1 for low, 2 for med, 3 for high)
    output_notation <= (1, 1, 1, 2, 3, 2, 2, 3); -- low, low, low, med, med, med, high, high, high, low
    
    -- Initialize the rule conditions array
    rule_conditions_array <= ((1, 0, 0, 0, 0),  -- Rule 1: L4 0|1
                              (0, 0, 1, 0, 0),  -- Rule 2: L5 low 
                              (1, 0, 1, 0, 0),  -- Rule 3: L3 med AND L5 med AND L4 0|1
                              (1, 0, 0, 1, 0),  -- Rule 4: L3 high AND L5 med AND L4 0|1
                              (1, 0, 0, 0, 1),  -- Rule 5: L3 med AND L5 high AND L4 0|1
                              (0, 1, 1, 0, 0),  -- Rule 6: L3 med AND L5 med AND L4 >1
                              (0, 1, 0, 1, 0),  -- Rule 7: L3 high AND L5 med AND L4 >1
                              (0, 1, 0, 0, 1)  -- Rule 8: L3 med AND L5 high AND L4 >1
                             ); 

        
    L5_input : entity work.input
        generic map (
            mf_num => mf_num_L5
        )
        port map (
            crisp_input => L5,
            reset => reset,
            mf_point1_array => L5_point1,
            mf_point2_array => L5_point2,
            mf_slope1_array => L5_slope1,
            mf_slope2_array => L5_slope2,
            membership_degrees => L5_mf_degrees
        );
        
    L4_input : entity work.input
        generic map (
            mf_num => mf_num_L4
        )
        port map (
            crisp_input => L4,
            reset => reset,
            mf_point1_array => L4_point1,
            mf_point2_array => L4_point2,
            mf_slope1_array => L4_slope1,
            mf_slope2_array => L4_slope2,
            membership_degrees => L4_mf_degrees
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
            crisp_output => green_light_output
        );


end Behavioral;