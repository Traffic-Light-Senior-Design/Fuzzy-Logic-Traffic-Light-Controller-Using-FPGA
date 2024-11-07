library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sequence_State_Machine_TB is
end Sequence_State_Machine_TB;

architecture Behavioral of Sequence_State_Machine_TB is

    -- Signals for the UUT
    signal L1, L2L3, L4, L5, L6, L7L8, L9 : std_logic_vector(7 downto 0);
    signal  L8L7_b_left, L8L7_b_right, L9_b_left, L9_b_right, L2L3_b_left, L2L3_b_right, L5L4_b_left, L5L4_b_right : std_logic;
    signal clk, reset : std_logic;
    signal N_lights, N_lights_left, S_lights, S_lights_left, E_lights, E_lights_left, W_lights, W_lights_left : std_logic_vector(2 downto 0);
    signal tx_tb : std_logic;  -- UART transmission signal

    -- Signals to observe green light durations from sequence controllers
    signal L1_gl, L2L3_L7L8_gl, L6_gl, L4_L5_gl, L9_gl : std_logic_vector(7 downto 0);

    -- Clock period definition
    constant clk_period : time := 40 ns; -- 25 MHz -> 40 ns clock period
    
    -- Clock divider constants for 1-second tick
    constant clk_divider : integer := 24999;  -- 25k clock cycles for 1ms. Allows for faster testing compared to 1s
    signal clk_count : integer := 0;
    signal tick : std_logic := '0';
    
    -- Signal to observe crosswalk timer bytes (array of four bytes)
    type byte_array is array (0 to 3) of std_logic_vector(7 downto 0);
    signal crosswalk_timer_bytes : byte_array;


begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: entity work.Sequence_State_Machine
        port map (
            L1 => L1,
            L2L3 => L2L3,
            L4 => L4,
            L5 => L5,
            L6 => L6,
            L7L8 => L7L8,
            L9 => L9,
            L8L7_b_left => L8L7_b_left,
            L8L7_b_right => L8L7_b_right,
            L9_b_left => L9_b_left, 
            L9_b_right => L9_b_right, 
            L2L3_b_left => L2L3_b_left, 
            L2L3_b_right => L2L3_b_right, 
            L5L4_b_left => L5L4_b_left,
            L5L4_b_right => L5L4_b_right,
            clk => clk,
            reset => reset,
            N_lights => N_lights,
            N_lights_left => N_lights_left,
            S_lights => S_lights,
            S_lights_left => S_lights_left,
            E_lights => E_lights,
            E_lights_left => E_lights_left,
            W_lights => W_lights,
            W_lights_left => W_lights_left,
            tx => tx_tb
        );

    -- Instantiate Sequence 1 (L1_Sequence_Controller)
    seq1_inst : entity work.L1_Sequence_Controller
        port map(
            L1 => L1,
            green_light_output => L1_gl,
            reset => reset
        );
    
    -- Instantiate Sequence 2 (L6_Sequence_Controller)
    seq2_inst : entity work.L6_Sequence_Controller
        port map(
            L6 => L6,
            green_light_output => L6_gl,
            reset => reset
        );
    
    -- Instantiate Sequence 3 (L2L3_L7L8_Sequence_Controller)
    seq3_inst : entity work.L2L3_L7L8_Sequence_Controller
        port map(
            L2L3 => L2L3,
            L7L8 => L7L8,
            green_light_output => L2L3_L7L8_gl,
            reset => reset
        );
    
    -- Instantiate Sequence 4 (L4_L5_Sequence_Controller)
    seq4_inst : entity work.L4_L5_Sequence_Controller
        port map(
            L4 => L4,
            L5 => L5,
            green_light_output => L4_L5_gl,
            reset => reset
        );
    
    -- Instantiate Sequence 5 (L9_Sequence_Controller)
    seq5_inst : entity work.L9_Sequence_Controller
        port map(
            L9 => L9,
            green_light_output => L9_gl,
            reset => reset
        );

    -- Clock process definition
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;
    
    -- Tick generation process (1-second tick based on clock divider)
    tick_process : process(clk)
    begin
        if rising_edge(clk) then
            if clk_count = clk_divider - 1 then
                clk_count <= 0;
                tick <= '1';  -- Toggle tick every second
            else
                clk_count <= clk_count + 1;
                tick <= '0';
            end if;
        end if;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Apply reset
        reset <= '1';
        wait for 100 us;
        reset <= '0';

        -- testing minimum times
--        L1 <= std_logic_vector(to_unsigned(0, 8));
--        L2L3 <= std_logic_vector(to_unsigned(0, 8));
--        L4 <= std_logic_vector(to_unsigned(0, 8));
--        L5 <= std_logic_vector(to_unsigned(0, 8));
--        L6 <= std_logic_vector(to_unsigned(0, 8));
--        L7L8 <= std_logic_vector(to_unsigned(0, 8));
--        L9 <= std_logic_vector(to_unsigned(0, 8));
        
        
        L1 <= std_logic_vector(to_unsigned(50, 8));
        L2L3 <= std_logic_vector(to_unsigned(75, 8));
        L4 <= std_logic_vector(to_unsigned(15, 8));
        L5 <= std_logic_vector(to_unsigned(38, 8));
        L6 <= std_logic_vector(to_unsigned(49, 8));
        L7L8 <= std_logic_vector(to_unsigned(69, 8));
        L9 <= std_logic_vector(to_unsigned(62, 8));
        
        -- Set all inputs with a mix of values, considering 33-66-99 deviations
--        L1 <= std_logic_vector(to_unsigned(33, 8));
--        L2L3 <= std_logic_vector(to_unsigned(60, 8));
--        L4 <= std_logic_vector(to_unsigned(99, 8));
--        L5 <= std_logic_vector(to_unsigned(50, 8));
--        L6 <= std_logic_vector(to_unsigned(66, 8));
--        L7L8 <= std_logic_vector(to_unsigned(70, 8));
--        L9 <= std_logic_vector(to_unsigned(80, 8));

        -- Run the simulation for a specific amount of time
        --wait for 100 sec;
        
        -- Finish simulation
        wait;
    end process;

end Behavioral;