
Q
Command: %s
53*	vivadotcl2 
place_design2default:defaultZ4-113h px? 
?
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7a12ti2default:defaultZ17-347h px? 
?
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7a12ti2default:defaultZ17-349h px? 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px? 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px? 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px? 
p
,Running DRC as a precondition to command %s
22*	vivadotcl2 
place_design2default:defaultZ4-22h px? 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px? 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px? 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px? 
U

Starting %s Task
103*constraints2
Placer2default:defaultZ18-103h px? 
}
BMultithreading enabled for place_design using a maximum of %s CPUs12*	placeflow2
22default:defaultZ30-611h px? 
v

Phase %s%s
101*constraints2
1 2default:default2)
Placer Initialization2default:defaultZ18-101h px? 
?

Phase %s%s
101*constraints2
1.1 2default:default29
%Placer Initialization Netlist Sorting2default:defaultZ18-101h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2
00:00:002default:default2
1465.8012default:default2
0.0002default:defaultZ17-268h px? 
[
FPhase 1.1 Placer Initialization Netlist Sorting | Checksum: 1e016c8fc
*commonh px? 
?

%s
*constraints2s
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.007 . Memory (MB): peak = 1465.801 ; gain = 0.0002default:defaulth px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2
00:00:002default:default2
1465.8012default:default2
0.0002default:defaultZ17-268h px? 
?

Phase %s%s
101*constraints2
1.2 2default:default2F
2IO Placement/ Clock Placement/ Build Placer Device2default:defaultZ18-101h px? 
?
?IO placement is infeasible. Number of unplaced terminals (%s) is greater than number of available sites (%s).
The following are banks with available pins: %s
58*place2
82default:default2
02default:default2?
?
 IO Group: 0 with : SioStd: LVCMOS18   VCCO = 1.8 Termination: 0  TermDir:  Out  RangeId: 1 Drv: 12  has only 0 sites available on device, but needs 8 sites.
	Term: <MSGMETA::BEGIN::BLOCK>AN[0]<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>AN[2]<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>AN[7]<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>LED[2]<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>CA<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>CB<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>CD<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>CF<MSGMETA::END>

"?
AN[0]2?
 IO Group: 0 with : SioStd: LVCMOS18   VCCO = 1.8 Termination: 0  TermDir:  Out  RangeId: 1 Drv: 12  has only 0 sites available on device, but needs 8 sites.
	Term: :
	Term: "
AN[2]:
	Term: "
AN[7]:
	Term: "
LED[2]:
	Term: "
CA:
	Term: "
CB:
	Term: "
CD:
	Term: "

CF:

2default:default8Z30-58h px? 
?
?IO placement is infeasible. Number of unplaced terminals (%s) is greater than number of available sites (%s).
The following are banks with available pins: %s
58*place2
82default:default2
02default:default2?
?
 IO Group: 0 with : SioStd: LVCMOS18   VCCO = 1.8 Termination: 0  TermDir:  Out  RangeId: 1 Drv: 12  has only 0 sites available on device, but needs 8 sites.
	Term: <MSGMETA::BEGIN::BLOCK>AN[0]<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>AN[2]<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>AN[7]<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>LED[2]<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>CA<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>CB<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>CD<MSGMETA::END>
	Term: <MSGMETA::BEGIN::BLOCK>CF<MSGMETA::END>

"?
AN[0]2?
 IO Group: 0 with : SioStd: LVCMOS18   VCCO = 1.8 Termination: 0  TermDir:  Out  RangeId: 1 Drv: 12  has only 0 sites available on device, but needs 8 sites.
	Term: :
	Term: "
AN[2]:
	Term: "
AN[7]:
	Term: "
LED[2]:
	Term: "
CA:
	Term: "
CB:
	Term: "
CD:
	Term: "

CF:

2default:default8Z30-58h px? 
?#
'IO placer failed to find a solution
%s
374*place2?"
?"Below is the partial placement that can be analyzed to see if any constraint modifications will make the IO placement problem easier to solve.

+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|                                                                     IO Placement : Bank Stats                                                                           |
+----+-------+-------+------------------------------------------------------------------------+------------------------------------------+--------+--------+--------+-----+
| Id | Pins  | Terms |                               Standards                                |                IDelayCtrls               |  VREF  |  VCCO  |   VR   | DCI |
+----+-------+-------+------------------------------------------------------------------------+------------------------------------------+--------+--------+--------+-----+
|  0 |     0 |     0 |                                                                        |                                          |        |        |        |     |
| 14 |    50 |    10 | LVCMOS33(10)                                                           |                                          |        |  +3.30 |    YES |     |
| 15 |    50 |     1 | LVCMOS33(1)                                                            |                                          |        |  +3.30 |    YES |     |
| 34 |    50 |     1 | LVCMOS33(1)                                                            |                                          |        |  +3.30 |    YES |     |
+----+-------+-------+------------------------------------------------------------------------+------------------------------------------+--------+--------+--------+-----+
|    |   150 |    12 |                                                                        |                                          |        |        |        |     |
+----+-------+-------+------------------------------------------------------------------------+------------------------------------------+--------+--------+--------+-----+

IO Placement:
+--------+----------------------+-----------------+----------------------+----------------------+----------------------+
| BankId |             Terminal | Standard        | Site                 | Pin                  | Attributes           |
+--------+----------------------+-----------------+----------------------+----------------------+----------------------+
| 14     | AN[1]                | LVCMOS33        | IOB_X0Y44            | J18                  |                      |
|        | AN[3]                | LVCMOS33        | IOB_X0Y40            | J14                  |                      |
|        | AN[4]                | LVCMOS33        | IOB_X0Y26            | P14                  |                      |
|        | AN[5]                | LVCMOS33        | IOB_X0Y24            | T14                  |                      |
|        | BTNC                 | LVCMOS33        | IOB_X0Y31            | N17                  |                      |
|        | CC                   | LVCMOS33        | IOB_X0Y48            | K16                  |                      |
|        | CE                   | LVCMOS33        | IOB_X0Y28            | P15                  |                      |
|        | CG                   | LVCMOS33        | IOB_X0Y41            | L18                  |                      |
|        | LED[1]               | LVCMOS33        | IOB_X0Y39            | K15                  |                      |
|        | LED[3]               | LVCMOS33        | IOB_X0Y33            | N14                  |                      |
+--------+----------------------+-----------------+----------------------+----------------------+----------------------+
| 15     | LED[0]               | LVCMOS33        | IOB_X0Y54            | H17                  |                      |
+--------+----------------------+-----------------+----------------------+----------------------+----------------------+
| 34     | AN[6]                | LVCMOS33        | IOB_X1Y44            | K2                   |                      |
+--------+----------------------+-----------------+----------------------+----------------------+----------------------+
2default:defaultZ30-374h px? 
?
[Partially locked IO Bus is found. Following components of the IO Bus %s are not locked: %s
87*place2
AN2default:default2?
? '<MSGMETA::BEGIN::BLOCK>AN[7]<MSGMETA::END>'  '<MSGMETA::BEGIN::BLOCK>AN[2]<MSGMETA::END>'  '<MSGMETA::BEGIN::BLOCK>AN[0]<MSGMETA::END>' "
AN[7]2 ':'  '"
AN[2]:'  '"
AN[0]:' 2default:default8Z30-87h px? 
?
[Partially locked IO Bus is found. Following components of the IO Bus %s are not locked: %s
87*place2
LED2default:default2W
/ '<MSGMETA::BEGIN::BLOCK>LED[2]<MSGMETA::END>' "
LED[2]2 ':' 2default:default8Z30-87h px? 
h
SPhase 1.2 IO Placement/ Clock Placement/ Build Placer Device | Checksum: 126094620
*commonh px? 
?

%s
*constraints2s
_Time (s): cpu = 00:00:01 ; elapsed = 00:00:00.130 . Memory (MB): peak = 1465.801 ; gain = 0.0002default:defaulth px? 
I
4Phase 1 Placer Initialization | Checksum: 126094620
*commonh px? 
?

%s
*constraints2s
_Time (s): cpu = 00:00:01 ; elapsed = 00:00:00.130 . Memory (MB): peak = 1465.801 ; gain = 0.0002default:defaulth px? 
?
?Placer failed with error: '%s'
Please review all ERROR and WARNING messages during placement to understand the cause for failure.
1*	placeflow2*
IO Clock Placer failed2default:defaultZ30-99h px? 
>
)Ending Placer Task | Checksum: 126094620
*commonh px? 
?

%s
*constraints2s
_Time (s): cpu = 00:00:01 ; elapsed = 00:00:00.132 . Memory (MB): peak = 1465.801 ; gain = 0.0002default:defaulth px? 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px? 
?
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
422default:default2
22default:default2
102default:default2
52default:defaultZ4-41h px? 
N

%s failed
30*	vivadotcl2 
place_design2default:defaultZ4-43h px? 
m
Command failed: %s
69*common28
$Placer could not place all instances2default:defaultZ17-69h px? 
?
Exiting %s at %s...
206*common2
Vivado2default:default2,
Tue Mar 22 14:47:27 20222default:defaultZ17-206h px? 


End Record