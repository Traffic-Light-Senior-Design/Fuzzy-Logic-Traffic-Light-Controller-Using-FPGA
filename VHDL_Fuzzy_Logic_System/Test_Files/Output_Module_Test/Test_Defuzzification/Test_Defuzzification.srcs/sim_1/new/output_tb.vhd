library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Fuzzy_Package.ALL;

entity output_tb is
end output_tb;

architecture Behavioral of output_tb is
    
    constant output_num : natural := 3;
    
    component Output is
      generic ( 
        output_num : natural := 3
      );
      Port ( 
        output_mf_values : in rule_outputs(0 to output_num-1);
        singleton_values : in singletons(0 to output_num-1);
        crisp_output : out std_logic_vector(7 downto 0)
      );
    end component Output;
    
    signal output_mf_values_tb : rule_outputs(0 to output_num-1);
    signal singleton_values_tb : singletons(0 to output_num-1);
    signal crisp_output_tb : std_logic_vector(7 downto 0);
    
begin

    uut: Output 
        generic map (
            output_num => output_num
        )
        port map (
            output_mf_values => output_mf_values_tb,
            singleton_values => singleton_values_tb,
            crisp_output => crisp_output_tb
        );
        
    process
    begin
        -- assign test values for the output membership function degress
        output_mf_values_tb <= (x"70",x"80",x"40");
        
        report "Output Membership Degrees: Low = " & integer'image(to_integer(unsigned(output_mf_values_tb(0)))) &
           ", Medium = " & integer'image(to_integer(unsigned(output_mf_values_tb(1)))) &
           ", High = " & integer'image(to_integer(unsigned(output_mf_values_tb(2))));
        
        
        -- assign test singleton values on the universe of discourse
        singleton_values_tb <= (x"05", x"32", x"64");  -- Low = 5, Medium = 50, High = 100
        
        report "Singleton Values: Low = " & integer'image(to_integer(unsigned(singleton_values_tb(0)))) &
           ", Medium = " & integer'image(to_integer(unsigned(singleton_values_tb(1)))) &
           ", High = " & integer'image(to_integer(unsigned(singleton_values_tb(2))));   
        
        wait;
    end process;

    process (crisp_output_tb)
    begin
        report "Final Crisp Output: " & integer'image(to_integer(unsigned(crisp_output_tb)));
    end process;
    

end Behavioral;
