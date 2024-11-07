library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debounce_Filter is
    generic (
        DEBOUNCE_LIMIT : integer := 250000;  -- Debounce limit for delay, adjust based on clock frequency
        NUM_SENSORS    : integer := 7        -- Number of sensor inputs
    );
    port (
        i_clk       : in std_logic;
        i_Bouncy    : in std_logic_vector(NUM_SENSORS-1 downto 0);  -- Sensor inputs
        o_Debounced : out std_logic_vector(NUM_SENSORS-1 downto 0)  -- Debounced outputs
    );
end Debounce_Filter;

architecture Behavioral of Debounce_Filter is
    -- Internal counters and states for each sensor input
    type counter_array is array(NUM_SENSORS-1 downto 0) of integer range 0 to DEBOUNCE_LIMIT - 1;
    signal r_Count : counter_array := (others => 0);
    signal r_State : std_logic_vector(NUM_SENSORS-1 downto 0) := (others => '0');
begin

    -- Process to debounce each sensor input
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            for i in 0 to NUM_SENSORS - 1 loop
                -- First condition: Input is not stable, increment counter
                if (i_Bouncy(i) /= r_State(i)) and (r_Count(i) < DEBOUNCE_LIMIT - 1) then
                    r_Count(i) <= r_Count(i) + 1;
                -- Second condition: Input stable for debounce limit, update state
                elsif r_Count(i) = DEBOUNCE_LIMIT - 1 then
                    r_State(i) <= i_Bouncy(i);  -- Update stable state after debounce time
                    r_Count(i) <= 0;           -- Reset counter
                else
                    r_Count(i) <= 0;           -- Reset counter if input remains stable
                end if;
            end loop;
        end if;
    end process;

    -- Output the debounced state
    o_Debounced <= r_State;

end Behavioral;
