------------------------------------------------------------
--
-- Testbench for mux_3bit_4to1.
-- EDA Playground
--
-- Copyright (c) 2020-Present Tomas Fryza
-- Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------
entity tb_mux_3bit_4to1 is
    -- Entity of testbench is always empty
end entity tb_mux_3bit_4to1;

------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------
architecture testbench of tb_mux_3bit_4to1 is

    -- Local signals
    signal s_a           : std_logic_vector(3 - 1 downto 0);
    signal s_b           : std_logic_vector(3 - 1 downto 0);
    signal s_c           : std_logic_vector(3 - 1 downto 0);
    signal s_d           : std_logic_vector(3 - 1 downto 0);
    signal s_sel_i       : std_logic_vector(2 - 1 downto 0);
    signal s_f_o         : std_logic_vector(3 - 1 downto 0);

begin
    -- Connecting testbench signals with mux_3bit_4to1
    -- entity (Unit Under Test)
    uut_mux_3bit_4to1 : entity work.mux_3bit_4to1
        port map(
            a_i      => s_a,
            b_i      => s_b,
            c_i      => s_c,
            d_i      => s_d,
            sel_i    => s_sel_i,
            f_o      => s_f_o
        );

    --------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------
    p_stimulus : process
    begin
        -- Report a note at the beginning of stimulus process
        report "Stimulus process started" severity note;
        
        -- Test case
        s_a <= "110"; 
        s_sel_i <= "00"; 
        wait for 100 ns;
        
        -- Expected output
        assert ((s_f_o = "110"));
        
        
    wait;
    end process p_stimulus;

end architecture testbench;