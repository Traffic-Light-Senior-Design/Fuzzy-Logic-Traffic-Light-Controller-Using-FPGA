library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Fuzzy_Package.ALL;

entity L2L3_L7L8_Sequence_Controller is
  Port ( 
    L2L3 : in std_logic_vector(7 downto 0);
    L7L8 : in std_logic_vector(7 downto 0);
    green_light_output : out std_logic_vector(7 downto 0);
    reset : in std_logic
  );
end L2L3_L7L8_Sequence_Controller;

architecture Behavioral of L2L3_L7L8_Sequence_Controller is

    -- generic constants
    constant mf_num_L2L3 : natural := 3; -- number of MFs in L2L3 input
    constant mf_num_L7L8 : natural := 3; -- number of MFs in L7L8 input
    constant rule_num : natural := 6;  -- Number of rules
    constant input_num : natural := 6;  -- Total number of mf of all inputs
    constant output_num : natural := 3; -- Number of output membership functions
    
    -- Membership degree outputs for L2L3 and L7L8
    signal L2L3_mf_degrees : member_outputs(0 to mf_num_L2L3-1);
    signal L7L8_mf_degrees : member_outputs(0 to mf_num_L7L8-1);
    signal mf_degrees_all : member_outputs (0 to input_num-1);

    -- Membership function points for L2L3 input
    constant L2L3_point1 : integer_array(0 to mf_num_L2L3-1) := (0, 10, 45);
    constant L2L3_point2 : integer_array(0 to mf_num_L2L3-1) := (0, 45, 100);
    constant L2L3_slope1 : integer_array(0 to mf_num_L2L3-1) := (0, 728, 728);
    constant L2L3_slope2 : integer_array(0 to mf_num_L2L3-1) := (566, 728, 0);
    
    -- Membership function points for L7L8 input
    constant L7L8_point1 : integer_array(0 to mf_num_L7L8-1) := (0, 10, 45);
    constant L7L8_point2 : integer_array(0 to mf_num_L7L8-1) := (0, 45, 100);
    constant L7L8_slope1 : integer_array(0 to mf_num_L7L8-1) := (0, 728, 728);
    constant L7L8_slope2 : integer_array(0 to mf_num_L7L8-1) := (566, 728, 0);
    
    -- signals required for the rule base
    signal rule_type_array : integer_array(0 to rule_num-1); -- decide between [AND(0), OR(1)]
    signal rule_conditions_array : integer_matrix(0 to rule_num-1, 0 to input_num-1); --decide which mf to use per rule
    signal output_notation: integer_array(0 to rule_num-1); -- indicates what output mf each rule has
    signal combined_outputs : rule_outputs(0 to output_num-1); -- the final membership degrees for each output mf
    
    -- signals required for the output
    -- the values of the output mf on the universe of discourse
    constant singleton_values : singletons(0 to output_num-1) := (x"14", x"28", x"3C"); -- 20, 40, 60

begin

    mf_degrees_all <= L2L3_mf_degrees & L7L8_mf_degrees; -- concatenate the membership degrees of truth
    
    -- Initialize the rule type array (0 for AND, 1 for OR)
    rule_type_array <= (0, 0, 0, 0, 0, 0);  -- All rules use conjunction (AND)
        
    --Initialize the output notation (1 for low, 2 for med, 3 for high)
    output_notation <= (1, 1, 2, 2, 3, 3); -- low, low, med, med, high, high
    
    -- Initialize the rule conditions array
    rule_conditions_array <= ((1, 0, 0, 0, 0, 0),  -- Rule 1: L2L3 low 
                              (0, 0, 0, 1, 0, 0),  -- Rule 2: L7L8 low 
                              (0, 1, 0, 0, 0, 0),  -- Rule 3: L2L3 medium 
                              (0, 0, 0, 0, 1, 0),  -- Rule 4: L7L8 medium
                              (0, 0, 1, 0, 0, 0),  -- Rule 5: L2L3 high 
                              (0, 0, 0, 0, 0, 1)  -- Rule 6:  L7L8 high
                             ); 

    L2L3_input : entity work.input
        generic map (
            mf_num => mf_num_L2L3
        )
        port map (
            crisp_input => L2L3,
            reset => reset,
            mf_point1_array => L2L3_point1,
            mf_point2_array => L2L3_point2,
            mf_slope1_array => L2L3_slope1,
            mf_slope2_array => L2L3_slope2,
            membership_degrees => L2L3_mf_degrees
        );
        
    L7L8_input : entity work.input
        generic map (
            mf_num => mf_num_L7L8
        )
        port map (
            crisp_input => L7L8,
            reset => reset,
            mf_point1_array => L7L8_point1,
            mf_point2_array => L7L8_point2,
            mf_slope1_array => L7L8_slope1,
            mf_slope2_array => L7L8_slope2,
            membership_degrees => L7L8_mf_degrees
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