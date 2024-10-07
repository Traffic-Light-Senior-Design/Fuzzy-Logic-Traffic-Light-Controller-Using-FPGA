library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Membership_Package.ALL;

entity Fuzzy_Controller is
    port(
        room_temperature : in std_logic_vector(7 downto 0);
        heater_output : out std_logic_vector(7 downto 0);
        reset : in std_logic -- Add a reset input
    );
end Fuzzy_Controller;

architecture Behavioral of Fuzzy_Controller is
    -- Membership function structures for Low, Medium, and High temperature
    signal temperature_MFs : membership_functions(0 to 2); -- Three membership functions: Low, Medium, High
    
    -- Fuzzy outputs for the heater: Low, Medium, and High heater output states
    signal heater_singletons : singletons(0 to 2) := (x"05", x"14", x"23"); -- Singleton values for Low, Medium, and High
    
    -- Membership degrees for the temperature input
    signal membership_degrees : member_outputs(0 to 2); -- Three outputs, for Low, Medium, and High
    
    -- Fuzzy rule outputs
    signal s_rule_outputs : rule_outputs(0 to 2); -- Three outputs, for Low, Medium, and High heater state

begin
    -- Step 1: Define membership functions for Low, Medium, and High temperature
    process(room_temperature)
        -- Use variables to store the membership degrees and rule outputs
        variable v_membership_degrees : member_outputs(0 to 2); -- Variable for membership degrees
        variable v_rule_outputs : rule_outputs(0 to 2);         -- Variable for rule outputs
    begin
        -- Low temperature (0 to 50 degrees, triangular)
        temperature_MFs(0).name    <= low;
        temperature_MFs(0).point1  <= std_logic_vector(to_unsigned(0, 8));   -- Starts at 0 degrees
        temperature_MFs(0).slope1  <= std_logic_vector(to_unsigned(51, 8));   -- Slope up to peak (1/50)
        temperature_MFs(0).point2  <= std_logic_vector(to_unsigned(5, 8));  -- Peak at 50 degrees
        temperature_MFs(0).slope2  <= std_logic_vector(to_unsigned(51, 8));   -- Slope down to 0 after 50 degrees

        -- Medium temperature (25 to 75 degrees, trapezoidal)
        temperature_MFs(1).name    <= med;
        temperature_MFs(1).point1  <= std_logic_vector(to_unsigned(5, 8));  -- Starts at 25 degrees
        temperature_MFs(1).slope1  <= std_logic_vector(to_unsigned(26, 8));  -- Slope up to flat at 50 degrees
        temperature_MFs(1).point2  <= std_logic_vector(to_unsigned(25, 8));  -- Flat ends at 75 degrees
        temperature_MFs(1).slope2  <= std_logic_vector(to_unsigned(26, 8));   -- Slope down after 75 degrees

        -- High temperature (50 to 100 degrees, triangular)
        temperature_MFs(2).name    <= high;
        temperature_MFs(2).point1  <= std_logic_vector(to_unsigned(30, 8));  -- Starts at 50 degrees
        temperature_MFs(2).slope1  <= std_logic_vector(to_unsigned(51, 8));   -- Slope up to peak (1/50)
        temperature_MFs(2).point2  <= std_logic_vector(to_unsigned(35, 8)); -- Peak at 100 degrees
        temperature_MFs(2).slope2  <= std_logic_vector(to_unsigned(51, 8));   -- Slope down after 100 degrees

        -- Step 2: Fuzzification
        v_membership_degrees := Membership_Fuzzification(room_temperature, temperature_MFs);

        -- Debugging: Report the membership degrees for Low, Medium, and High temperature
        report "Membership Degrees at temperature " & integer'image(to_integer(unsigned(room_temperature))) & ": " &
               "Low: " & integer'image(to_integer(unsigned(v_membership_degrees(0)))) & 
               ", Medium: " & integer'image(to_integer(unsigned(v_membership_degrees(1)))) &
               ", High: " & integer'image(to_integer(unsigned(v_membership_degrees(2))));

        -- Step 3: Apply fuzzy rules based on fuzzified values
        -- Rule 1: IF temperature is low, THEN heater is high
        v_rule_outputs(0) := v_membership_degrees(0);  -- Low temperature -> High heater output

        -- Rule 2: IF temperature is medium, THEN heater is medium
        v_rule_outputs(1) := v_membership_degrees(1);  -- Medium temperature -> Medium heater output

        -- Rule 3: IF temperature is high, THEN heater is low
        v_rule_outputs(2) := v_membership_degrees(2);  -- High temperature -> Low heater output

        -- Step 4: Defuzzification to get a crisp output for the heater
        heater_output <= Defuzzification(v_rule_outputs, heater_singletons);

        -- Assign the final results to the signals for future reference (if needed)
        membership_degrees <= v_membership_degrees;
        s_rule_outputs <= v_rule_outputs;
    end process;

end Behavioral;

