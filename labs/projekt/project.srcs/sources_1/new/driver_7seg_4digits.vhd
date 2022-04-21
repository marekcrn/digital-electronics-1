------------------------------------------------------------
--
-- Driver for 4-digit 7-segment display.
-- Nexys A7-50T, Vivado v2020.1.1, EDA Playground
--
-- Copyright (c) 2020-Present Tomas Fryza
-- Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------
-- Entity declaration for display driver
------------------------------------------------------------
entity driver_7seg_4digits is
    port(
        clk     : in  std_logic;
        reset   : in  std_logic;
        speed   : in  std_logic_vector(2 - 1 downto 0);
        -- 4-bit input value for decimal points
        dp_i    : in  std_logic_vector(8 - 1 downto 0);
        -- Decimal point for specific digit
        dp_o    : out std_logic;
        -- Cathode values for individual segments
        seg_o   : out std_logic_vector(8 - 1 downto 0);
        -- Common anode signals to individual displays
        dig_o   : out std_logic_vector(8 - 1 downto 0)
    );
end entity driver_7seg_4digits;

------------------------------------------------------------
-- Architecture declaration for display driver
------------------------------------------------------------
architecture Behavioral of driver_7seg_4digits is

    -- Internal clock enable
    signal s_en  : std_logic;
    -- Internal 2-bit counter for multiplexing 4 digits
    signal s_cnt : std_logic_vector(3 - 1 downto 0);
    -- Internal 4-bit value for 7-segment decoder
    signal s_hex : std_logic_vector(6 - 1 downto 0);
    
    signal s_cnt2 : unsigned(4 downto 0);
    
    signal data0_i : std_logic_vector(6 - 1 downto 0);
    signal data1_i : std_logic_vector(6 - 1 downto 0);
    signal data2_i : std_logic_vector(6 - 1 downto 0);
    signal data3_i : std_logic_vector(6 - 1 downto 0);
    signal data4_i : std_logic_vector(6 - 1 downto 0);
    signal data5_i : std_logic_vector(6 - 1 downto 0);
    signal data6_i : std_logic_vector(6 - 1 downto 0);
    signal data7_i : std_logic_vector(6 - 1 downto 0);
    
    type t_state is (S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,
                     S12,S13,S14,S15,S16,S17,S18,S19                    
                     );
    -- Define the signal that uses different states
    signal s_state : t_state;
    
    constant c_DELAY_08SEC : unsigned(4 downto 0) := b"1_0000";
    constant c_DELAY_04SEC : unsigned(4 downto 0) := b"0_1000";
    constant c_DELAY_02SEC : unsigned(4 downto 0) := b"0_0100";
    constant c_ZERO        : unsigned(4 downto 0) := b"0_0000";

begin
    --------------------------------------------------------
    -- Instance (copy) of clock_enable entity generates 
    -- an enable pulse every 4 ms
    clk_en0 : entity work.clock_enable
        generic map(
            g_MAX => 4
        )
        port map(
            clk => clk , -- WRITE YOUR CODE HERE
            reset => reset,-- WRITE YOUR CODE HERE
            ce_o  => s_en
        );

    --------------------------------------------------------
    -- Instance (copy) of cnt_up_down entity performs a 2-bit
    -- down counter
    bin_cnt0 : entity work.cnt_up_down
        generic map(
            g_CNT_Width => 3--- WRITE YOUR CODE HERE
        )
        port map(
            en_i => s_en,
            cnt_up_i =>'0',
            reset => reset,
            clk => clk,
            cnt_o =>s_cnt--- WRITE YOUR CODE HERE
        );

    --------------------------------------------------------
    -- Instance (copy) of hex_7seg entity performs a 7-segment
    -- display decoder
    hex2seg : entity work.hex_7seg
        port map(
            hex_i => s_hex,
            seg_o => seg_o
        );

    --------------------------------------------------------
    -- p_mux:
    -- A sequential process that implements a multiplexer for
    -- selecting data for a single digit, a decimal point 
    -- signal, and switches the common anodes of each display.
    --------------------------------------------------------
    p_mux : process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                s_hex <= data0_i;
                dp_o  <= dp_i(0);
                dig_o <= "11111110";
            else
                case s_cnt is
                
                    when "111" =>
                        s_hex <= data7_i;
                        dp_o  <= dp_i(7);
                        dig_o <= "01110111";
                    when "110" =>
                        s_hex <= data6_i;
                        dp_o  <= dp_i(6);
                        dig_o <= "10111111";
                        
                    when "101" =>
                        s_hex <= data5_i;
                        dp_o  <= dp_i(5);
                        dig_o <= "11011111";
                        
                    when "100" =>
                        s_hex <= data4_i;
                        dp_o  <= dp_i(4);
                        dig_o <= "11101111";
                
                    when "011" =>
                        s_hex <= data3_i;
                        dp_o  <= dp_i(3);
                        dig_o <= "11110111";

                    when "010" =>
                        s_hex <= data2_i;
                        dp_o  <= dp_i(2);
                        dig_o <= "11111011";

                    when "001" =>
                        s_hex <= data1_i;
                        dp_o  <= dp_i(1);
                        dig_o <= "11111101";

                    when "000" =>
                        s_hex <= data0_i;
                        dp_o  <= dp_i(0);
                        dig_o <= "11111110";
                end case;
            end if;
        end if;
    end process p_mux;
    
     p_states : process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then   -- Synchronous reset
                s_state <= S1;   -- Set initial state
                s_cnt2   <= c_ZERO;  -- Clear delay counter

            elsif (s_en = '1') then
                -- Every 250 ms, CASE checks the value of the s_state 
                -- variable and changes to the next state according 
                -- to the delay value.
                case s_state is

                    -- If the current state is STOP1, then wait 1 sec
                    -- and move to the next GO_WAIT state.
                    when S1 =>
                        -- Count up to c_DELAY_1SEC
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;

                    when S2 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;
                        
                    when S3 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;
                        
                    when S4 =>
                       if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;
                        
                    when S5 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;

                    when S6 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;

                    when S7 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;

                    when S8 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;

                    when S9 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;

                    when S10 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;

                    when S11 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;

                    when S12 =>
                       if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;
                    
                    when S13 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;
 
                    when S14 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;
  
                    when S15 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;

                    when S16 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;
                        
                    when S17 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;
                    
                    when S18 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;
                    
                    when S19 =>
                        if (speed = "00") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                                
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;                      
                            end if;
                        
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;
                            end if;
                            
                        elsif (speed = "11") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_state <= S2;
                                s_cnt2 <= c_ZERO;  
                            end if; 
                        end if;
                                                
                    when others =>
                        s_state <= S1;
                        s_cnt2   <= c_ZERO;
                end case;
            end if; -- Synchronous reset
        end if; -- Rising edge
    end process p_states;
    
    p_output_fsm : process(s_state)
    begin
        case s_state is
            when S1 =>
                data0_i <= b"111101";
                data1_i <= b"111101";
                data2_i <= b"111101";
                data3_i <= b"111101";
                data4_i <= b"111101";
                data5_i <= b"111101";
                data6_i <= b"111101";
                data7_i <= b"111101";
                
            when S2 =>
                data0_i <= b"010001";
                data1_i <= b"111101";
                data2_i <= b"111101";
                data3_i <= b"111101";
                data4_i <= b"111101";
                data5_i <= b"111101";
                data6_i <= b"111101";
                data7_i <= b"111101";
                
            when S3 =>
                data0_i <= b"001110";
                data1_i <= b"010001";
                data2_i <= b"111101";
                data3_i <= b"111101";
                data4_i <= b"111101";
                data5_i <= b"111101";
                data6_i <= b"111101";
                data7_i <= b"111101";
                
            when S4 =>
                data0_i <= b"010101";
                data1_i <= b"001110";
                data2_i <= b"010001";
                data3_i <= b"111101";
                data4_i <= b"111101";
                data5_i <= b"111101";
                data6_i <= b"111101";
                data7_i <= b"111101";
                
            when S5 =>
                data0_i <= b"010101";
                data1_i <= b"010101";
                data2_i <= b"001110";
                data3_i <= b"010001";
                data4_i <= b"111101";
                data5_i <= b"111101";
                data6_i <= b"111101";
                data7_i <= b"111101";
                
            when S6 =>
                data0_i <= b"011000";
                data1_i <= b"010101";
                data2_i <= b"010101";
                data3_i <= b"001110";
                data4_i <= b"010001";
                data5_i <= b"111101";
                data6_i <= b"111101";
                data7_i <= b"111101";
                
            when S7 =>
                data0_i <= b"111101";
                data1_i <= b"011000";
                data2_i <= b"010101";
                data3_i <= b"010101";
                data4_i <= b"001110";
                data5_i <= b"010001";
                data6_i <= b"111101";
                data7_i <= b"111101";
                
            when S8 =>
                data0_i <= b"100000";
                data1_i <= b"111101";
                data2_i <= b"011000";
                data3_i <= b"010101";
                data4_i <= b"010101";
                data5_i <= b"001110";
                data6_i <= b"010001";
                data7_i <= b"111101";
                
            when S9 =>
                data0_i <= b"011000";
                data1_i <= b"100000";
                data2_i <= b"111101";
                data3_i <= b"011000";
                data4_i <= b"010101";
                data5_i <= b"010101";
                data6_i <= b"001110";
                data7_i <= b"010001";
                
            when S10 =>
                data0_i <= b"011011";
                data1_i <= b"011000";
                data2_i <= b"100000";
                data3_i <= b"111101";
                data4_i <= b"011000";
                data5_i <= b"010101";
                data6_i <= b"010101";
                data7_i <= b"001110";
                
            when S11 =>
                data0_i <= b"010101";
                data1_i <= b"011011";
                data2_i <= b"011000";
                data3_i <= b"100000";
                data4_i <= b"111101";
                data5_i <= b"011000";
                data6_i <= b"010101";
                data7_i <= b"010101";
                
            when S12 =>
                data0_i <= b"001101";
                data1_i <= b"010101";
                data2_i <= b"011011";
                data3_i <= b"011000";
                data4_i <= b"100000";
                data5_i <= b"111101";
                data6_i <= b"011000";
                data7_i <= b"010101";
                
            when S13 =>
                data0_i <= b"111101";
                data1_i <= b"001101";
                data2_i <= b"010101";
                data3_i <= b"011011";
                data4_i <= b"011000";
                data5_i <= b"100000";
                data6_i <= b"111101";
                data7_i <= b"011000";
                
            when S14 =>
                data0_i <= b"111101";
                data1_i <= b"111101";
                data2_i <= b"001101";
                data3_i <= b"010101";
                data4_i <= b"011011";
                data5_i <= b"011000";
                data6_i <= b"100000";
                data7_i <= b"111101";
                
            when S15 =>
                data0_i <= b"111101";
                data1_i <= b"111101";
                data2_i <= b"111101";
                data3_i <= b"001101";
                data4_i <= b"010101";
                data5_i <= b"011011";
                data6_i <= b"011000";
                data7_i <= b"100000";
                
            when S16 =>
                data0_i <= b"111101";
                data1_i <= b"111101";
                data2_i <= b"111101";
                data3_i <= b"111101";
                data4_i <= b"001101";
                data5_i <= b"010101";
                data6_i <= b"011011";
                data7_i <= b"011000";
                
            when S17 =>
                data0_i <= b"111101";
                data1_i <= b"111101";
                data2_i <= b"111101";
                data3_i <= b"111101";
                data4_i <= b"111101";
                data5_i <= b"001101";
                data6_i <= b"010101";
                data7_i <= b"011011";
                
            when S18 =>
                data0_i <= b"111101";
                data1_i <= b"111101";
                data2_i <= b"111101";
                data3_i <= b"111101";
                data4_i <= b"111101";
                data5_i <= b"111101";
                data6_i <= b"001101";
                data7_i <= b"010101";
                
            when S19 =>
                data0_i <= b"111101";
                data1_i <= b"111101";
                data2_i <= b"111101";
                data3_i <= b"111101";
                data4_i <= b"111101";
                data5_i <= b"111101";
                data6_i <= b"111101";
                data7_i <= b"001101";
        end case;
    end process p_output_fsm;

end architecture Behavioral;