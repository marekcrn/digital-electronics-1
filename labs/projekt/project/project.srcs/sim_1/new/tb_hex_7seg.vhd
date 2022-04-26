------------------------------------------------------------
--
-- Testbench for 7-segment display decoder.
-- Nexys A7-50T, Vivado v2020.1, EDA Playground
--
-- Copyright (c) 2020-Present Tomas Fryza
-- Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------
entity tb_hex_7seg is
    -- Entity of testbench is always empty
end entity tb_hex_7seg;

------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------
architecture testbench of tb_hex_7seg is

    -- Local signals
    signal s_hex  : std_logic_vector(6 - 1 downto 0);
    signal s_seg  : std_logic_vector(8 - 1 downto 0);

begin
    -- Connecting testbench signals with decoder entity
    -- (Unit Under Test)
    uut_hex_7seg : entity work.hex_7seg
        port map(
            hex_i => s_hex,
            seg_o => s_seg
        );

    --------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;

        s_hex <= "000000"; wait for 20 ns; --0
        s_hex <= "000001"; wait for 20 ns; --1       
        s_hex <= "000010"; wait for 20 ns; --2
        s_hex <= "000011"; wait for 20 ns; --3   
        s_hex <= "000100"; wait for 20 ns; --4
        s_hex <= "000101"; wait for 20 ns; --5       
        s_hex <= "000110"; wait for 20 ns; --6       
        s_hex <= "000111"; wait for 20 ns; --7
        s_hex <= "001000"; wait for 20 ns; --8  
        s_hex <= "001001"; wait for 20 ns; --9
        s_hex <= "001010"; wait for 20 ns; --A
        s_hex <= "001011"; wait for 20 ns; --b
        s_hex <= "001100"; wait for 20 ns; --C
        s_hex <= "001101"; wait for 20 ns; --d
        s_hex <= "001110"; wait for 20 ns; --E      
        s_hex <= "001111"; wait for 20 ns; --F
        s_hex <= "010000"; wait for 20 ns; --G
        s_hex <= "010001"; wait for 20 ns; --h
        s_hex <= "010010"; wait for 20 ns; --I
        s_hex <= "010011"; wait for 20 ns; --J
        s_hex <= "010100"; wait for 20 ns; --k       
        s_hex <= "010101"; wait for 20 ns; --L
        s_hex <= "010110"; wait for 20 ns; --m
        s_hex <= "010111"; wait for 20 ns; --N        
        s_hex <= "011000"; wait for 20 ns; --O
        s_hex <= "011001"; wait for 20 ns; --P
        s_hex <= "011010"; wait for 20 ns; --q
        s_hex <= "011011"; wait for 20 ns; --r
        s_hex <= "011100"; wait for 20 ns; --S       
        s_hex <= "011101"; wait for 20 ns; --t
        s_hex <= "011110"; wait for 20 ns; --U
        s_hex <= "011111"; wait for 20 ns; --V
        s_hex <= "100000"; wait for 20 ns; --W       
        s_hex <= "100001"; wait for 20 ns; --X
        s_hex <= "100010"; wait for 20 ns; --Y
        s_hex <= "100011"; wait for 20 ns; --Z     
        s_hex <= "101010"; wait for 20 ns; --'
        s_hex <= "101011"; wait for 20 ns; --(
        s_hex <= "101100"; wait for 20 ns; --)       
        s_hex <= "110000"; wait for 20 ns; -- -
        s_hex <= "111010"; wait for 20 ns; -- _
        s_hex <= "111011"; wait for 20 ns; -- .      
        s_hex <= "111101"; wait for 20 ns; -- " "
        
        report "Stimulus process finished" severity note;        
        wait;
    end process p_stimulus;

end architecture testbench;