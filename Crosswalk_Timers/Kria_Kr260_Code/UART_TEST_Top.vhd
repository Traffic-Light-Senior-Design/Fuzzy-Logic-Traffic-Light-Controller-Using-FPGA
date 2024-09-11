library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_TEST_Top is
  port(
    clk         : in std_logic;    -- 25 MHz clock input
    reset       : in std_logic;    -- Reset input
    input_byte1 : in std_logic_vector(7 downto 0);  -- First input byte
    input_byte2 : in std_logic_vector(7 downto 0);  -- Second input byte
    input_byte3 : in std_logic_vector(7 downto 0);  -- Third input byte
    input_byte4 : in std_logic_vector(7 downto 0);  -- Fourth input byte
    tx          : out std_logic    -- UART TX output to be connected to Arduino RX
  );
end UART_TEST_Top;

architecture Behavioral of UART_TEST_Top is

  -- Sequence of bytes to transmit, coming from inputs
  type byte_array is array (0 to 3) of std_logic_vector(7 downto 0);
  signal data_in : byte_array := (others => (others => '0'));  -- Initialize with zeroes
    
  --signal reset      : std_logic := '1';  -- Internal reset signal
  signal byte_index : integer range 0 to 3 := 0;  -- Index for the sequence
  signal test_byte  : std_logic_vector(7 downto 0) := data_in(0);  -- Current byte to transmit
  
  signal tx_start   : std_logic := '0';  -- Signal to start UART transmission
  signal delay_counter : integer := 0;   -- Counter to introduce delay
  signal byte_delay_counter : integer := 0;  -- Delay between each byte transmission
  signal byte_done : std_logic := '0';       -- Signal to track when a byte is done

  -- Initial delay before starting the first byte transmission
  signal initial_delay_counter : integer := 0;
  constant INITIAL_DELAY : integer := 100000;  -- Adjust this value for the initial delay

  -- UART transmission time for each byte (using baud rate 115200, assuming 10 bits per frame)
  constant BYTE_TRANSMISSION_DELAY : integer := 3500;  -- Delay between bytes

begin

  -- Assign the input bytes to the data_in array
  data_in(0) <= input_byte1;
  data_in(1) <= input_byte2;
  data_in(2) <= input_byte3;
  data_in(3) <= input_byte4;

  -- Instantiate the UART module (only using TX)
  UUT_UART: entity work.UART
    port map(
      clk           => clk,
      reset         => reset,
      tx_start      => tx_start,
      data_in       => test_byte,
      data_out      => open,     -- No RX used, leave it unconnected
      rx_data_ready => open,     -- No RX used, leave it unconnected
      rx            => '1',      -- Tie RX to '1' (idle state)
      tx            => tx
    );

  -- Process to handle the initial delay and control byte transmission
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        --reset <= '0';  -- Release reset
        byte_index <= 0;
        test_byte <= data_in(0);
        tx_start <= '0';
        byte_done <= '0';
        byte_delay_counter <= 0;
        initial_delay_counter <= 0;  -- Start counting the initial delay
      elsif initial_delay_counter < INITIAL_DELAY then
        -- Wait for the initial delay to finish
        initial_delay_counter <= initial_delay_counter + 1;
      elsif byte_done = '0' then
        if tx_start = '0' and byte_delay_counter = 0 then
          -- Start transmitting the current byte
          tx_start <= '1';
        elsif tx_start = '1' then
          -- Clear the start signal after 1 cycle
          tx_start <= '0';
          byte_delay_counter <= byte_delay_counter + 1;
        elsif byte_delay_counter < BYTE_TRANSMISSION_DELAY then
          -- Wait until the current byte is fully transmitted (based on the baud rate)
          byte_delay_counter <= byte_delay_counter + 1;
        else
          -- Transmission of the current byte is done
          byte_done <= '1';
          byte_delay_counter <= 0;
        end if;
      else
        -- Move to the next byte in the sequence after one byte has been transmitted
        if byte_index < 3 then
          byte_index <= byte_index + 1;
          test_byte <= data_in(byte_index + 1);  -- Load the next byte
          byte_done <= '0';  -- Prepare to transmit the next byte
        else
          -- All 4 bytes have been transmitted, end transmission
          byte_done <= '1';  -- Stop transmission after all bytes are sent
          --reset <= '1';
        end if;
      end if;
    end if;
  end process;

end Behavioral;


