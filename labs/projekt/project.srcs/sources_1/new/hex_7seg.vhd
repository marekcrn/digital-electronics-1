----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2022 11:18:54 AM
-- Design Name: 
-- Module Name: hex_7seg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hex_7seg is
    Port ( hex_i : in STD_LOGIC_VECTOR (5 downto 0);
           seg_o : out STD_LOGIC_VECTOR (7 downto 0));
end hex_7seg;

architecture Behavioral of hex_7seg is

begin
    --------------------------------------------------------
    p_7seg_decoder : process(hex_i)
    begin
        case hex_i is
            when "000000" =>
                seg_o <= "10000001"; -- 0
            when "000001" =>
                seg_o <= "11001111"; -- 1
            when "000010" =>
                seg_o <= "10010010"; -- 2
            when "000011" =>
                seg_o <= "10000110"; -- 3
            when "000100" =>
                seg_o <= "11001100"; -- 4
            when "000101" =>
                seg_o <= "10100100"; -- 5
            when "000110" =>
                seg_o <= "10100000"; -- 6
            when "000111" =>
                seg_o <= "10001111"; -- 7
            when "001000" =>
                seg_o <= "10000000"; -- 8
            when "001001" =>
                seg_o <= "10000100"; -- 9
            when "001010" =>
                seg_o <= "10001000"; -- A
            when "001011" =>
                seg_o <= "11100000"; -- b
            when "001100" =>
                seg_o <= "10110001"; -- C
            when "001101" =>
                seg_o <= "11000010"; -- d
            when "001110" =>
                seg_o <= "10110000"; -- E
            when "001111" =>
                seg_o <= "10111000"; -- F
            when "010000" =>
                seg_o <= "10100001"; -- G
            when "010001" =>
                seg_o <= "11101000"; -- h
            when "010010" =>
                seg_o <= "11111001"; -- I
            when "010011" =>
                seg_o <= "11000011"; -- J
            when "010100" =>
                seg_o <= "10101000"; -- k
            when "010101" =>
                seg_o <= "11110001"; -- L
            when "010110" =>
                seg_o <= "10101011"; -- m
            when "010111" =>
                seg_o <= "10001001"; -- N
            when "011000" =>
                seg_o <= "10000001"; -- O
            when "011001" =>
                seg_o <= "10011000"; -- P
            when "011010" =>
                seg_o <= "10001100"; -- q
            when "011011" =>
                seg_o <= "10011001"; -- r
            when "011100" =>
                seg_o <= "10100100"; -- S
            when "011101" =>
                seg_o <= "11110000"; -- t
            when "011110" =>
                seg_o <= "11000001"; -- U
            when "011111" =>
                seg_o <= "11000101"; -- V
            when "100000" =>
                seg_o <= "11010101"; -- W
            when "100001" =>
                seg_o <= "11001000"; -- X
            when "100010" =>
                seg_o <= "11000100"; -- Y
            when "100011" =>
                seg_o <= "10010110"; -- Z
            when "100100" =>
                seg_o <= "10000010"; -- @
            when "100101" =>
                seg_o <= "11011101"; -- "
            when "100110" =>
                seg_o <= "11001001"; -- #
            when "100111" =>
                seg_o <= "10110100"; -- $
            when "101000" =>
                seg_o <= "10100101"; -- %
            when "101001" =>
                seg_o <= "10010000"; -- &
            when "101010" =>
                seg_o <= "11111101"; -- '
            when "101011" =>
                seg_o <= "10110001"; -- (
            when "101100" =>
                seg_o <= "10000111"; -- )
            when "101101" =>
                seg_o <= "10011100"; -- *
            when "101110" =>
                seg_o <= "11111000"; -- +
            when "101111" =>
                seg_o <= "11100111"; -- ,
            when "110000" =>
                seg_o <= "11111110"; -- -
            when "110001" =>
                seg_o <= "11011110"; -- /
            when "110010" =>
                seg_o <= "11110110"; -- :
            when "110011" =>
                seg_o <= "11100110"; -- ;
            when "110100" =>
                seg_o <= "10111100"; -- <
            when "110101" =>
                seg_o <= "10111110"; -- =
            when "110110" =>
                seg_o <= "10011110"; -- >
            when "110111" =>
                seg_o <= "10011010"; -- ?
            when "111000" =>
                seg_o <= "11111100"; -- \
            when "111001" =>
                seg_o <= "10011101"; -- ^
            when "111010" =>
                seg_o <= "11110111"; -- _
            when "111011" =>
                seg_o <= "01111111"; -- .
            when "111100" =>
                seg_o <= "01011111"; -- !
            when "111101" =>
                seg_o <= "11111111"; -- " "
            when others =>
                seg_o <= "00000000"; -- Error, brain is missing   
        end case;
    end process p_7seg_decoder;

end architecture Behavioral;