library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Fuzzy_Package.ALL;

-- ##############################################################################
-- # Module: rule_base
-- # Description:
-- # The 'rule_base' module implements a fuzzy logic rule evaluation system that 
-- # handles multiple rules, each defined by a set of conditions and outputs.
-- # The module uses arrays and matrices to define the structure of the rules:
-- #   - 'rule_type_array' specifies whether each rule is an AND (conjunction) or 
-- #     OR (disjunction) operation.
-- #   - 'rule_conditions_array' contains the conditions for each rule, indicating 
-- #     which input membership degrees are relevant to each rule.
-- #   - 'output_notation' maps each rule to a specific output membership function.
-- # 
-- # The module evaluates the rules by performing conjunctions or disjunctions 
-- # on the input membership degrees and stores the results in 'rule_output'. 
-- # It then combines the results of rules that share the same output membership 
-- # function into 'combined_outputs'.
-- #
-- # Input/Output:
-- #   - Inputs:
-- #     - 'rule_type_array': Array that specifies whether each rule is AND (0) or OR (1).
-- #     - 'rule_conditions_array': Matrix defining the conditions (inputs) for each rule.
-- #     - 'output_notation': Array that maps rules to their respective output membership functions.
-- #     - 'membership_degrees': Array of input membership degrees from the fuzzification process.
-- #     - 'reset': Resets the outputs when asserted.
-- #   - Outputs:
-- #     - 'rule_output': Array of outputs corresponding to the evaluation of each rule.
-- #     - 'combined_outputs': Array of combined outputs, where rules sharing the same output 
-- #       membership function are aggregated using disjunction.
-- #
-- # How it works:
-- #   - Each rule is evaluated individually based on its specified conditions and rule type (AND/OR).
-- #   - The results of the rule evaluations are stored in 'rule_output'.
-- #   - For rules that share the same output membership function, the outputs are combined using 
-- #     disjunction (OR) and stored in 'combined_outputs'.
-- ##############################################################################


entity rule_base is
  generic (
    rule_num : natural := 3;  -- Number of rules
    input_num : natural := 3;  -- Number of inputs/membership degrees
    final_num : natural := 3 -- Number of output membership functions
  );
  Port (
    rule_type_array : in integer_array(0 to rule_num-1);       -- 0 for AND, 1 for OR
    rule_conditions_array : in integer_matrix(0 to rule_num-1, 0 to input_num-1); -- Conditions for each rule
    output_notation : in integer_array(0 to rule_num-1); -- Maps each rule to its respective output (1 = Low, 2 = Medium, 3 = High)
    reset : in std_logic;
    membership_degrees : in member_outputs(0 to input_num-1);  -- Input membership degrees from the fuzzification process
    rule_output : out rule_outputs(0 to rule_num-1);         -- Outputs the actions taken after rule evaluation
    combined_outputs : out rule_outputs(0 to final_num-1)
  );
end rule_base;

architecture Behavioral of rule_base is

    -- Signal to store the rule outputs
    signal s_rule_outputs : rule_outputs(0 to rule_num-1);
    signal s_combined_outputs : rule_outputs(0 to final_num-1);

begin
    process(membership_degrees, reset)
        -- Temporary variable to store the outputs of the rules
        variable v_rule_outputs : rule_outputs(0 to rule_num-1);
        
        -- Temporary variables to store intermediate results
        variable current_result : std_logic_vector(7 downto 0);

    begin
        if reset = '1' then
            s_rule_outputs <= (others => (others => '0'));
        else
            -- Loop through each rule
            for i in 0 to rule_num-1 loop
                
                -- Initialize current_result based on the rule type (AND/OR)
                if rule_type_array(i) = 0 then
                    current_result := x"FF";  -- Start with max value for AND (conjunction)
                else
                    current_result := x"00";  -- Start with min value for OR (disjunction)
                end if;
    
                -- Loop through each input/membership degree for the current rule
                for j in 0 to input_num-1 loop
                    -- Check if the current rule considers this input
                    if rule_conditions_array(i, j) = 1 then
                        -- Apply conjunction or disjunction based on the rule type
                        if rule_type_array(i) = 0 then
                            -- Conjunction (AND)
                            current_result := conjunction(current_result, membership_degrees(j));
                        else
                            -- Disjunction (OR)
                            current_result := disjunction(current_result, membership_degrees(j));
                        end if;
                    end if;
                end loop;
    
                -- Store the result of the rule
                v_rule_outputs(i) := current_result;
                
            end loop;
    
            -- Assign the computed rule outputs to the output signal
            s_rule_outputs <= v_rule_outputs;

        end if;
    end process;
    
    process (s_rule_outputs, reset)
        variable v_combined_outputs:  rule_outputs(0 to final_num-1); -- This is where the temp disjunction outputs will be stored
    begin
        
        if (reset = '1') then
            s_combined_outputs <= (others => (others => '0'));
        else 
            -- loop through each output membership function
            k_init: for k in 0 to final_num-1 loop
                --initialize all the combined_outputs to 0 first for the disjunction
                v_combined_outputs(k) := x"00";     
            end loop  k_init; 
            
            -- loop through each output membership function
            for k in 0 to final_num-1 loop
                
                -- loop through each rule output and do disjunction for rules that share the same output membership function
                for i in 0 to rule_num-1 loop
                    -- if the rule_output is mapped to its respectable output membership function
                    if output_notation(i) = k+1 then
                        
                        v_combined_outputs(k) := disjunction(v_combined_outputs(k), s_rule_outputs(i));
                        
                    end if;
                end loop;
                
            end loop;
            
            s_combined_outputs <= v_combined_outputs;
        end if;
    end process;

   
    -- assign the final outputs of the modules
    rule_output <= s_rule_outputs; 
    combined_outputs <= s_combined_outputs;
    
end Behavioral;