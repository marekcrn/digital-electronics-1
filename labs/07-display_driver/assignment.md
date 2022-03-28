# Lab 7: YOUR_FIRSTNAME LASTNAME

## Preparation tasks (done before the lab at home)

A common way to control multiple displays is to gradually switch between them. We control (connect to supply voltage) only one of the displays at a time, as can be seen [here](https://engineeringtutorial.com/seven-segment-display-working-principle/).

Due to the physiological properties of human vision, it is necessary that the time required to display the whole value is a maximum of 16&nbsp;ms. If we display four digits, then the duration of one of them is 4&nbsp;ms. If we display eight digits, the time is reduced to 2&nbsp;ms, etc.

1. See schematic of the Nexys A7 board, find out the connection of 7-segment displays, and complete the signal timing to display four-digit value `3.142`.

 <img width="488" alt="image" src="https://user-images.githubusercontent.com/99393884/159897693-1e3d59dd-dc25-4d17-9f3e-6cbc47a8b716.png">

  <img width="644" alt="image" src="https://user-images.githubusercontent.com/99393884/159897771-ff1106fb-f4e1-4749-ace4-fa7b73bfaa71.png">

<img width="735" alt="image" src="https://user-images.githubusercontent.com/99393884/159897827-85f0ebdf-1d4f-4452-9388-b853e9d3878e.png">


  > The figure above was created in [WaveDrom](https://wavedrom.com/) digital timing diagram online tool. The figure source code is as follows:
  >
  ```javascript
  {
  signal:
  [
    ['Digit position',
      {name: 'Common anode: AN(3)', wave: 'xx01..01..01'},
      {name: 'Common anode: AN(2)', wave: 'xx101..01..0'},
      {name: 'Common anode: AN(1)', wave: 'xx1.01..01..'},
      {name: 'Common anode: AN(0)', wave: 'xx1..01..01.'},
    ],
    ['Seven-segment data',
      {name: '4-digit value to display', wave: 'xx3333555599', data: ['3','1','4','2','3','1','4','2','3','1']},
      {name: 'Cathod A: CA', wave: 'xx01.0.1.0.1'},
      {name: 'Cathod B: CB', wave: 'xx0.........'},
      {name: 'Cathod C: CC', wave: 'xx0..10..10.'},
      {name: 'Cathod D: CD', wave: 'xx01.0.1.0.1'},
      {name: 'Cathod E: CE', wave: 'xx1..01..01.'},
      {name: 'Cathod F: CF', wave: 'xx1.01..01..'},
      {name: 'Cathod G: CG', wave: 'xx010..10..1'},
    ],
    {name: 'Decimal point: DP', wave: 'xx01..01..01'},
  ],
  head:
  {
    text: '                    4ms   4ms   4ms   4ms   4ms   4ms   4ms   4ms   4ms   4ms',
  },
}
  ```

<a name="part1"></a>

### Display driver

1. Listing of VHDL code of the completed process `p_mux`. Always use syntax highlighting, meaningful comments, and follow VHDL guidelines:

```vhdl
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
                dig_o <= "1110";
            else
                case s_cnt is
                    when "11" =>
                        s_hex <= data3_i;
                        dp_o  <= dp_i(3);
                        dig_o <= "0111";

                    when "10" =>
                        -- WRITE YOUR CODE HERE

                    when "01" =>
                        -- WRITE YOUR CODE HERE

                    when others =>
                        -- WRITE YOUR CODE HERE
                end case;
            end if;
        end if;
    end process p_mux;
```

2. Screenshot with simulated time waveforms. Test reset as well. Always display all inputs and outputs (display the inputs at the top of the image, the outputs below them) at the appropriate time scale!

   ![your figure]()

### Eight-digit driver

1. Image of the 8-digit driver's block schematic. The image can be drawn on a computer or by hand. Always name all inputs, outputs, components, and internal signals!

   ![your figure]()
