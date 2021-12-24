library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real."ceil";
use ieee.math_real."log2";

entity FIR_moving_avg is
  generic (
    ADC_RES    : integer := 16;
    FILT_DEPTH : integer := 16
  );
  port (
    clk : in std_logic;
    rst : in std_logic;

    sample_in         : in  std_logic_vector(ADC_RES - 1 downto 0);
    sample_ready_puls : in  std_logic;

    filtered_ready    : out std_logic := '0';
    filtered_sample   : out std_logic_vector(ADC_RES - 1 downto 0) := (others => '0')
  );
end FIR_moving_avg;

architecture rtl of FIR_moving_avg is

  constant filt_bit_width : integer := integer(ceil(log2(real(FILT_DEPTH))));

  type sample_buffer_t is array (FILT_DEPTH - 1 downto 0) of std_logic_vector(ADC_RES - 1 downto 0);
  signal sample_buffer : sample_buffer_t;

  signal sum : std_logic_vector(ADC_RES - 1 + filt_bit_width downto 0) := (others => '0');

begin

  -- Manage the moving array and its sum
  SUM_PROC : process(clk)
    variable sample_ready_puls_prev : std_logic := '0';
  begin
    if rising_edge(clk) then
      filtered_ready <= '0';

      if rst = '1' then
        sample_buffer  <= (others => (others => '0'));
      elsif sample_ready_puls = '1' and sample_ready_puls_prev = '0' then
        sample_buffer  <= sample_buffer(FILT_DEPTH - 2 downto 0) & sample_in;
        sum            <= std_logic_vector(unsigned(sum) + unsigned(sample_in) -  unsigned(sample_buffer(FILT_DEPTH - 1)));
        filtered_ready <= '1';
      end if;

      sample_ready_puls_prev := sample_ready_puls;
    end if;
  end process;

  -- average the sum by the filter width
  filtered_sample <= sum(sum'high downto filt_bit_width);

end architecture;