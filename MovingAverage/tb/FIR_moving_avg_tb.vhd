library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity FIR_moving_avg_tb is
end FIR_moving_avg_tb;

architecture sim of FIR_moving_avg_tb is

  -- Define the sample and filtered sample path (generated with the octave script)
  constant SAMPLE_PATH          : string := "./ADC_sample.dat";
  constant FILTERED_SAMPLE_PATH : string := "./ADC_sample_filtered.dat";

  constant clk_hz : integer := 100e6;
  constant clk_period : time := 1 sec / clk_hz;

  signal clk : std_logic := '1';
  signal rst : std_logic := '1';

  signal sample_in         : std_logic_vector(15 downto 0) := (others => '0');
  signal sample_ready_puls : std_logic := '0';
  signal filtered_sample   : std_logic_vector(15 downto 0) := (others => '0');
  signal filtered_ready    : std_logic := '0';

begin

  clk <= not clk after clk_period / 2;

  DUT : entity work.FIR_moving_avg(rtl)
  port map (
    clk => clk,
    rst => rst,

    sample_in         => sample_in,
    sample_ready_puls => sample_ready_puls,

    filtered_ready    => filtered_ready,
    filtered_sample   => filtered_sample
  );

  -- Read the ADC sample data and send them to the filter
  READFILE_PROC : process(clk)
    variable line_v : line;
    file read_file : text open read_mode is SAMPLE_PATH;
    variable read_integer : integer := 0;
    variable div : integer := 0;
  begin
    if rising_edge(clk) then
      sample_ready_puls <= '0';
      
      if rst = '1' then
        sample_ready_puls <= '0';
        read_integer      := 0;
      elsif div > 5 then  -- slow down the sample reading
        div := 0;
        if not endfile(read_file) then 
          readline(read_file, line_v);
          read(line_v, read_integer);
          report integer'image(read_integer);
          sample_in <= std_logic_vector(to_unsigned(read_integer, sample_in'length));
          sample_ready_puls <= '1';
        end if;
      else
        div := div + 1;
      end if;
    end if;
  end process;

  RST_PROC : process
  begin
    wait for clk_period * 2;
    rst <= '0';
  end process;

  -- Automatically compare the result of the VHDL moving average
  -- with the result of the FILTER function from octave
  COMP_PROC : process(clk)
    variable line_v        : line;
    file read_file         : text open read_mode is FILTERED_SAMPLE_PATH;
    variable read_integer  : integer := 0;
    variable filtered_ready_prev : std_logic := '0';
  begin
    if rising_edge(clk) then
      if rst = '1' then
        read_integer := 0;
      elsif filtered_ready = '1' and filtered_ready_prev = '0' then
        if not endfile(read_file) then 
          readline(read_file, line_v);
          read(line_v, read_integer);
          
          -- Compare moving_average output with octave's filter output
          if read_integer /=  to_integer(unsigned(filtered_sample)) then
            report "End simulation: the filtered data aren't matching." severity failure;
          end if;
        else
          report "End simulation: all samples have been tested." severity note;
        end if;
      end if;
    filtered_ready_prev := filtered_ready;
    end if;
  end process;

end architecture;