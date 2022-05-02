# Running text on 7-seg displays

### Team members

* Marek Černý
* Martin Borski
* Aleš Pikhart

### Table of contents

* [Project objectives](#objectives)
* [Hardware description](#hardware)
* [VHDL modules description and simulations](#modules)
* [TOP module description and simulations](#top)
* [Video](#video)
* [References](#references)

<a name="objectives"></a>

## Project objectives

Náš úkol spočíval ve vytvoření běžícího textu na sedmisegmentovém displayi, toto zadání jsme rozšířili o 4 nastavitelné rychlosti a 2 směry


<a name="hardware"></a>

## Hardware description

Write your text here.

<a name="modules"></a>

## VHDL modules description and simulations
Všechny použité moduly byly převzaty z předchozích cvičení a následně upraveny pro požadované funkce

* clock_enable
![clock](images/waveforms_clock.png)

* cnt_up_down
![counter](images/waveforms_cnt.png)

* hex_7seg

Účelem tohoto modulu je transformovat vstupní jednobitový string hex_i na osmibitovou binární hodnotu seg_o představující stav katod displaye.

![hex7seg](images/waveforms_hex7seg.png)

<a name="top"></a>

## TOP module description and simulations

![driver](images/waveforms_driver.png)

<a name="video"></a>

## Video

Write your text here

<a name="references"></a>

## References

1. Write your text here.
