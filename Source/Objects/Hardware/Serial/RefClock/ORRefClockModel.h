//--------------------------------------------------------
// ORRefClockModel
// Created by Mark  A. Howe on Fri Jul 22 2005 / Julius Hartmann, KIT, November 2017
// Code partially generated by the OrcaCodeWizard. Written by Mark A. Howe.
// Copyright (c) 2005 CENPA, University of Washington. All rights reserved.
//-----------------------------------------------------------
//This program was prepared for the Regents of the University of
//Washington at the Center for Experimental Nuclear Physics and
//Astrophysics (CENPA) sponsored in part by the United States
//Department of Energy (DOE) under Grant #DE-FG02-97ER41020.
//The University has certain rights in the program pursuant to
//the contract and the program should not be copied or distributed
//outside your organization.  The DOE and the University of
//Washington reserve all rights in the program. Neither the authors,
//University of Washington, or U.S. Government make any warranty,
//express or implied, or assume any liability or responsibility
//for the use of this software.
//-------------------------------------------------------------

#pragma mark ***Imported Files


#import "ORSerialPortWithQueueModel.h"

@class ORSynClockModel;
@class ORMotoGPSModel;

@interface ORRefClockModel : ORSerialPortWithQueueModel
{
    @private
        ORSynClockModel* synClockModel;
        ORMotoGPSModel*  motoGPSModel;
        NSMutableData*	 inComingData;
        BOOL             verbose;
        BOOL             statusPoll;
        struct timeval   orcaRefClkTime;
//        NSString*        portName;  // port name alredy stored in baseclass
        float            pollDelay; //10.0; // Seconds
}

#pragma mark ***Initialization
- (void) dealloc;
- (void) dataReceived:(NSNotification*)note;

#pragma mark ***Accessors
- (ORSynClockModel*) synClockModel;
- (ORMotoGPSModel*)  motoGPSModel;
- (BOOL) verbose;
- (void) setVerbose:(BOOL)aVerbose;
- (void) openPort:(BOOL)state;
- (void) setLastRequest:(NSDictionary*)aRequest;
- (BOOL) statusPoll;
- (void) setStatusPoll:(BOOL)aStatusPoll;
- (long) lastMessagesAge;
- (float) pollDelay;

#pragma mark ***Commands
- (void) addCmdToQueue:(NSDictionary*)aCmd;
- (void) dataReceived:(NSNotification*)note;
- (void) serialPortWriteProgress:(NSDictionary *)dataDictionary;
- (BOOL) portIsOpen;

#pragma mark ***Archival
- (id)   initWithCoder:(NSCoder*)decoder;
- (void) encodeWithCoder:(NSCoder*)encoder;

@end

extern NSString* ORRefClockLock;
extern NSString* ORRefClockModelSerialPortChanged;
extern NSString* ORRefClockModelVerboseChanged;
extern NSString* ORRefClockModelUpdatedQueue;
extern NSString* ORRefClockModelStatusPollChanged;

extern NSString* ORSynClock;
extern NSString* ORMotoGPS;
