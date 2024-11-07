library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Fuzzy_Package.ALL;

entity Sequence_State_Machine is
    Port (
        L1, L2L3, L4, L5, L6, L7L8, L9: in std_logic_vector(7 downto 0); -- sensor inputs
        L8L7_b_left, L8L7_b_right, L9_b_left, L9_b_right, L2L3_b_left, L2L3_b_right, L5L4_b_left, L5L4_b_right : in std_logic; --for the crosswalk buttons
        clk, reset : in std_logic;
        N_lights, N_lights_left : out std_logic_vector(2 downto 0); -- 3 bits (green, yellow, red)
        S_lights, S_lights_left : out std_logic_vector(2 downto 0); 
        E_lights, E_lights_left : out std_logic_vector(2 downto 0); 
        W_lights, W_lights_left : out std_logic_vector(2 downto 0);
        tx : out std_logic -- tx output sent to arduino for crosswalk timers
    );
end Sequence_State_Machine;

architecture Behavioral of Sequence_State_Machine is

    -- Define the states for the State Machine
    type state_type is (idle, L1_state, L2L3_L7L8_state, L6_state, L4_L5_state, L9_state, yellow_state, clearance_state);
    signal state_reg, state_next, prev_state : state_type; -- the current and next state of the FSM
    
    -- Counter to track the green light duration of each sequence, after which the sequence will change
    signal counter : unsigned(7 downto 0) := x"00"; -- unsigned so it can be incremented
    signal yellow_counter : unsigned(3 downto 0) := x"0"; -- small counter for yellow light duration
    signal clearance_counter : unsigned(3 downto 0) := x"0";

    -- Signal to hold the current green ligt output for the current sequence
    signal current_green_light : std_logic_vector (7 downto 0);
    
    -- signals for each sequences green light
    signal L1_gl, L2L3_L7L8_gl, L6_gl, L4_L5_gl, L9_gl: std_logic_vector(7 downto 0);
    
    -- Constant for yellow light duration
    constant yellow_duration : unsigned(3 downto 0) := "0101"; -- 5 clock cycles for yellow light
    constant clearance_duration : unsigned(3 downto 0) := x"1"; -- 1 clock cycle clearance time
    
    -- Clock divider signals
    signal tick : std_logic := '0'; -- 1 Hz signal (1 second tick)
    signal clk_divider_counter : unsigned(24 downto 0) := (others => '0'); -- 25-bit counter to divide 25 MHz to 1 Hz
    
    --signals for the crosswalk timer input bytes
    signal crosswalk_timer_bytes : byte_array := (others => (others => '0')); --4 bytes, 1 for each side of the intersection
    
    -- Signals for detecting changes in crosswalk timer inputs
    signal previous_crosswalk_timer_bytes : byte_array := (others => (others => '0'));
    signal reset_internal : std_logic := '0'; --trigger to reset crosswalk timer after each change
    
begin

    -- Clock Divider Process to generate 1 Hz tick from 25 MHz clock
    process(clk, reset)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                clk_divider_counter <= (others => '0');
                tick <= '0';
            else
                if clk_divider_counter = 24999999 then -- 25 million clock cycles for 1 Hz
                    clk_divider_counter <= (others => '0');
                    tick <= '1'; -- Toggle tick signal every second
                    report "Tick toggled";
                else
                    clk_divider_counter <= clk_divider_counter + 1;
                    tick <= '0'; -- tick will be high only for a single clock cycle, low the rest
                end if;
            end if;
        end if;
    end process;
    
    -- Process to detect changes in crosswalk_timer_bytes and pulse reset
    process(clk)
    begin
        if rising_edge(clk) then
            if crosswalk_timer_bytes /= previous_crosswalk_timer_bytes then
                -- Change detected, set reset high for one cycle
                reset_internal <= '1';
                previous_crosswalk_timer_bytes <= crosswalk_timer_bytes;  -- Update to current value
            else
                reset_internal <= '0';  -- Clear reset after one cycle
            end if;
        end if;
    end process;
    
    -- Sequential process to handle state change, reset, and counter
    process(clk, reset)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state_reg <= idle;
                prev_state <= idle;
                counter <= (others => '0');
                yellow_counter <= (others => '0');
                clearance_counter <= (others => '0');
            else
                
                -- only update state machine every second
                if (tick = '1') then
                    -- change to next state at every clock (next_state does not have to be different every clk cycle)
                    state_reg <= state_next;
                    
                    -- Only store the sequence states in prev_state
                    if state_reg /= yellow_state and state_reg /= clearance_state then
                        prev_state <= state_reg;
                    end if;
                    
                    -- Only increment the green light when its not yellow
                    if state_reg /= yellow_state and state_reg /= clearance_state then
                        -- increment the counter for the green light until it reaches the whole GL duration
                        if counter < unsigned(current_green_light) then
                            counter <= counter + 1;
                        else
                            counter <= (others => '0');
                        end if;
                        report "Green light counter: " & integer'image(to_integer(counter));
                    end if;
                    
                    -- Increment the yellow light counter during yellow state
                    if state_reg = yellow_state then
                        if yellow_counter < yellow_duration then
                            yellow_counter <= yellow_counter + 1;
                        else
                            yellow_counter <= (others => '0');
                        end if;
                        report "Yellow light counter: " & integer'image(to_integer(yellow_counter));
                    end if;
                    
                    -- Increment the clearance counter during clearance state
                    if state_reg = clearance_state then
                        if clearance_counter < clearance_duration then
                            clearance_counter <= clearance_counter + 1;
                        else
                            clearance_counter <= (others => '0');
                        end if;
                        report "Clearance light counter: " & integer'image(to_integer(clearance_counter));
                    end if;
                    
                end if;
                
            end if;
        end if;
    end process;
    
    -- Combinational state changing process
    -- When one sequence's green light duration is over, move to the next.
    -- It follows a specific order of sequences
    process(tick)
    begin
        -- Default next state is to remain in the current state
        state_next <= state_reg;

        -- Handle state transitions
        case state_reg is
            when idle =>
                current_green_light <= (others => '0');
                state_next <= L1_state;

            when L1_state =>
                current_green_light <= L1_gl;
                if counter = unsigned(L1_gl) then
                    state_next <= yellow_state; -- Transition to yellow state
                end if;

            when L6_state =>
                current_green_light <= L6_gl; 
                if counter = unsigned(L6_gl) then
                    state_next <= yellow_state;
                end if;

            when L2L3_L7L8_state =>
                current_green_light <= L2L3_L7L8_gl;
                if counter = unsigned(L2L3_L7L8_gl) then
                    state_next <= yellow_state;
                end if;

            when L4_L5_state =>
                current_green_light <= L4_L5_gl;
                if counter = unsigned(L4_L5_gl) then
                    state_next <= yellow_state;
                end if;

            when L9_state =>
                current_green_light <= L9_gl;
                if counter = unsigned(L9_gl) then
                    state_next <= yellow_state;
                end if;

            -- Yellow light state
            when yellow_state =>
                current_green_light <= (others => '0'); -- No green light in yellow state
                if yellow_counter = yellow_duration then
                    state_next <= clearance_state; -- Move to clearance after yellow
                end if;
            
            -- clearance all red light state
            when clearance_state =>
                current_green_light <= (others => '0'); -- No green light in clearance state
                if clearance_counter = clearance_duration then
                    case prev_state is
                        when L1_state =>
                            state_next <= L6_state;
                        when L6_state =>
                            state_next <= L2L3_L7L8_state;
                        when L2L3_L7L8_state =>
                            state_next <= L4_L5_state;
                        when L4_L5_state =>
                            state_next <= L9_state;
                        when L9_state =>
                            state_next <= L1_state;
                        when others =>
                            state_next <= idle; -- In case something goes wrong
                    end case;
                end if;
        end case;
    end process;
    
    -- Combinational Output traffic lights based on sequence ("green", "yellow", "red")
    process(tick)
    begin
        case state_reg is
            -- all lights are off
            when idle =>
                N_lights <= b"000";
                W_lights <= b"000";
                S_lights <= b"000";
                E_lights <= b"000";
                N_lights_left <= b"000";
                W_lights_left <= b"000";
                S_lights_left <= b"000";
                E_lights_left <= b"000";      
            -- North left turn light is green
            when L1_state =>
                N_lights <= b"001";
                W_lights <= b"001";
                S_lights <= b"001";
                E_lights <= b"001";
                N_lights_left <= b"100";
                W_lights_left <= b"001";
                S_lights_left <= b"001";
                E_lights_left <= b"001";
            -- South left turn light is green
            when L6_state =>
                N_lights <= b"001";
                W_lights <= b"001";
                S_lights <= b"001";
                E_lights <= b"001";
                N_lights_left <= b"001";
                W_lights_left <= b"001";
                S_lights_left <= b"100";
                E_lights_left <= b"001";
            -- North and South facing lights are green
            when L2L3_L7L8_state =>
                N_lights <= b"100";
                W_lights <= b"001";
                S_lights <= b"100";
                E_lights <= b"001";
                N_lights_left <= b"001";
                W_lights_left <= b"001";
                S_lights_left <= b"001";
                E_lights_left <= b"001";
            -- West facing lights and West left turn light are green
            when L4_L5_state =>
                N_lights <= b"001";
                W_lights <= b"100";
                S_lights <= b"001";
                E_lights <= b"001";
                N_lights_left <= b"001";
                W_lights_left <= b"100";
                S_lights_left <= b"001";
                E_lights_left <= b"001";       
            -- East facing light and East left turn light are green
            when L9_state =>
                N_lights <= b"001";
                W_lights <= b"001";
                S_lights <= b"001";
                E_lights <= b"100";
                N_lights_left <= b"001";
                W_lights_left <= b"001";
                S_lights_left <= b"001";
                E_lights_left <= b"100";
            -- All lights are red during clearance
            when clearance_state =>
                N_lights <= b"001"; -- Red
                W_lights <= b"001";
                S_lights <= b"001";
                E_lights <= b"001";
                N_lights_left <= b"001";
                W_lights_left <= b"001";
                S_lights_left <= b"001";
                E_lights_left <= b"001";
            when yellow_state =>
                -- Set yellow lights only for the lights that were green in the previous state
                case prev_state is
                    -- Yellow after L1_state
                    when L1_state =>
                        N_lights <= b"001"; 
                        W_lights <= b"001"; 
                        S_lights <= b"001"; 
                        E_lights <= b"001"; 
                        N_lights_left <= b"010"; 
                        W_lights_left <= b"001"; 
                        S_lights_left <= b"001"; 
                        E_lights_left <= b"001"; 
            
                    -- Yellow after L6_state
                    when L6_state =>
                        N_lights <= b"001"; 
                        W_lights <= b"001"; 
                        S_lights <= b"001"; 
                        E_lights <= b"001"; 
                        N_lights_left <= b"001"; 
                        W_lights_left <= b"001"; 
                        S_lights_left <= b"010"; 
                        E_lights_left <= b"001"; 
            
                    -- Yellow after L2L3_L7L8_state
                    when L2L3_L7L8_state =>
                        N_lights <= b"010"; 
                        W_lights <= b"001"; 
                        S_lights <= b"010"; 
                        E_lights <= b"001"; 
                        N_lights_left <= b"001"; 
                        W_lights_left <= b"001"; 
                        S_lights_left <= b"001"; 
                        E_lights_left <= b"001"; 
            
                    -- Yellow after L4_L5_state
                    when L4_L5_state =>
                        N_lights <= b"001"; 
                        W_lights <= b"010"; 
                        S_lights <= b"001"; 
                        E_lights <= b"001"; 
                        N_lights_left <= b"001"; 
                        W_lights_left <= b"010"; 
                        S_lights_left <= b"001"; 
                        E_lights_left <= b"001"; 
            
                    -- Yellow after L9_state
                    when L9_state =>
                        N_lights <= b"001";
                        W_lights <= b"001"; 
                        S_lights <= b"001"; 
                        E_lights <= b"010"; 
                        N_lights_left <= b"001"; 
                        W_lights_left <= b"001"; 
                        S_lights_left <= b"001";
                        E_lights_left <= b"010";
            
                    when others =>
                        N_lights <= (others => '0');
                        W_lights <= (others => '0');
                        S_lights <= (others => '0');
                        E_lights <= (others => '0');
                        N_lights_left <= (others => '0');
                        W_lights_left <= (others => '0');
                        S_lights_left <= (others => '0');
                        E_lights_left <= (others => '0');
                end case; 
  
        end case;
    end process;
    
    -- Combinational Output process for the crosswalk timers
    process(state_reg)
    begin
        case state_reg is
            -- all lights are off
            when idle =>
                -- Crosswalk timers
                crosswalk_timer_bytes(0) <= (others => '0');
                crosswalk_timer_bytes(1) <= (others => '0');
                crosswalk_timer_bytes(2) <= (others => '0');
                crosswalk_timer_bytes(3) <= (others => '0');      
            -- North left turn light is green
            when L1_state =>
                -- Crosswalk timers: in front of L4L5 and L6L7L8
                crosswalk_timer_bytes(0) <= (others => '0');
                crosswalk_timer_bytes(1) <= current_green_light;
                crosswalk_timer_bytes(2) <= current_green_light;
                crosswalk_timer_bytes(3) <= (others => '0');  
            -- South left turn light is green
            when L6_state =>
                -- Crosswalk timers: in front of L1L2L3 and L9
                crosswalk_timer_bytes(0) <= current_green_light;
                crosswalk_timer_bytes(1) <= (others => '0');
                crosswalk_timer_bytes(2) <= (others => '0');
                crosswalk_timer_bytes(3) <= current_green_light;       
            -- North and South facing lights are green
            when L2L3_L7L8_state =>
                -- Crosswalk timers
                crosswalk_timer_bytes(0) <= (others => '0');
                crosswalk_timer_bytes(1) <= (others => '0');
                crosswalk_timer_bytes(2) <= (others => '0');
                crosswalk_timer_bytes(3) <= (others => '0'); 
            -- West facing lights and West left turn light are green
            when L4_L5_state =>
                -- Crosswalk timers
                crosswalk_timer_bytes(0) <= (others => '0');
                crosswalk_timer_bytes(1) <= (others => '0');
                crosswalk_timer_bytes(2) <= (others => '0');
                crosswalk_timer_bytes(3) <= (others => '0');           
            -- East facing light and East left turn light are green
            when L9_state =>
                -- Crosswalk timers
                crosswalk_timer_bytes(0) <= (others => '0');
                crosswalk_timer_bytes(1) <= (others => '0');
                crosswalk_timer_bytes(2) <= (others => '0');
                crosswalk_timer_bytes(3) <= (others => '0'); 
            -- All lights are red during clearance
            when clearance_state =>
                -- Crosswalk timers
                crosswalk_timer_bytes(0) <= (others => '0');
                crosswalk_timer_bytes(1) <= (others => '0');
                crosswalk_timer_bytes(2) <= (others => '0');
                crosswalk_timer_bytes(3) <= (others => '0');  
            when yellow_state =>
                -- Crosswalk timers
                crosswalk_timer_bytes(0) <= (others => '0');
                crosswalk_timer_bytes(1) <= (others => '0');
                crosswalk_timer_bytes(2) <= (others => '0');
                crosswalk_timer_bytes(3) <= (others => '0');    
        end case;
    end process;
    
    
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
    
    -- Instantiate the Crosswalk Timer Module
    crosswalk : entity work.UART_TEST_Top
        port map(
            clk => clk,
            reset => reset_internal,
            input_byte1 => crosswalk_timer_bytes(0), -- crosswalk in front of L9
            input_byte2 => crosswalk_timer_bytes(1), -- crosswalk in front of L6-L7-L8
            input_byte3 => crosswalk_timer_bytes(2), -- crosswalk in front of L4-L5
            input_byte4 => crosswalk_timer_bytes(3), -- crosswalk in front of L1-L2-L3
            tx => tx
        );

end Behavioral;