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
    Port ( hex_i : in  STRING(1 to 1);
           seg_o : out STD_LOGIC_VECTOR (8 - 1 downto 0));
end hex_7seg;

architecture Behavioral of hex_7seg is

begin
    --------------------------------------------------------
    p_7seg_decoder : process(hex_i)
    begin
        case hex_i is
            when "0" =>
                seg_o <= "10000001"; -- 0
            when "1" =>
                seg_o <= "11001111"; -- 1
            when "2" =>
                seg_o <= "10010010"; -- 2
            when "3" =>
                seg_o <= "10000110"; -- 3
            when "4" =>
                seg_o <= "11001100"; -- 4
            when "5" =>
                seg_o <= "10100100"; -- 5
            when "6" =>
                seg_o <= "10100000"; -- 6
            when "7" =>
                seg_o <= "10001111"; -- 7
            when "8" =>
                seg_o <= "10000000"; -- 8
            when "9" =>
                seg_o <= "10000100"; -- 9
            when "a" =>
                seg_o <= "10001000"; -- A
            when "b" =>
                seg_o <= "11100000"; -- b
            when "c" =>
                seg_o <= "10110001"; -- C
            when "d" =>
                seg_o <= "11000010"; -- d
            when "e" =>
                seg_o <= "10110000"; -- E
            when "f" =>
                seg_o <= "10111000"; -- F
            when "g" =>
                seg_o <= "10100001"; -- G
            when "h" =>
                seg_o <= "11101000"; -- h
            when "i" =>
                seg_o <= "11111001"; -- I
            when "j" =>
                seg_o <= "11000011"; -- J
            when "k" =>
                seg_o <= "10101000"; -- k
            when "l" =>
                seg_o <= "11110001"; -- L
            when "m" =>
                seg_o <= "10101011"; -- m
            when "n" =>
                seg_o <= "10001001"; -- N
            when "o" =>
                seg_o <= "10000001"; -- O
            when "p" =>
                seg_o <= "10011000"; -- P
            when "q" =>
                seg_o <= "10001100"; -- q
            when "r" =>
                seg_o <= "10011001"; -- r
            when "s" =>
                seg_o <= "10100100"; -- S
            when "t" =>
                seg_o <= "11110000"; -- t
            when "u" =>
                seg_o <= "11000001"; -- U
            when "v" =>
                seg_o <= "11000101"; -- V
            when "w" =>
                seg_o <= "11010101"; -- W
            when "x" =>
                seg_o <= "11001000"; -- X
            when "y" =>
                seg_o <= "11000100"; -- Y
            when "z" =>
                seg_o <= "10010110"; -- Z
            when "@" =>
                seg_o <= "10000010"; -- @
            --when """ =>
                --seg_o <= "11011101"; -- "
            when "#" =>
                seg_o <= "11001001"; -- #
            when "$" =>
                seg_o <= "10110100"; -- $
            when "%" =>
                seg_o <= "10100101"; -- %
            when "&" =>
                seg_o <= "10010000"; -- &
            when "'" =>
                seg_o <= "11111101"; -- '
            when "(" =>
                seg_o <= "10110001"; -- (
            when ")" =>
                seg_o <= "10000111"; -- )
            when "*" =>
                seg_o <= "10011100"; -- *
            when "+" =>
                seg_o <= "11111000"; -- +
            when "," =>
                seg_o <= "11100111"; -- ,
            when "-" =>
                seg_o <= "11111110"; -- -
            when "/" =>
                seg_o <= "11011110"; -- /
            when ":" =>
                seg_o <= "11110110"; -- :
            when ";" =>
                seg_o <= "11100110"; -- ;
            when "<" =>
                seg_o <= "10111100"; -- <
            when "=" =>
                seg_o <= "10111110"; -- =
            when ">" =>
                seg_o <= "10011110"; -- >
            when "?" =>
                seg_o <= "10011010"; -- ?
            --when "\" =>
                --seg_o <= "11111100"; -- \
            when "^" =>
                seg_o <= "10011101"; -- ^
            when "_" =>
                seg_o <= "11110111"; -- _
            when "." =>
                seg_o <= "01111111"; -- .
            when "!" =>
                seg_o <= "01011111"; -- !
            when " " =>
                seg_o <= "11111111"; -- " "
            when others =>
                seg_o <= "00000000"; -- Error, brain is missing   
        end case;
    end process p_7seg_decoder;

end architecture Behavioral;