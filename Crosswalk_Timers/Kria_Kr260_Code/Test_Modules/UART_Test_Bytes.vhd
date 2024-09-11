library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_Test_Bytes is
  port(
    clk : in std_logic;    -- 25 MHz clock input
    tx  : out std_logic    -- UART TX output to be connected to Arduino RX
  );
end UART_Test_Bytes;

architecture Behavioral of UART_Test_Bytes is

  -- Sequence of bytes to transmit
  type byte_array is array (0 to 3) of std_logic_vector(7 downto 0);
  constant data_in : byte_array := (
    "00101101",  -- 0x2D or 45 in decimal
    "00100011",  -- 0x23 or 35 in decimal
    "00011001",  -- 0x19 or 25 in decimal
    "00001111"   -- 0x0F or 15 in decimal
  );    
    
  signal byte_index : integer range 0 to 3 := 0;  -- Index for the sequence
  signal test_byte  : std_logic_vector(7 downto 0) := data_in(0);  -- Current byte to transmit
  
  signal reset      : std_logic := '1';  -- Internal reset signal
  signal tx_start   : std_logic := '0';  -- Signal to start UART transmission
  signal tx_busy    : std_logic := '0';  -- Signal to track if UART is still transmitting
  signal delay_counter : integer := 0;   -- Counter to introduce delay

  signal byte_delay_counter : integer := 0;  -- Delay between each byte transmission
  signal byte_done : std_logic := '0';       -- Signal to track when a byte is done

  -- Initial delay before starting the first byte transmission
  signal initial_delay_counter : integer := 0;
  constant INITIAL_DELAY : integer := 100000;  -- Adjust this value for the initial delay

  -- UART transmission time for each byte (using baud rate 115200, assuming 10 bits per frame)
  constant BYTE_TRANSMISSION_DELAY : integer := 3500;  -- Delay between bytes
begin

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
        reset <= '0';  -- Release reset
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
        end if;
      end if;
    end if;
  end process;

end Behavioral;


-- 1 byte transmit module


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

--entity UART_Test_Bytes is
--  port(
--    clk : in std_logic;    -- 25 MHz clock input
--    tx  : out std_logic    -- UART TX output to be connected to Arduino RX
--  );
--end UART_Test_Bytes;

--architecture Behavioral of UART_Test_Bytes is

--  signal reset      : std_logic := '1';  -- Internal reset signal
--  signal tx_start   : std_logic := '0';
--  signal data_in    : std_logic_vector(7 downto 0) := "00100011";  -- Test byte 0x23 or 35 in decimal
--  signal tx_sent    : std_logic := '0';  -- Signal to ensure data is sent only once
--  signal delay_counter : integer := 0;  -- Counter to introduce delay

--begin

--  -- Instantiate the UART module (only using TX)
--  UUT_UART: entity work.UART
--    port map(
--      clk           => clk,
--      reset         => reset,
--      tx_start      => tx_start,
--      data_in       => data_in,
--      data_out      => open,     -- No RX used, leave it unconnected
--      rx_data_ready => open,     -- No RX used, leave it unconnected
--      rx            => '1',      -- Tie RX to '1' (idle state)
--      tx            => tx
--    );

--  -- Process to generate a reset pulse and start transmission
--  process(clk)
--  begin
--    if rising_edge(clk) then
--      if reset = '1' then
--        reset <= '0';  -- Release reset
--      elsif delay_counter < 1000000 then
--        delay_counter <= delay_counter + 1;  -- Introduce a delay before transmission
--      elsif tx_sent = '0' then
--        tx_start <= '1';  -- Start transmission after delay
--        tx_sent <= '1';   -- Mark data as sent
--      else
--        tx_start <= '0';  -- Clear tx_start signal
--      end if;
--    end if;
--  end process;
