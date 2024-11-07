library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Final_Top is
  Port ( 
    clk_25MHz : in std_logic; -- 25MHZ clock input
    pmod1 : in std_logic_vector(7 downto 0); -- button inputs for crosswalk
    rpi_gpio : in std_logic_vector (26 downto 0); -- sensor inputs for cars
    pmod2, pmod3, pmod4 : out std_logic_vector(7 downto 0) -- traffic light outputs
  );
end Final_Top;

architecture Behavioral of Final_Top is

    -- Internal signals for lane inputs, these will be scaled through the Input_Scalar module
    signal L1, L2L3, L4, L5, L6, L7L8, L9 : std_logic_vector(7 downto 0);
    signal E_lights_temp, E_lights_left_temp: std_logic_vector(2 downto 0);
    
    -- Intermediary signals for the debounced sensor outputs
    signal L1_sensors_debounced   : std_logic_vector(2 downto 0);
    signal L2L3_sensors_debounced : std_logic_vector(2 downto 0);
    signal L4_sensors_debounced   : std_logic_vector(1 downto 0);
    signal L5_sensors_debounced   : std_logic_vector(1 downto 0);
    signal L6_sensors_debounced   : std_logic_vector(2 downto 0);
    signal L7L8_sensors_debounced : std_logic_vector(2 downto 0);
    signal L9_sensors_debounced   : std_logic_vector(1 downto 0);

    
begin
    
    -- Instantiate debounce filters for each sensor input group with 25 clock cycle limit
    debounce_L1 : entity work.Debounce_Filter
        generic map (
            DEBOUNCE_LIMIT => 75000000,
            NUM_SENSORS    => 3
        )
        port map (
            i_clk      => clk_25MHz,
            i_Bouncy   => rpi_gpio(2 downto 0),
            o_Debounced => L1_sensors_debounced
        );

    debounce_L2L3 : entity work.Debounce_Filter
        generic map (
            DEBOUNCE_LIMIT => 75000000,
            NUM_SENSORS    => 3
        )
        port map (
            i_clk      => clk_25MHz,
            i_Bouncy   => rpi_gpio(5 downto 3),
            o_Debounced => L2L3_sensors_debounced
        );

    debounce_L4 : entity work.Debounce_Filter
        generic map (
            DEBOUNCE_LIMIT => 75000000,
            NUM_SENSORS    => 2
        )
        port map (
            i_clk      => clk_25MHz,
            i_Bouncy   => rpi_gpio(7 downto 6),
            o_Debounced => L4_sensors_debounced
        );

    debounce_L5 : entity work.Debounce_Filter
        generic map (
            DEBOUNCE_LIMIT => 75000000,
            NUM_SENSORS    => 2
        )
        port map (
            i_clk      => clk_25MHz,
            i_Bouncy   => rpi_gpio(9 downto 8),
            o_Debounced => L5_sensors_debounced
        );

    debounce_L6 : entity work.Debounce_Filter
        generic map (
            DEBOUNCE_LIMIT => 75000000,
            NUM_SENSORS    => 3
        )
        port map (
            i_clk      => clk_25MHz,
            i_Bouncy   => rpi_gpio(12 downto 10),
            o_Debounced => L6_sensors_debounced 
        );

    debounce_L7L8 : entity work.Debounce_Filter
        generic map (
            DEBOUNCE_LIMIT => 75000000,
            NUM_SENSORS    => 3
        )
        port map (
            i_clk      => clk_25MHz,
            i_Bouncy   => rpi_gpio(15 downto 13),
            o_Debounced => L7L8_sensors_debounced
        );

    debounce_L9 : entity work.Debounce_Filter
        generic map (
            DEBOUNCE_LIMIT => 75000000,
            NUM_SENSORS    => 2
        )
        port map (
            i_clk      => clk_25MHz,
            i_Bouncy   => rpi_gpio(17 downto 16),
            o_Debounced => L9_sensors_debounced
        );

    
    -- Instantiate the Input_Scalar module which will return the scaled car inputs for the fuzzy logic
    Scaling_top_module: entity work.Input_Scalar
        port map (
            clk => clk_25MHz,
            L1_sensors => L1_sensors_debounced,
            L2L3_sensors => L2L3_sensors_debounced,
            L4_sensors => L4_sensors_debounced,
            L5_sensors => L5_sensors_debounced,
            L6_sensors => L6_sensors_debounced,
            L7L8_sensors => L7L8_sensors_debounced,
            L9_sensors => L9_sensors_debounced,
            L1 => L1,
            L2L3 => L2L3,
            L4 => L4,
            L5 => L5,
            L6 => L6,
            L7L8 => L7L8,
            L9 => L9
        );
        
    -- Instantiate the Sequence_State_Machine and map the sensor-processed inputs
    seq_state_machine_inst : entity work.Sequence_State_Machine
        port map (
            L1 => L1,
            L2L3 => L2L3,
            L4 => L4,
            L5 => L5,
            L6 => L6,
            L7L8 => L7L8,
            L9 => L9,
            L8L7_b_left => pmod1(2),
            L8L7_b_right => pmod1(6),
            L9_b_left => pmod1(1), 
            L9_b_right => pmod1(5), 
            L2L3_b_left => pmod1(0), 
            L2L3_b_right => pmod1(4), 
            L5L4_b_left => pmod1(3),
            L5L4_b_right => pmod1(7),
            clk => clk_25MHz,
            reset => rpi_gpio(18),
            N_lights => pmod2(2 downto 0),
            N_lights_left => pmod2(6 downto 4),
            S_lights => pmod4(2 downto 0), 
            S_lights_left => pmod4(6 downto 4),
            E_lights => E_lights_temp,
            E_lights_left => E_lights_left_temp,
            W_lights => pmod3(2 downto 0),
            W_lights_left => pmod3(6 downto 4),
            tx => pmod4(3)
        );

    pmod2(3) <= E_lights_temp(0);
    pmod2(7) <= E_lights_temp(1);
    pmod3(3) <= E_lights_temp(2);


end Behavioral;