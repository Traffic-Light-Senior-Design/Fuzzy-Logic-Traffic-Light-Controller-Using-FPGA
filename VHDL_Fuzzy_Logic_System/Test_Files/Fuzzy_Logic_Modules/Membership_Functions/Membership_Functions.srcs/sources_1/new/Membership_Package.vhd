library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package Membership_Package is

    -- Enumerated type that will contain all the membership
    -- function names (linguistic terms)
    type membership_names is (low, med, high, none);  
    
    -- This record defines the general structure
    -- that every membership function will follow.
    -- Point 1 is the starting point of the MF, usually with a Membership degree of 0.
    -- Slope 1 is the slope of the increasing part of the MF.
    -- Point 2 is where the flat segment at 1 ends, and the decreasing part begins.
    -- Slope 2 is the slope of the decreasing part of the MF.
    -- Name is the linguistic term given to the MF (like low, medium, high, etc.).
    type MF_structure is record
        name: membership_names;
        point1: std_logic_vector(7 downto 0);
        slope1: std_logic_vector(7 downto 0);
        point2: std_logic_vector(7 downto 0);
        slope2: std_logic_vector(7 downto 0);
    end record MF_structure;
    
    -- Array of Membership Functions.
    -- This array can hold however many MFs we need for an input.
    type membership_functions is array(natural range<>) of MF_structure;
    
    -- Array of the Membership degrees (fuzzy outputs)
    type member_outputs is array(natural range <>) of std_logic_vector(7 downto 0);
    
    -- Array of the singleton outputs for defuzzification
    type singletons is array (natural range <>) of std_logic_vector(7 downto 0);
    
    -- Array of the outputs produced by the rule base of the fuzzy logic
    type rule_outputs is array (natural range <>) of std_logic_vector(7 downto 0);
    
    -- Function Membership_Fuzzification takes a crisp input value and uses
    -- the points and slopes to calculate a fuzzy value for each MF.
    function Membership_Fuzzification (crisp_input: in std_logic_vector(7 downto 0); mf_array : membership_functions)
        return member_outputs; -- Returns an array of fuzzy outputs
    
    -- Simple helper function to return the minimum of two numbers
    function conjunction (a,b: in std_logic_vector(7 downto 0)) return std_logic_vector;
    
    -- Simple helper function to return the maximum of two numbers
    function disjunction (a,b: in std_logic_vector(7 downto 0)) return std_logic_vector;
    
    -- Three more functions to handle other types of fuzzy logic rules
    
    function all_AND_rule(inputs: member_outputs) return std_logic_vector;
    
    function all_OR_rule (inputs: member_outputs) return std_logic_vector;
    
    function mixed_AND_OR_rule (a, b, c, d: std_logic_vector(7 downto 0)) return std_logic_vector;
    
    -- Defuzzificatin method, using centroid method
    function Defuzzification (membership_degrees : rule_outputs; singleton : singletons) return std_logic_vector;

end package Membership_Package;

-- Now, let's dive into the actual logic of the functions and procedures.
package body Membership_Package is

    -- Membership_Fuzzification takes in a crisp input and calculates the fuzzy membership degree
    -- for each membership function in the array using the two points and two slopes approach.
    function Membership_Fuzzification (crisp_input: in std_logic_vector(7 downto 0); mf_array : membership_functions)
        return member_outputs is
        
        -- Starting with a default fuzzy output of 0 for each MF.
        variable fuzzy_output : std_logic_vector(7 downto 0) := x"00";
        
        -- We'll store the fuzzy membership degrees for each MF in this array.
        variable membership_values : member_outputs(mf_array' range) := (others => x"00");
        
        -- This variable will hold intermediate values during calculations, with extra bits to handle overflow.
        variable intermediate_value: unsigned(15 downto 0); -- Using 16 bits to prevent overflow during multiplication
        
    begin
        -- We need to loop through each membership function in the array to calculate its degree.
        for i in mf_array' range loop
            
            -- Case 1: If the input is less than Point1, we're in the region where the membership degree is zero.
            if(crisp_input < mf_array(i).point1) then
                fuzzy_output := x"00"; -- No membership here, so output is zero.
                
            -- Case 2: If the input is between Point1 and Point2, we're in the rising slope or flat part.
            -- We calculate the membership degree using the slope from Point1 to the peak (flat region at 1).
            elsif(crisp_input <= mf_array(i).point2) then
                -- Calculate how much the membership has increased from Point1 using the slope.
                intermediate_value := (unsigned(crisp_input) - unsigned(mf_array(i).point1)) * unsigned(mf_array(i).slope1);
                
                -- If the calculated value exceeds the maximum allowed (1), we cap it at 1 (0xFF).
                if intermediate_value > to_unsigned(16#FF#, 16) then
                    fuzzy_output := x"FF"; -- Cap at full membership (1).
                else
                    -- Otherwise, we assign the calculated value, which gives us the fuzzy output between 0 and 1.
                    fuzzy_output := std_logic_vector(intermediate_value(7 downto 0)); -- Rising part
                end if;
                
            -- Case 3: If the input is greater than Point2, we're in the decreasing slope region.
            else
                -- Now we need to decrease the membership from 1 using the slope for the falling edge.
                intermediate_value := (unsigned(crisp_input) - unsigned(mf_array(i).point2)) * unsigned(mf_array(i).slope2);
                
                -- Make sure we don't go below zero. If the intermediate value is too large, we cap it at zero.
                if intermediate_value > to_unsigned(16#FF#, 16) then
                    fuzzy_output := x"00"; -- Membership goes back to zero.
                else
                    -- Otherwise, we subtract from the maximum value (1) to get the decreasing membership degree.
                    fuzzy_output := std_logic_vector(x"FF" - intermediate_value(7 downto 0)); -- Falling part
                end if;
            end if;
            
            -- Store the fuzzy output for this MF in the array of outputs.
            membership_values(i) := fuzzy_output;
        end loop;
        
        -- Return all the calculated membership degrees.
        return membership_values;
    end Membership_Fuzzification;

    -- Simple minimum function: returns the smaller of two 8-bit values in std_logic_vector type.
    function conjunction (a,b: in std_logic_vector(7 downto 0)) return std_logic_vector is
    begin
        return std_logic_vector(minimum(unsigned(a), unsigned(b)));
    end conjunction;

    -- Simple maximum function: returns the larger of two 8-bit values in std_logic_vector type.
    function disjunction (a,b: in std_logic_vector(7 downto 0)) return std_logic_vector is
    begin
        return std_logic_vector(maximum(unsigned(a), unsigned(b)));
    end disjunction;
    
    -- function that will handle rules that have multiple number of ANDs.
    -- uses array and loop to do a minimum (conjunction) of every membership degree
    -- for each membership function.
    function all_AND_rule(inputs: member_outputs) return std_logic_vector is
        variable rule_output : std_logic_vector(7 downto 0) := x"FF";
    begin
        for i in 0 to inputs'length - 1 loop
            rule_output := conjunction(rule_output, inputs(i));
        end loop;
        return rule_output;
    end all_AND_rule;
    
    -- function that will handle rules that have multiple number of ORs.
    -- uses array and loop to do a maximum (disjunction) of every membership degree
    -- for each membership function.
    function all_OR_rule (inputs: member_outputs) return std_logic_vector is
        variable rule_output : std_logic_vector(7 downto 0) := x"00";
    begin
        for i in 0 to inputs'length - 1 loop
            rule_output := disjunction(rule_output, inputs(i));
        end loop;
        return rule_output;
    end all_OR_rule;
    
    -- function that will handle (A AND B) OR (C AND D)
    function mixed_AND_OR_rule (a, b, c, d: std_logic_vector(7 downto 0)) return std_logic_vector is
        variable and_1, and_2, rule_output: std_logic_vector(7 downto 0);
    begin
        -- apply the ANDs first
        and_1 := conjunction(a,b);
        and_2 := conjunction(c,d);
        
        -- apply the OR
        rule_output := disjunction(and_1, and_2);
        return rule_output;
    end;
    
    -- function that will convert the fuzzy outputs to a crisp output usable by external peripherals
    -- This is done using the center of gravity (Area) method that takes the weighted average of all the outputs
    function Defuzzification (membership_degrees : rule_outputs; singleton : singletons) return std_logic_vector is
        variable final_output : std_logic_vector(7 downto 0); -- this is the final crisp output
        variable product : unsigned (15 downto 0) := (others => '0'); -- Initialize product to 0
        variable sum : unsigned (7 downto 0) := (others => '0');      -- Initialize sum to 0
    begin
        -- Loop through all membership degrees and calculate the weighted sum
        for i in singleton'range loop
            product := product + (unsigned(membership_degrees(i)) * unsigned(singleton(i))); -- Weighted sum
            sum := sum + unsigned(membership_degrees(i)); -- Sum of membership degrees
            
            -- Debugging: Report product and sum values during calculation
            report "Product for index " & integer'image(i) & ": " & integer'image(to_integer(product));
            report "Sum after index " & integer'image(i) & ": " & integer'image(to_integer(sum));
            
        end loop;
        
        -- Avoid division by zero if sum is zero
        if sum = 0 then
            final_output := (others => '0');  -- Default to 0 if no rules are activated
        else
            final_output := std_logic_vector(resize(product / sum, 8)); -- Calculate crisp output
            
            -- Debugging: Report final output
            report "Final Output (Weighted Average): " & integer'image(to_integer(unsigned(final_output)));
        end if;
        
        return final_output;
    end function;


end package body Membership_Package;
