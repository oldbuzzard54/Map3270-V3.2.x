# MAP3270-V3.2.2
Full install (including source code) for MVS 38j systems running Hercules 
TK3, TK4- or TK5 systems.There is an optional update at the end of this document for running MAP3270 on Z/OS

All the executable code is provided so the install just involves submitting some JCL and
a couple of edits.
This project contains the complete source code for generating the MAP3270 project from source code
at your option.

MAP3270 V2.x.x is pre-installed on distributions of TK4- V8.  Some of the executables are in ‘SYS2.LINKLIB’.
Others are in MAP3270.LOADLIB on volume PUB000.
All the other datasets have the high level qualifier ‘MAP3270.’
No version of MAP3270 is pre-installed on distributions of TK3.
As of this writing, MAP3270 V3.x.x is installed on TK5.

Summary of changes
==================
V3.1.0 introduced the TABLE and BOUNDS to the screen compiler.
V3.2.0 introduced the ability of the application program to alter some of the attributes in the data stream.
V3.2.1 is a bug fix.  The screen compiler incorrectly generates data fields for screen labels when TABLE is
       used. Only the source code for MAP3270 was changed along with load modules MAP3270 and MAP32705. This
       fix is optional if you don't use the TABLE feature.
V3.2.2 is an installer fix.  Problems with 3350 vs 3390 DASD are dealt with on TK5 systems

These instruction will create what I call a “test version”.  All the dataset are created with the 
high level qualifier ‘userid.MAP3270’.  If you desire, the JCL can be modified to directly update 
the TK4- pre-installation.  I recommend creating the “test” version and then copy the all the 
members to update the TK4- pre-installation.

All of the .txt files are compile listings and/or installation listings.  The .pdf files 
are documentation.

All steps in each job must complete with RC= 0000 except for COBOL and PL/I compiles, which can 
complete with RC= 0004.

STEP 1
======
Download the MAP3270-V3.2.2.zip file. Extract MAP3270-xmi file. Extract RESTTK5.jcl if you are
using TK5.  If you want to use RECV370 or you are not using NJE38, extract RESTOTHR.jcl.

STEP 2
======
When most transfer programs create the dataset on MVS, the default DCB is generally no good for XMI
file.  Create a dataset (MAP3270.XMI) on MVS with RECFM=FB, LRECL=80, BLKSIZE=3120.

STEP 3
======
Binary upload the MAP3270 xmi file to MVS dataset (MAP3270.XMI).

STEP 4
======
Edit RESTxxxx.JCL if you may want to change the default userid HERC01, volume TSO001 or PUB002.  
All steps should end with RC = 0000.  

The following data sets will be created:
userid.MAP3270.ASM  
userid.MAP3270.CNTL
userid.MAP3270.COB
userid.MAP3270.MACLIB
userid.MAP3270.MAP
userid.MAP3270.PANEL
userid.MAP3270.PANEL5
userid.MAP3270.PLI
userid.MAP3270.SOURCE
userid.MAP3270.SOURCE5
userid.MAP3270.LOADLIB

STEP 5
======
When restore is successfully completed, the "test" install is completed.  Please
refer to the $README member in the userid.MAP3270.CNTL for additional install info.


=======================================================================
=======================================================================
OPTIONAL UPDATE

The purpose of the OPTIONAL upgrade is to enable MAP3270 to run on systems other than MVS 38j such as Z/OS.  All of MAP3270 executable code will run under Z/OS except for the generated maps.  By default, MAP3270 generates maps that have code specific to MVS 3.8j that is not standard 3270 commands.  This non-standard code causes TSO sessions to abort.

There is no “official” MAP3270 install for Z/OS.  However, any applications you developed with Tkx should run under Z/OS.  As mentioned above, the maps are the exception.  This can be simply resolved by a one line change to a macro and reassembling the maps which use the macro (which is all of them). I have done all this and created a run time MAP3270-RTZ310.XMI, which will NOT work with MVS 3.8j.  It was tested on Z/OS.  By the way, MAP3270-RTZ310 stands for MAP3270 V3.1.0 run time for Z/OS.

The following instructions are for a Z/OS system with TSO in READY mode.

STEP 1
=====
    • Transfer MAP3270-RTZ310.XMI to the target system.
    • Make sure the hlq.MAP3270.MAP, hlq.MAP3270.MACLIB and hlq.MAP3270.XMI do not exist.
    • Create a PDS hlq.MAP3270.LOADLIB with recfm=U, lrecl=0 and blksize=19069 with 40 directory blocks.
    • RECEIVE INDATASET(MAP3270.RTZ310.XMI)
      hlg.MAP3270.XMI will be created and will	contain 3 members – MAPXMI, MACXMI and LOADXMI.
    • RECEIVE INDATASET(MAP3270.XMI(MACXMI))
    • RECEIVE INDATASET(MAP3270.XMI(MAPXMI))
    • Two PDS will be created – hlg.MAP3270.MACLIB and hlq.MAP3270.MAP
    • RECEIVE INDATASET(MAP3270.XMI(LOADXMI)) OUTDATASET(MAP3270.LOADLIB)
      Allow overwrite since the dataset was preallocated.  You must use the preallocated LOADLIB since RECEIVE will create the dataset with default blksize=4096 and the receive will be invalid.
      
At this point, you should be able to run any of the demo programs in MAP3270.LOADLIB the call command.  The demo programs are ADEMO, CDEMO and MDEMO.  PDEMO is a PL/1 program (see below).

 READY
call ‘hlq.map3270.loadlib(demo_pgm_name)’ 

STEP 2
=====
This step is optional for the demo programs (because I did this already).  If you want to reassemble and link all the maps in zosid.MAP3270.MAP to zosid.MAP3270.LOADLIB, make sure that zosid.MACLIB is in the SYSLIB concatination.  

All the steps in the reassemble should have return code 0000.


STEP 3
=====
For any maps you created, you must to reassemble and link all the your maps to your loadlib.  Make sure that zosid.MACLIB is in the SYSLIB concatination.  

All the steps in the reassemble should have return code 0000.

That is All

SPECIAL NOTE For PL/1(F) users:
Since PL/1(F) is not supported under Z/OS, the runtime support is NOT available on Z/OS.  If you want to run PL/1(F) programs compiled on Tkx, there are options for doing this.
    • You can transfer a copy of SYS1.PL1LIB to your Z/OS system.
    • Include it as a STEPLIB or JOBLIB.  This applied to both batch and MAP3270 under TSO.  I have done this and batch PL/I programs will run correctly on Z/OS.
    • Since the TSO CALL command creates an implicit STEPLIB, You can copy the PL1LIB runtime into your MAP3270.LOADLIB.  Now all the PL/I runtime will be available and STEPLIB/JOBLIB is not needed.
      
MAP3270 has not been tested with any of the modern versions of assembler, COBOL or PL/I.  If you feel so inclined to try it, please let me know the results – good or bad.


