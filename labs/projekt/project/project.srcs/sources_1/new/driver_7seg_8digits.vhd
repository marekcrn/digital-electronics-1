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
entity driver_7seg_8digits is
    port(
        clk        : in  std_logic;
        reset      : in  std_logic;
        speed      : in  std_logic_vector(2 - 1 downto 0);
        direction  : in  std_logic;
        
        dp_i  : in  std_logic_vector(8 - 1 downto 0);
        dp_o  : out std_logic;
        seg_o : out std_logic_vector(8 - 1 downto 0);
        dig_o : out std_logic_vector(8 - 1 downto 0)
    );
end entity driver_7seg_8digits;

------------------------------------------------------------
-- Architecture declaration for display driver
------------------------------------------------------------
architecture Behavioral of driver_7seg_8digits is

    signal s_en    : std_logic;
    signal s_cnt   : std_logic_vector(3 - 1 downto 0);
    signal s_cnt2  : unsigned(9 - 1 downto 0);
   
    signal s_hex   : String(1 to 1);
    signal data0_i : String(1 to 1);
    signal data1_i : String(1 to 1);
    signal data2_i : String(1 to 1);
    signal data3_i : String(1 to 1);
    signal data4_i : String(1 to 1);
    signal data5_i : String(1 to 1);
    signal data6_i : String(1 to 1);
    signal data7_i : String(1 to 1); 
    
    type t_state is (S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,
                     S12,S13,S14,S15,S16,S17,S18,S19,S20                    
                     );        
                                  
    signal s_state : t_state;
    
    constant c_DELAY_1SEC  : unsigned(9 - 1 downto 0) := b"0_01000000";
    constant c_DELAY_08SEC : unsigned(9 - 1 downto 0) := b"1_00000000";
    constant c_DELAY_04SEC : unsigned(9 - 1 downto 0) := b"0_10000000";
    constant c_DELAY_02SEC : unsigned(9 - 1 downto 0) := b"0_01000000";
    constant c_ZERO        : unsigned(9 - 1 downto 0) := b"0_00000000";
    
    constant c_string      : String(1 to 12) := "hello world!";
    constant c_space       : String(1 to 1) := " ";

begin
    --------------------------------------------------------
    -- Instance (copy) of clock_enable entity generates 
    -- an enable pulse every 4 ms
    clk_en0 : entity work.clock_enable
        generic map(
            g_MAX => 250000 --250000 for implementation; 1 for simulation
        )
        port map(
            clk => clk , 
            reset => reset,
            ce_o  => s_en
        );

    --------------------------------------------------------
    -- Instance (copy) of cnt_up_down entity performs a 3-bit
    -- down counter
    bin_cnt0 : entity work.cnt_up_down
        generic map(
            g_CNT_Width => 3
        )
        port map(
            en_i => s_en,
            cnt_up_i =>'0',
            reset => reset,
            clk => clk,
            cnt_o =>s_cnt
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
                        dig_o <= "01111111";
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
                        
                    when others =>
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
            if (reset = '1') then   
                s_state <= S1;   
                s_cnt2   <= c_ZERO;  

            elsif (s_en = '1') then               
                case s_state is            
                    when S1 =>            
                        if (speed = "11") then                            
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S2;
                                else
                                    s_state <= S20;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else                               
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S2;
                                else
                                    s_state <= S20;
                                end if;                     
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S2;
                                else
                                    s_state <= S20;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S2;
                                else
                                    s_state <= S20;
                                end if; 
                            end if; 
                        end if;

                    when S2 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S3;
                                else
                                    s_state <= S1;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S3;
                                else
                                    s_state <= S1;
                                end if;                     
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S3;
                                else
                                    s_state <= S1;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S3;
                                else
                                    s_state <= S1;
                                end if;  
                            end if; 
                        end if;
                        
                    when S3 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S4;
                                else
                                    s_state <= S2;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S4;
                                else
                                    s_state <= S2;
                                end if;                      
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S4;
                                else
                                    s_state <= S2;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S4;
                                else
                                    s_state <= S2;
                                end if; 
                            end if; 
                        end if;
                        
                    when S4 =>
                       if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S5;
                                else
                                    s_state <= S3;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S5;
                                else
                                    s_state <= S3;
                                end if;                     
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S5;
                                else
                                    s_state <= S3;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S5;
                                else
                                    s_state <= S3;
                                end if;  
                            end if; 
                        end if;
                        
                    when S5 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S6;
                                else
                                    s_state <= S4;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S6;
                                else
                                    s_state <= S4;
                                end if;                     
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S6;
                                else
                                    s_state <= S4;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S6;
                                else
                                    s_state <= S4;
                                end if;  
                            end if; 
                        end if;

                    when S6 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S7;
                                else
                                    s_state <= S5;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S7;
                                else
                                    s_state <= S5;
                                end if;                      
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S7;
                                else
                                    s_state <= S5;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO;  
                                if (direction = '0') then
                                    s_state <= S7;
                                else
                                    s_state <= S5;
                                end if;
                            end if; 
                        end if;

                    when S7 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S8;
                                else
                                    s_state <= S6;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S8;
                                else
                                    s_state <= S6;
                                end if;                     
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S8;
                                else
                                    s_state <= S6;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO;  
                                if (direction = '0') then
                                    s_state <= S8;
                                else
                                    s_state <= S6;
                                end if;
                            end if; 
                        end if;

                    when S8 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S9;
                                else
                                    s_state <= S7;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S9;
                                else
                                    s_state <= S7;
                                end if;                     
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S9;
                                else
                                    s_state <= S7;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S9;
                                else
                                    s_state <= S7;
                                end if; 
                            end if; 
                        end if;

                    when S9 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S10;
                                else
                                    s_state <= S8;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;  
                                if (direction = '0') then
                                    s_state <= S10;
                                else
                                    s_state <= S8;
                                end if;                    
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S10;
                                else
                                    s_state <= S8;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO;  
                                if (direction = '0') then
                                    s_state <= S10;
                                else
                                    s_state <= S8;
                                end if;
                            end if; 
                        end if;

                    when S10 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S11;
                                else
                                    s_state <= S9;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S11;
                                else
                                    s_state <= S9;
                                end if;                      
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S11;
                                else
                                    s_state <= S9;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO;  
                                if (direction = '0') then
                                    s_state <= S11;
                                else
                                    s_state <= S9;
                                end if;
                            end if; 
                        end if;

                    when S11 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S12;
                                else
                                    s_state <= S10;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S12;
                                else
                                    s_state <= S10;
                                end if;                      
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S12;
                                else
                                    s_state <= S10;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO;  
                                if (direction = '0') then
                                    s_state <= S12;
                                else
                                    s_state <= S10;
                                end if;
                            end if; 
                        end if;

                    when S12 =>
                       if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S13;
                                else
                                    s_state <= S11;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;  
                                if (direction = '0') then
                                    s_state <= S13;
                                else
                                    s_state <= S11;
                                end if;                    
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S13;
                                else
                                    s_state <= S11;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S13;
                                else
                                    s_state <= S11;
                                end if;  
                            end if; 
                        end if;
                    
                    when S13 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S14;
                                else
                                    s_state <= S12;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S14;
                                else
                                    s_state <= S12;
                                end if;                     
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S14;
                                else
                                    s_state <= S12;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO;  
                                if (direction = '0') then
                                    s_state <= S14;
                                else
                                    s_state <= S12;
                                end if;
                            end if; 
                        end if;
 
                    when S14 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S15;
                                else
                                    s_state <= S13;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;  
                                if (direction = '0') then
                                    s_state <= S15;
                                else
                                    s_state <= S13;
                                end if;                    
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S15;
                                else
                                    s_state <= S13;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO;  
                                if (direction = '0') then
                                    s_state <= S15;
                                else
                                    s_state <= S13;
                                end if;
                            end if; 
                        end if;
  
                    when S15 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S16;
                                else
                                    s_state <= S14;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;   
                                if (direction = '0') then
                                    s_state <= S16;
                                else
                                    s_state <= S14;
                                end if;                   
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S16;
                                else
                                    s_state <= S14;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S16;
                                else
                                    s_state <= S14;
                                end if; 
                            end if; 
                        end if;

                    when S16 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S17;
                                else
                                    s_state <= S15;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S17;
                                else
                                    s_state <= S15;
                                end if;                     
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S17;
                                else
                                    s_state <= S15;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S17;
                                else
                                    s_state <= S15;
                                end if; 
                            end if; 
                        end if;
                        
                    when S17 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S18;
                                else
                                    s_state <= S16;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S18;
                                else
                                    s_state <= S16;
                                end if;                      
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S18;
                                else
                                    s_state <= S16;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S18;
                                else
                                    s_state <= S16;
                                end if; 
                            end if; 
                        end if;
                    
                    when S18 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S19;
                                else
                                    s_state <= S17;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;  
                                if (direction = '0') then
                                    s_state <= S19;
                                else
                                    s_state <= S17;
                                end if;                    
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S19;
                                else
                                    s_state <= S17;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S19;
                                else
                                    s_state <= S17;
                                end if; 
                            end if; 
                        end if;
                    
                    when S19 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S20;
                                else
                                    s_state <= S18;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S20;
                                else
                                    s_state <= S18;
                                end if;                     
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S20;
                                else
                                    s_state <= S18;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S20;
                                else
                                    s_state <= S18;
                                end if; 
                            end if; 
                        end if;
                        
                    when S20 =>
                        if (speed = "11") then
                            if (s_cnt2 < c_DELAY_02SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S1;
                                else
                                    s_state <= S19;
                                end if;
                            end if;
                                
                        elsif (speed = "10") then
                            if (s_cnt2 < c_DELAY_04SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S1;
                                else
                                    s_state <= S19;
                                end if;                     
                            end if;
                        
                        elsif (speed = "01") then
                            if (s_cnt2 < c_DELAY_08SEC) then
                                s_cnt2 <= s_cnt2 + 5;
                            else
                                s_cnt2 <= c_ZERO;
                                if (direction = '0') then
                                    s_state <= S1;
                                else
                                    s_state <= S19;
                                end if;
                            end if;
                            
                        elsif (speed = "00") then
                            if (s_cnt2 < c_DELAY_1SEC) then
                                s_cnt2 <= s_cnt2 + 1;
                            else
                                s_cnt2 <= c_ZERO; 
                                if (direction = '0') then
                                    s_state <= S1;
                                else
                                    s_state <= S19;
                                end if; 
                            end if; 
                        end if;
                                                
                    when others =>
                        s_state <= S1;
                        s_cnt2   <= c_ZERO;
                end case;
            end if; 
        end if; 
    end process p_states;
    
    p_output_fsm : process(s_state)
    begin
        case s_state is
            when S1 =>
                data0_i <= c_space;
                data1_i <= c_space;
                data2_i <= c_space;
                data3_i <= c_space;
                data4_i <= c_space;
                data5_i <= c_space;
                data6_i <= c_space;
                data7_i <= c_space;
                
            when S2 =>
                data0_i <= c_string(1 to 1);
                data1_i <= c_space;
                data2_i <= c_space;
                data3_i <= c_space;
                data4_i <= c_space;
                data5_i <= c_space;
                data6_i <= c_space;
                data7_i <= c_space;
                
            when S3 =>
                data0_i <= c_string(2 to 2);
                data1_i <= c_string(1 to 1);
                data2_i <= c_space;
                data3_i <= c_space;
                data4_i <= c_space;
                data5_i <= c_space;
                data6_i <= c_space;
                data7_i <= c_space;
                
            when S4 =>
                data0_i <= c_string(3 to 3);
                data1_i <= c_string(2 to 2);
                data2_i <= c_string(1 to 1);
                data3_i <= c_space;
                data4_i <= c_space;
                data5_i <= c_space;
                data6_i <= c_space;
                data7_i <= c_space;
                
            when S5 =>
                data0_i <= c_string(4 to 4);
                data1_i <= c_string(3 to 3);
                data2_i <= c_string(2 to 2);
                data3_i <= c_string(1 to 1);
                data4_i <= c_space;
                data5_i <= c_space;
                data6_i <= c_space;
                data7_i <= c_space;
                
            when S6 =>
                data0_i <= c_string(5 to 5);
                data1_i <= c_string(4 to 4);
                data2_i <= c_string(3 to 3);
                data3_i <= c_string(2 to 2);
                data4_i <= c_string(1 to 1);
                data5_i <= c_space;
                data6_i <= c_space;
                data7_i <= c_space;
                
            when S7 =>
                data0_i <= c_string(6 to 6);
                data1_i <= c_string(5 to 5);
                data2_i <= c_string(4 to 4);
                data3_i <= c_string(3 to 3);
                data4_i <= c_string(2 to 2);
                data5_i <= c_string(1 to 1);
                data6_i <= c_space;
                data7_i <= c_space;
                
            when S8 =>
                data0_i <= c_string(7 to 7);
                data1_i <= c_string(6 to 6);
                data2_i <= c_string(5 to 5);
                data3_i <= c_string(4 to 4);
                data4_i <= c_string(3 to 3);
                data5_i <= c_string(2 to 2);
                data6_i <= c_string(1 to 1);
                data7_i <= c_space;
                
            when S9 =>
                data0_i <= c_string(8 to 8);
                data1_i <= c_string(7 to 7);
                data2_i <= c_string(6 to 6);
                data3_i <= c_string(5 to 5);
                data4_i <= c_string(4 to 4);
                data5_i <= c_string(3 to 3);
                data6_i <= c_string(2 to 2);
                data7_i <= c_string(1 to 1);
                
            when S10 =>
                data0_i <= c_string(9 to 9);
                data1_i <= c_string(8 to 8);
                data2_i <= c_string(7 to 7);
                data3_i <= c_string(6 to 6);
                data4_i <= c_string(5 to 5);
                data5_i <= c_string(4 to 4);
                data6_i <= c_string(3 to 3);
                data7_i <= c_string(2 to 2);
                
            when S11 =>
                data0_i <= c_string(10 to 10);
                data1_i <= c_string(9 to 9);
                data2_i <= c_string(8 to 8);
                data3_i <= c_string(7 to 7);
                data4_i <= c_string(6 to 6);
                data5_i <= c_string(5 to 5);
                data6_i <= c_string(4 to 4);
                data7_i <= c_string(3 to 3);
                
            when S12 =>
                data0_i <= c_string(11 to 11);
                data1_i <= c_string(10 to 10);
                data2_i <= c_string(9 to 9);
                data3_i <= c_string(8 to 8);
                data4_i <= c_string(7 to 7);
                data5_i <= c_string(6 to 6);
                data6_i <= c_string(5 to 5);
                data7_i <= c_string(4 to 4);
                
            when S13 =>
                data0_i <= c_string(12 to 12);
                data1_i <= c_string(11 to 11);
                data2_i <= c_string(10 to 10);
                data3_i <= c_string(9 to 9);
                data4_i <= c_string(8 to 8);
                data5_i <= c_string(7 to 7);
                data6_i <= c_string(6 to 6);
                data7_i <= c_string(5 to 5);
                
            when S14 =>
                data0_i <= c_space;
                data1_i <= c_string(12 to 12);
                data2_i <= c_string(11 to 11);
                data3_i <= c_string(10 to 10);
                data4_i <= c_string(9 to 9);
                data5_i <= c_string(8 to 8);
                data6_i <= c_string(7 to 7);
                data7_i <= c_string(6 to 6);
                
            when S15 =>
                data0_i <= c_space;
                data1_i <= c_space;
                data2_i <= c_string(12 to 12);
                data3_i <= c_string(11 to 11);
                data4_i <= c_string(10 to 10);
                data5_i <= c_string(9 to 9);
                data6_i <= c_string(8 to 8);
                data7_i <= c_string(7 to 7);
                
            when S16 =>
                data0_i <= c_space;
                data1_i <= c_space;
                data2_i <= c_space;
                data3_i <= c_string(12 to 12);
                data4_i <= c_string(11 to 11);
                data5_i <= c_string(10 to 10);
                data6_i <= c_string(9 to 9);
                data7_i <= c_string(8 to 8);
                
            when S17 =>
                data0_i <= c_space;
                data1_i <= c_space;
                data2_i <= c_space;
                data3_i <= c_space;
                data4_i <= c_string(12 to 12);
                data5_i <= c_string(11 to 11);
                data6_i <= c_string(10 to 10);
                data7_i <= c_string(9 to 9);
                
            when S18 =>
                data0_i <= c_space;
                data1_i <= c_space;
                data2_i <= c_space;
                data3_i <= c_space;
                data4_i <= c_space;
                data5_i <= c_string(12 to 12);
                data6_i <= c_string(11 to 11);
                data7_i <= c_string(10 to 10);
                
            when S19 =>
                data0_i <= c_space;
                data1_i <= c_space;
                data2_i <= c_space;
                data3_i <= c_space;
                data4_i <= c_space;
                data5_i <= c_space;
                data6_i <= c_string(12 to 12);
                data7_i <= c_string(11 to 11);
                
            when S20 =>
                data0_i <= c_space;
                data1_i <= c_space;
                data2_i <= c_space;
                data3_i <= c_space;
                data4_i <= c_space;
                data5_i <= c_space;
                data6_i <= c_space;
                data7_i <= c_string(12 to 12);
                
        end case;
    end process p_output_fsm;

end architecture Behavioral;