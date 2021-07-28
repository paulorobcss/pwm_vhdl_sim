-- PWM
-- Baseado no curso do Jordan Christman

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
    generic (
        num_bits    : integer := 8);
    port (
        enable      : in std_logic;
        clk         : in std_logic;
        duty_cycle  : in std_logic_vector(num_bits-1 downto 0);
        pwm_out     : out std_logic);
end pwm;

architecture behavior of pwm is

    constant max_freq_count : integer   := (2 ** num_bits);
    constant pwm_step       : integer   := (2 ** num_bits);

    signal pwm_value        : std_logic := '0';
    signal freq_count       : integer range 0 to max_freq_count    := 0;
    signal pwm_count        : integer range 0 to (2 ** num_bits)   := 0;
    signal max_pwm_count    : integer range 0 to (2 ** num_bits)   := 0;
    signal pwm_step_count   : integer range 0 to max_freq_count    := 0;

    begin
        max_pwm_count <= to_integer(unsigned(duty_cycle));
        pwm_out <= pwm_value;
        
        freq_counter : process(clk)
        begin
            if (rising_edge(clk)) then
                if (enable = '0') then
                    if (freq_count < max_freq_count) then
                        freq_count <= freq_count + 1;
                        if (pwm_count < pwm_step) then
                            if (pwm_step_count < max_pwm_count) then
                                pwm_value <= '1';
                                pwm_step_count <= pwm_step_count + 1;
                            else
                                pwm_value <= '0';
                            end if;
                        else
                            pwm_step_count <= 0;
                            pwm_count <= 0;
                        end if;
                    else
                        freq_count <= 0;
                        pwm_step_count <= 0;
                    end if;
                    if (pwm_count < max_pwm_count) then
                        pwm_count <= pwm_count + 1;
                    else
                        pwm_count <= 0;
                    end if;
                else
                    pwm_value <= '0';
                end if;
            end if;
        end process freq_counter;

end behavior;