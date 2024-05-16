//RESTTK5 JOB 'ME',MSGLEVEL=(1,1),NOTIFY=HERC01,CLASS=A,
//            MSGCLASS=A,USER=HERC01,PASSWORD=CUL8TR
//********************************************************************
//*
//*  THIS JOB RECIEVES THE MAP3270 SOFTWARE FROM A XMI FILE.
//*
//*  THE SOFTWARE RESIDES IN 11 DATASETS.  BY DEFAULT, THE DATASETS
//*  ARE PREFIXED WITH 'HERC01.MAP3270' ON VOLSER TSO001.
//*
//*    .ASM    CONTAINS BAL DATA DEFINITIONS FOR PANELS FROM MAP3270.
//*    .CNTL   CONTAIN ALL RELATED JCL
//*    .COB    CONTAINS COBOL DATA DEFINITIONS FOR PANELS FROM MAP3270.
//*    .LOADLIB CONTAINS THE EXECUTABLE CODE.
//*    .MACLIB  CONTAINS MACROS FOR MAP3270.
//*    .MAP    CONTAINS THE BAL CODE GENERATED BY MAP3270 FOR
//*            THE PANEL DEFINITION
//*    .PANEL  CONTAINS THE SOURCE CODE FOR THE PANEL. EDITED MANUALLY
//*            AND USED AS INPUT TO THE PANEL COMPILER - MAP3270.
//*    .PANEL5 CONTAINS THE SOURCE CODE FOR THE PANEL. EDITED MANUALLY
//*            AND USED AS INPUT TO THE PANEL COMPILER - MAP32705.
//*    .PLI    CONTAINS PL/I DATA DEFINITIONS FOR PANELS FROM MAP3270.
//*    .SOURCE CONTAINS ALL THE SOURCE CODE FOR THE COMPILER AND
//*            DEMO PROGRAMS.
//*    .SOURCE5 CONTAINS MODEL 5 SPECIFIC CODE FOR MODEL 5 COMPILER
//*
//********************************************************************
//*
//*  DELETE MAP3270 DATASETS
//*
//STEP01  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE 'HERC01.MAP3270.ASM'     NONVSAM PURGE
 DELETE 'HERC01.MAP3270.ASM3350' NONVSAM PURGE
 DELETE 'HERC01.MAP3270.CNTL'    NONVSAM PURGE
 DELETE 'HERC01.MAP3270.COB'     NONVSAM PURGE
 DELETE 'HERC01.MAP3270.LOADLIB' NONVSAM PURGE
 DELETE 'HERC01.MAP3270.MACLIB'  NONVSAM PURGE
 DELETE 'HERC01.MAP3270.MAC3350' NONVSAM PURGE
 DELETE 'HERC01.MAP3270.MAP'     NONVSAM PURGE
 DELETE 'HERC01.MAP3270.PANEL'   NONVSAM PURGE
 DELETE 'HERC01.MAP3270.PANEL5'  NONVSAM PURGE
 DELETE 'HERC01.MAP3270.PLI'     NONVSAM PURGE
 DELETE 'HERC01.MAP3270.SOURCE'  NONVSAM PURGE
 DELETE 'HERC01.MAP3270.SOURCE5' NONVSAM PURGE
 DELETE 'HERC01.MAP3270.PDSXMI' NONVSAM PURGE
 SET LASTCC = 0
 SET MAXCC = 0
//*
//STEP03 EXEC PGM=IKJEFT01,PARM=ISPLOGON,REGION=4096K
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 PROFILE PREFIX(HERC01)
 RECEIVE DATASET(MAP3270.PDSXMI)  INDATASET(MAP3270.XMI)
 RECEIVE DATASET(MAP3270.ASM3350) INDATASET(MAP3270.PDSXMI(ASM))
 RECEIVE DATASET(MAP3270.CNTL)    INDATASET(MAP3270.PDSXMI(CNTL))
 RECEIVE DATASET(MAP3270.COB)     INDATASET(MAP3270.PDSXMI(COB))
 RECEIVE DATASET(MAP3270.LOADLIB) INDATASET(MAP3270.PDSXMI(LOADLIB))
 RECEIVE DATASET(MAP3270.MAC3350) INDATASET(MAP3270.PDSXMI(MACLIB))
 RECEIVE DATASET(MAP3270.MAP)     INDATASET(MAP3270.PDSXMI(MAP))
 RECEIVE DATASET(MAP3270.PANEL)   INDATASET(MAP3270.PDSXMI(PANEL))
 RECEIVE DATASET(MAP3270.PANEL5)  INDATASET(MAP3270.PDSXMI(PANEL5))
 RECEIVE DATASET(MAP3270.PLI)     INDATASET(MAP3270.PDSXMI(PLI))
 RECEIVE DATASET(MAP3270.SOURCE)  INDATASET(MAP3270.PDSXMI(SOURCE))
 RECEIVE DATASET(MAP3270.SOURCE5) INDATASET(MAP3270.PDSXMI(SOURCE5))
//*
//*   THE .ASM AND .MACLIB WERE BUILD ON 3350 DASD.  SINCE TK5 HAS
//*   LARGER BLKSIZE, THESE DATASETS MUST BE REBLOCKED TO CONCAT
//*   WITH SYSTEM MACRO LIBRARIES (SYS1.MACLIB, SYS2.MACLIB)
//*
//STEP04 EXEC PGM=IEBCOPY
//ASM3350 DD DSN=HERC01.MAP3270.ASM3350,DISP=(OLD,DELETE,KEEP)
//MAC3350 DD DSN=HERC01.MAP3270.MAC3350,DISP=(OLD,DELETE,KEEP)
//ASM3390 DD DSN=HERC01.MAP3270.ASM,DISP=(NEW,CATLG),
//        UNIT=SYSDA,VOL=SER=TSO001,SPACE=(TRK,(3,3,3),RLSE),
//        DCB=(RECFM=FB,LRECL=80,BLKSIZE=27920,DSORG=PO)
//MAC3390 DD DSN=HERC01.MAP3270.MACLIB,DISP=(NEW,CATLG),
//        UNIT=SYSDA,VOL=SER=TSO001,SPACE=(TRK,(3,3,3),RLSE),
//        DCB=(RECFM=FB,LRECL=80,BLKSIZE=27920,DSORG=PO)
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 COPY INDD=ASM3350,OUTDD=ASM3390
 COPY INDD=MAC3350,OUTDD=MAC3390
//
