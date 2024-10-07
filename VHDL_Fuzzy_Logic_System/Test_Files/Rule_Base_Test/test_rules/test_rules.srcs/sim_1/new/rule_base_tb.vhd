library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Fuzzy_Package.ALL;

-- Testbench entity
entity tb_rule_base is
end tb_rule_base;

-- Testbench architecture
architecture Behavioral of tb_rule_base is

    -- Constants for the test
    constant rule_num : natural := 4;
    constant input_num : natural := 4;
    constant final_num : natural := 3;

    -- Signals to connect to the rule_base module
    signal rule_type_array : integer_array(0 to rule_num-1);
    signal rule_conditions_array : integer_matrix(0 to rule_num-1, 0 to input_num-1);
    signal membership_degrees : member_outputs(0 to input_num-1);
    signal rule_output : rule_outputs(0 to rule_num-1);
    signal reset : std_logic := '0';
    signal output_notation: integer_array(0 to rule_num-1);
    signal combined_outputs : rule_outputs(0 to final_num-1);

    -- Instantiate the rule_base module
    component rule_base is
        generic (
            rule_num : natural := 4;
            input_num : natural := 4;
            final_num : natural := 3
        );
        Port (
            rule_type_array : in integer_array(0 to rule_num-1);
            rule_conditions_array : in integer_matrix(0 to rule_num-1, 0 to input_num-1);
            output_notation: in integer_array(0 to rule_num-1);
            reset : in std_logic;
            membership_degrees : in member_outputs(0 to input_num-1);
            rule_output : out rule_outputs(0 to rule_num-1);
            combined_outputs : out rule_outputs(0 to final_num-1)
        );
    end component;

begin

    -- Instantiate the rule_base with test values
    uut: rule_base
        generic map (
            rule_num => rule_num,
            input_num => input_num
        )
        port map (
            rule_type_array => rule_type_array,
            rule_conditions_array => rule_conditions_array,
            output_notation => output_notation,
            reset => reset,
            membership_degrees => membership_degrees,
            rule_output => rule_output,
            combined_outputs => combined_outputs
        );
   
    -- Test process
    process
    begin
        
        
        -- Apply reset for the first 10 ns
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
    
        -- Initialize the rule type array (0 for AND, 1 for OR)
        rule_type_array <= (0, 0, 0, 0);  -- All rules use conjunction (AND)
        
        --Initialize the output notation (1 for low, 2 for med, 3 for high)
        output_notation <= (1, 2, 2, 3); -- rule 2 and 3 share the same output mapping
    
        -- Initialize the rule conditions array
        rule_conditions_array <= ((1, 0, 1, 0),  -- Rule 1: Input 1 Low AND Input 2 Cold
                                  (0, 1, 1, 0),  -- Rule 2: Input 1 High AND Input 2 Cold
                                  (1, 0, 0, 1),  -- Rule 3: Input 1 Low AND Input 2 Hot
                                  (0, 1, 0, 1)); -- Rule 4: Input 1 High AND Input 2 Hot
    
        -- Wait for signals to stabilize after reset
        --wait for 10 ns;
    
        -- Set the membership degrees for both inputs
        membership_degrees <= (x"70", x"90", x"80", x"40");  -- Inputs 1_Low, 1_High, 2_Cold, 2_Hot
    
        -- Debugging: Check the membership degrees after they are set
        report "Membership Degrees at initialization: " & 
               "Input1_Low: " & integer'image(to_integer(unsigned(membership_degrees(0)))) & 
               ", Input1_High: " & integer'image(to_integer(unsigned(membership_degrees(1)))) & 
               ", Input2_Cold: " & integer'image(to_integer(unsigned(membership_degrees(2)))) & 
               ", Input2_Hot: " & integer'image(to_integer(unsigned(membership_degrees(3))));
    
        -- Wait for the simulation to stabilize
        wait for 10 ns;
    
        -- Display the results for the rule outputs
        report "Rule outputs: " & 
               "Rule 1: " & integer'image(to_integer(unsigned(rule_output(0)))) & 
               ", Rule 2: " & integer'image(to_integer(unsigned(rule_output(1)))) & 
               ", Rule 3: " & integer'image(to_integer(unsigned(rule_output(2)))) & 
               ", Rule 4: " & integer'image(to_integer(unsigned(rule_output(3))));
    
        -- End of simulation
        wait;
    end process;


end Behavioral;
