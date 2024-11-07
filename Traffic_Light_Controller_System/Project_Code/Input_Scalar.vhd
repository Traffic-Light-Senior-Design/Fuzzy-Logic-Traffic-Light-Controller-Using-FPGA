

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Input_Scalar is
  Port ( 
        -- Sensor inputs for each lane
        clk : in std_logic;
        L1_sensors : in std_logic_vector(2 downto 0); -- 3 sensors for L1
        L2L3_sensors : in std_logic_vector(2 downto 0); -- 3 sensors for L2L3
        L4_sensors : in std_logic_vector(1 downto 0); -- 2 sensors for L5
        L5_sensors : in std_logic_vector(1 downto 0); -- 2 sensors for L4
        L6_sensors : in std_logic_vector(2 downto 0); -- 3 sensors for L6
        L7L8_sensors : in std_logic_vector(2 downto 0); -- 3 sensors for L7L8
        L9_sensors : in std_logic_vector(1 downto 0); -- 2 sensors for L9
        L1, L2L3, L4, L5, L6, L7L8, L9: out std_logic_vector(7 downto 0)
  );
end Input_Scalar;

architecture Behavioral of Input_Scalar is

    -- Signals for sensor sums in unsigned
    signal L1_sensor_sum, L2L3_sensor_sum, L5_sensor_sum, L4_sensor_sum : unsigned(7 downto 0); 
    signal L6_sensor_sum, L7L8_sensor_sum, L9_sensor_sum : unsigned(7 downto 0);

begin


    -- This is for scaling the sensor 1 bit inputs to the 0-100 universe of discourse range for the fuzzy inputs
    process(L1_sensors, L2L3_sensors, L4_sensors, L5_sensors, L6_sensors, L7L8_sensors, L9_sensors)
    begin
        
        if L1_sensors = "110" then
            L1_sensor_sum <= to_unsigned(33, 8);
        elsif L1_sensors = "100" then
            L1_sensor_sum <= to_unsigned(66, 8);
        elsif L1_sensors = "000" then
            L1_sensor_sum <= to_unsigned(99, 8);
        else
            L1_sensor_sum <= to_unsigned(0, 8);  -- Default case if no match
        end if;
        
        if L2L3_sensors = "10" then
            L2L3_sensor_sum <= to_unsigned(50, 8);
        elsif L2L3_sensors = "00" then
            L2L3_sensor_sum <= to_unsigned(100, 8);
        else
            L2L3_sensor_sum <= to_unsigned(0, 8);  -- Default case if no match
        end if;
        
        if L4_sensors = "10" then
            L4_sensor_sum <= to_unsigned(50, 8);
        elsif L4_sensors = "00" then
            L4_sensor_sum <= to_unsigned(100, 8);
        else
            L4_sensor_sum <= to_unsigned(0, 8);  -- Default case if no match
        end if;
        
        if L5_sensors = "10" then
            L5_sensor_sum <= to_unsigned(50, 8);
        elsif L5_sensors = "00" then
            L5_sensor_sum <= to_unsigned(100, 8);
        else
            L5_sensor_sum <= to_unsigned(0, 8);  -- Default case if no match
        end if;
        
        if L6_sensors = "110" then
            L6_sensor_sum <= to_unsigned(33, 8);
        elsif L6_sensors = "100" then
            L6_sensor_sum <= to_unsigned(66, 8);
        elsif L6_sensors = "000" then
            L6_sensor_sum <= to_unsigned(99, 8);
        else
            L6_sensor_sum <= to_unsigned(0, 8);  -- Default case if no match
        end if;
        
        if L7L8_sensors = "110" then
            L7L8_sensor_sum <= to_unsigned(33, 8);
        elsif L7L8_sensors = "100" then
            L7L8_sensor_sum <= to_unsigned(66, 8);
        elsif L7L8_sensors = "000" then
            L7L8_sensor_sum <= to_unsigned(99, 8);
        else
            L7L8_sensor_sum <= to_unsigned(0, 8);  -- Default case if no match
        end if;
        
        if L9_sensors = "10" then
            L9_sensor_sum <= to_unsigned(50, 8);
        elsif L9_sensors = "00" then
            L9_sensor_sum <= to_unsigned(100, 8);
        else
            L9_sensor_sum <= to_unsigned(0, 8);  -- Default case if no match
        end if;
        
    end process;


    -- Convert the unsigned sums to std_logic_vector
    L1 <= std_logic_vector(L1_sensor_sum);
    L2L3 <= std_logic_vector(L2L3_sensor_sum);
    L5 <= std_logic_vector(L5_sensor_sum);
    L4 <= std_logic_vector(L4_sensor_sum);
    L6 <= std_logic_vector(L6_sensor_sum);
    L7L8 <= std_logic_vector(L7L8_sensor_sum);
    L9 <= std_logic_vector(L9_sensor_sum);

end Behavioral;