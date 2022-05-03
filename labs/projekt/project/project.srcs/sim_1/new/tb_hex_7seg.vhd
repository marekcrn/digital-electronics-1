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
    signal s_hex  : String(1 to 1);
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

        s_hex <= "0"; wait for 20 ns; --0
        s_hex <= "1"; wait for 20 ns; --1       
        s_hex <= "2"; wait for 20 ns; --2
        s_hex <= "3"; wait for 20 ns; --3   
        s_hex <= "4"; wait for 20 ns; --4
        s_hex <= "5"; wait for 20 ns; --5       
        s_hex <= "6"; wait for 20 ns; --6       
        s_hex <= "7"; wait for 20 ns; --7
        s_hex <= "8"; wait for 20 ns; --8  
        s_hex <= "9"; wait for 20 ns; --9
        s_hex <= "a"; wait for 20 ns; --A
        s_hex <= "b"; wait for 20 ns; --b
        s_hex <= "c"; wait for 20 ns; --C
        s_hex <= "d"; wait for 20 ns; --d
        s_hex <= "e"; wait for 20 ns; --E      
        s_hex <= "f"; wait for 20 ns; --F
        s_hex <= "g"; wait for 20 ns; --G
        s_hex <= "h"; wait for 20 ns; --h
        s_hex <= "i"; wait for 20 ns; --I
        s_hex <= "j"; wait for 20 ns; --J
        s_hex <= "k"; wait for 20 ns; --k       
        s_hex <= "l"; wait for 20 ns; --L
        s_hex <= "m"; wait for 20 ns; --m
        s_hex <= "n"; wait for 20 ns; --N        
        s_hex <= "o"; wait for 20 ns; --O
        s_hex <= "p"; wait for 20 ns; --P
        s_hex <= "q"; wait for 20 ns; --q
        s_hex <= "r"; wait for 20 ns; --r
        s_hex <= "s"; wait for 20 ns; --S       
        s_hex <= "t"; wait for 20 ns; --t
        s_hex <= "u"; wait for 20 ns; --U
        s_hex <= "v"; wait for 20 ns; --V
        s_hex <= "w"; wait for 20 ns; --W       
        s_hex <= "x"; wait for 20 ns; --X
        s_hex <= "y"; wait for 20 ns; --Y
        s_hex <= "z"; wait for 20 ns; --Z     
        s_hex <= "'"; wait for 20 ns; --'
        s_hex <= "("; wait for 20 ns; --(
        s_hex <= ")"; wait for 20 ns; --)       
        s_hex <= "-"; wait for 20 ns; -- -
        s_hex <= "_"; wait for 20 ns; -- _
        s_hex <= "."; wait for 20 ns; -- .      
        s_hex <= " "; wait for 20 ns; -- " "
        
        report "Stimulus process finished" severity note;        
        wait;
    end process p_stimulus;

end architecture testbench;