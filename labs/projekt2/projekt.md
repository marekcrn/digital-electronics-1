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

Náš úkol spočíval ve vytvoření běžícího textu na sedmisegmentovém displayi, toto zadání jsme rozšířili o 4 nastavitelné rychlosti a 2 směry.


<a name="hardware"></a>

## Hardware description

Write your text here.

<a name="modules"></a>

## VHDL modules description and simulations
Všechny použité moduly byly převzaty z předchozích cvičení a následně upraveny pro požadované funkce.

* clock_enable

Funkcí tohoto modulu je upravit frekvenci vstupního hodinového signálu na požadovanou hodnotu. 
![clock](images/waveforms_clock.png)

* cnt_up_down

Tento modul slouží k pričítání k tříbitové hodnotě s_cnt (v simulaci čtyřbitové), která ovládá, který z osmi dislayů je právě aktivní. 
![counter](images/waveforms_cnt.png)

* hex_7seg

Účelem tohoto modulu je transformovat vstupní jednobitový string hex_i na osmibitovou binární hodnotu seg_o představující stav katod displaye.

![hex7seg](images/waveforms_hex7seg.png)


* driver_7seg_8digits

Tento modul propojuje veškeré předchozíhodnoty a přidává další funkce. Skládá se ze signálů v předchozích modulech, vstupních signálů speed, direction a z vnitřních signálů s_cnt2 (ovládá čas mezi jednotlivými stavy) a data0-7_i, kterým jsou přiřazovány jednobitové stringy. Dále obsahuje konstanty pro čas prodlevy mezi stavy, string obsahující až  dvanácti znakovou zprávu, která se má zobrazovat na displayích, konstantu označující nesvítící display a množinu stavů, díky kterým text rotuje. 

![driver](images/waveforms_driver.png)

<a name="top"></a>

## TOP module description and simulations

* top

Funkcí tohoto modulu je propojit signály z driver_7seg_8digits s piny na desce Nexys A7 50T. Propojuje hodinový signál, tlačítko BTNC s reset, switch(0) se signálem direction, switch(1-2) se signálem speed, signál seg_o s jednotlivými katodami a desetinnou tečkou a dig_o s AN aktivující displaye.

<a name="video"></a>

## Video

Write your text here

<a name="references"></a>

## References

1. [https://github.com/tomas-fryza/digital-electronics-1](https://github.com/tomas-fryza/digital-electronics-1)
2. [https://www.chrispurdie.com/7seg1_web](https://www.chrispurdie.com/7seg1_web)