library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Fuzzy_Package.ALL;

entity Output is
  generic ( 
    output_num : natural := 3
  );
  Port ( 
    output_mf_values : in rule_outputs(0 to output_num-1);
    singleton_values : in singletons(0 to output_num-1);
    crisp_output : out std_logic_vector(7 downto 0)
  );
end Output;

architecture Behavioral of Output is
begin
    -- Concurrent signal assignment for crisp output
    crisp_output <= Defuzzification(output_mf_values, singleton_values);
    
end Behavioral;
