library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Fuzzy_Controller_tb is
end Fuzzy_Controller_tb;

architecture Behavioral of Fuzzy_Controller_tb is
    -- Signals for the UUT
    signal room_temperature : std_logic_vector(7 downto 0);
    signal heater_output : std_logic_vector(7 downto 0);
    signal reset : std_logic := '0';  -- Add reset signal

    signal clk : std_logic := '0';  -- Clock signal

    component Fuzzy_Controller
        port(
            room_temperature : in std_logic_vector(7 downto 0);
            heater_output : out std_logic_vector(7 downto 0);
            reset : in std_logic
        );
    end component;
    
begin
    -- Clock process
    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;
    
    -- Instantiate UUT
    UUT : Fuzzy_Controller
        port map(
            room_temperature => room_temperature,
            heater_output => heater_output,
            reset => reset
        );
    
    -- Testbench process to apply stimuli
    stim_proc : process
    begin
        -- Apply reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';  -- Deassert reset after 10 ns
        
        -- Temperature = 7 degrees
        room_temperature <= x"07";  -- 2 degrees
        wait for 10 ns;
        
        -- Temperature = 8 degrees
        room_temperature <= x"08";  -- 20 degrees
        wait for 10 ns;
        
        -- Temperature = 9 degrees
        room_temperature <= x"09";  -- 20 degrees
        wait for 10 ns;
        
        -- Temperature = 32 degrees
        room_temperature <= x"20";  -- 50 degrees
        wait for 10 ns;
        
        -- Temperature = 33 degrees
        room_temperature <= x"21";  -- 50 degrees
        wait for 10 ns;
        
        -- Finish simulation
        wait;
    end process;
end Behavioral;

