-- Testbench


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity tb_pwm is
end;
 
architecture testbench of tb_pwm is
 
    component PWM is
        Generic (
            num_bits    : integer := 8);
        Port (
            enable		: in std_logic;
            clk			: in std_logic;
            duty_cycle	: in std_logic_vector(num_bits - 1 downto 0);
            pwm_out 	: out std_logic);
    end component;
 
    constant num_bits			: integer := 8;
    
    signal pwm_out_sim			: std_logic := '0';
    signal duty_cycle_sim		: std_logic_vector(num_bits-1 downto 0) := (others => '0');
    signal clk_sim       		: std_logic := '0';
    signal enable_sim		    : std_logic := '1';
    
    begin
    
        duty_cycle_sim <= "10000000";
        
        tb1 : PWM 
            generic map (
                num_bits => num_bits);
            port map (
                pwm_out => pwm_out_sim,
                duty_cycle => duty_cycle_sim,
                clk => clk_sim,
                enable => enable_sim);
            
        clk_proc : process
        begin
            wait for 10 ps;
            clk_sim <= not clk_sim;
        end process clk_proc;
        
        reset_proc : process
        begin
            wait for 1 ns;
            enable_sim <= '0';
        end process reset_proc;
	
end testbench;