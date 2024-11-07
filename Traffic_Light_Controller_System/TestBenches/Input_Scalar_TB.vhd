library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Input_Scalar_TB is
end Input_Scalar_TB;

architecture Behavioral of Input_Scalar_TB is

    -- Signals for the Unit Under Test (UUT)
    signal clk : std_logic := '0';
    signal L1_sensors : std_logic_vector(2 downto 0);
    signal L2L3_sensors : std_logic_vector(2 downto 0); -- Updated to 3 sensors
    signal L4_sensors : std_logic_vector(1 downto 0);
    signal L5_sensors : std_logic_vector(1 downto 0);
    signal L6_sensors : std_logic_vector(2 downto 0);
    signal L7L8_sensors : std_logic_vector(2 downto 0);
    signal L9_sensors : std_logic_vector(1 downto 0);
    
    signal L1, L2L3, L4, L5, L6, L7L8, L9 : std_logic_vector(7 downto 0);

    -- Clock period definition
    constant clk_period : time := 20 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: entity work.Input_Scalar
        port map (
            clk => clk,
            L1_sensors => L1_sensors,
            L2L3_sensors => L2L3_sensors,
            L4_sensors => L4_sensors,
            L5_sensors => L5_sensors,
            L6_sensors => L6_sensors,
            L7L8_sensors => L7L8_sensors,
            L9_sensors => L9_sensors,
            L1 => L1,
            L2L3 => L2L3,
            L4 => L4,
            L5 => L5,
            L6 => L6,
            L7L8 => L7L8,
            L9 => L9
        );

    -- Clock process definition
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Test different sensor combinations and observe scaled output

        -- Test case 1: All sensors off
        L1_sensors <= "000"; L2L3_sensors <= "000"; L4_sensors <= "00"; 
        L5_sensors <= "00"; L6_sensors <= "000"; L7L8_sensors <= "000"; L9_sensors <= "00";
        wait for clk_period;

        -- Test case 2: Some sensors on
        L1_sensors <= "001"; L2L3_sensors <= "001"; L4_sensors <= "01"; 
        L5_sensors <= "01"; L6_sensors <= "011"; L7L8_sensors <= "111"; L9_sensors <= "11";
        wait for clk_period;

        -- Test case 3: Max sensors for each lane
        L1_sensors <= "111"; L2L3_sensors <= "111"; L4_sensors <= "11"; 
        L5_sensors <= "11"; L6_sensors <= "111"; L7L8_sensors <= "111"; L9_sensors <= "11";
        wait for clk_period;

        -- Test case 4: Random sensor values
        L1_sensors <= "011"; L2L3_sensors <= "010"; L4_sensors <= "01"; 
        L5_sensors <= "11"; L6_sensors <= "001"; L7L8_sensors <= "010"; L9_sensors <= "01";
        wait for clk_period;

        -- Finish simulation
        wait;
    end process;

end Behavioral;
