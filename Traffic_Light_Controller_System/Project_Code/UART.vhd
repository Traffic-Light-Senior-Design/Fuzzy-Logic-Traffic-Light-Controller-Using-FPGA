library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;



entity UART is

  port(
    clk      : in std_logic;
    reset    : in std_logic;
    tx_start : in std_logic;

    data_in       : in  std_logic_vector (7 downto 0);
    data_out      : out std_logic_vector (7 downto 0);
    rx_data_ready : out std_logic;

    rx : in  std_logic;
    tx : out std_logic
    );
end UART;


architecture Behavioral of UART is

  component UART_TX
    port(
      clk         : in  std_logic;
      reset       : in  std_logic;
      tx_start    : in  std_logic;
      tx_data_in  : in  std_logic_vector (7 downto 0);
      tx_data_out : out std_logic
      );
  end component;


  component UART_RX
    port(
      clk           : in  std_logic;
      reset         : in  std_logic;
      rx_data_in    : in  std_logic;
      rx_data_ready : out std_logic;
      rx_data_out   : out std_logic_vector (7 downto 0)
      );
  end component;

begin

  transmitter : UART_TX
    port map(
      clk         => clk,
      reset       => reset,
      tx_start    => tx_start,
      tx_data_in  => data_in,
      tx_data_out => tx
      );


  receiver : UART_RX
    port map(
      clk           => clk,
      reset         => reset,
      rx_data_in    => rx,
      rx_data_ready => rx_data_ready,
      rx_data_out   => data_out
      );


end Behavioral;