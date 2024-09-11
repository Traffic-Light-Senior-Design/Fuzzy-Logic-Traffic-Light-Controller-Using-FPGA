
--  ( "00000000", "00000000", "00000000", "00000000" ); -- Base case, idle state
--  ( "00001011", "00001100", "00001101", "00001110" ); -- Example base set : 11, 12, 13, 14
--  ( "00010110", "00010111", "00011000", "00011001" ); -- Example for 1 sensor active : 22, 23, 24, 25
--  ( "00100001", "00100010", "00100011", "00100100" ); -- Example for 2 sensors active : 33, 34, 35, 36

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Top module with inputs to dynamically send crosswalk timer values based on input logic
entity UART_Byte_Transmitter is
  port(
    clk         : in  std_logic;                               -- 25 MHz clock input
    --reset       : in  std_logic;                               -- External reset input
    fuzzy_input : in  std_logic_vector(1 downto 0);            -- Fuzzy logic input indicating crosswalk timing logic
    tx          : out std_logic                                -- UART TX output
  );
end UART_Byte_Transmitter;

architecture Behavioral of UART_Byte_Transmitter is

  -- Sequence of bytes for different conditions based on fuzzy logic
  type byte_array is array (0 to 3) of std_logic_vector(7 downto 0);
  
  constant idle_bytes  : byte_array := ( "00000000", "00000000", "00000000", "00000000" ); -- Base case, idle state
  constant short_bytes : byte_array := ( "00001011", "00001100", "00001101", "00001110" ); -- Short pedestrian timer
  constant mid_bytes   : byte_array := ( "00010110", "00010111", "00011000", "00011001" ); -- Medium pedestrian timer
  constant long_bytes  : byte_array := ( "00100001", "00100010", "00100011", "00100100" ); -- Long pedestrian timer

  signal selected_bytes : byte_array := idle_bytes;  -- Signal to store the selected byte set
  signal tx_byte1 : std_logic_vector(7 downto 0);
  signal tx_byte2 : std_logic_vector(7 downto 0);
  signal tx_byte3 : std_logic_vector(7 downto 0);
  signal tx_byte4 : std_logic_vector(7 downto 0);
  
  signal reset : std_logic := '0';
  signal reset_trigger : std_logic := '0';  -- Temporary signal to trigger reset
  signal fuzzy_input_old : std_logic_vector(1 downto 0) := "00";  -- To track previous fuzzy input

begin

    process(clk)
    begin
        if rising_edge(clk) then
            -- Handle reset logic
            if reset_trigger = '1' then
                reset <= '1';  -- Trigger reset for one cycle
                reset_trigger <= '0';  -- Clear reset trigger after one cycle
            else
                reset <= '0';  -- Keep reset low otherwise
            end if;
    
            -- Handle fuzzy input change detection and set reset_trigger
            -- set reset everytime the input is changed.
            if fuzzy_input /= fuzzy_input_old then  -- Detect if the fuzzy input has changed
                case fuzzy_input is
                    when "00" =>
                        selected_bytes <= idle_bytes;
                        reset_trigger <= '1';  
                    when "01" =>
                        selected_bytes <= short_bytes;
                        reset_trigger <= '1';  
                    when "10" =>
                        selected_bytes <= mid_bytes;
                        reset_trigger <= '1';  
                    when "11" =>
                        selected_bytes <= long_bytes;
                        reset_trigger <= '1';  
                    when others =>
                        selected_bytes <= idle_bytes;
                        reset_trigger <= '1'; 
                end case;
                fuzzy_input_old <= fuzzy_input;  -- Update fuzzy_input_old with the new value
            end if;
        end if;
    end process;


  -- Assign selected bytes to be transmitted
  tx_byte1 <= selected_bytes(0);
  tx_byte2 <= selected_bytes(1);
  tx_byte3 <= selected_bytes(2);
  tx_byte4 <= selected_bytes(3);

  -- Instantiate the UART Test Module (which will send the 4 selected bytes continuously)
  UART_Test_Module: entity work.UART_TEST_Top
    port map(
      clk         => clk,
      reset       => reset,          -- Reset input
      input_byte1 => tx_byte1,       -- First byte selected based on fuzzy logic inputs
      input_byte2 => tx_byte2,       -- Second byte
      input_byte3 => tx_byte3,       -- Third byte
      input_byte4 => tx_byte4,       -- Fourth byte
      tx          => tx              -- UART TX output
    );

end Behavioral;

