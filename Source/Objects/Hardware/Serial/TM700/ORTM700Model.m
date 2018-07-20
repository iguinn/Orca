//--------------------------------------------------------
// ORTM700Model
// Created by Mark  A. Howe on Mon 5/14/2012
// Code partially generated by the OrcaCodeWizard. Written by Mark A. Howe.
// Copyright (c) 2012 University of North Carolina. All rights reserved.
//-----------------------------------------------------------
//This program was prepared for the Regents of the University of 
//North Carolina sponsored in part by the United States 
//Department of Energy (DOE) under Grant #DE-FG02-97ER41020. 
//The University has certain rights in the program pursuant to 
//the contract and the program should not be copied or distributed 
//outside your organization.  The DOE and the University of 
//North Carolina reserve all rights in the program. Neither the authors,
//University of North Carolina, or U.S. Government make any warranty, 
//express or implied, or assume any liability or responsibility  
//for the use of this software.
//-------------------------------------------------------------

#pragma mark •••Imported Files

#import "ORTM700Model.h"
#import "ORSerialPort.h"
#import "ORSerialPortAdditions.h"

#pragma mark •••External Strings
NSString* ORTM700ModelInStandByChanged = @"ORTM700ModelInStandByChanged";
NSString* ORTM700ModelRunUpTimeChanged		= @"ORTM700ModelRunUpTimeChanged";
NSString* ORTM700ModelRunUpTimeCtrlChanged	= @"ORTM700ModelRunUpTimeCtrlChanged";
NSString* ORTM700ModelTmpRotSetChanged		= @"ORTM700ModelTmpRotSetChanged";
NSString* ORTM700ModelStationPowerChanged	= @"ORTM700ModelStationPowerChanged";
NSString* ORTM700ModelMotorPowerChanged		= @"ORTM700ModelMotorPowerChanged";
NSString* ORTM700ModelMotorCurrentChanged	= @"ORTM700ModelMotorCurrentChanged";
NSString* ORTM700ModelActualRotorSpeedChanged = @"ORTM700ModelActualRotorSpeedChanged";
NSString* ORTM700ModelSetRotorSpeedChanged	= @"ORTM700ModelSetRotorSpeedChanged";
NSString* ORTM700TurboStateChanged			= @"ORTM700TurboStateChanged";
NSString* ORTM700ModelDeviceAddressChanged	= @"ORTM700ModelDeviceAddressChanged";
NSString* ORTM700ModelPollTimeChanged		= @"ORTM700ModelPollTimeChanged";
NSString* ORTM700TurboAcceleratingChanged	= @"ORTM700TurboAcceleratingChanged";
NSString* ORTM700TurboSpeedAttainedChanged	= @"ORTM700TurboSpeedAttainedChanged";
NSString* ORTM700TurboOverTempChanged		= @"ORTM700TurboOverTempChanged";
NSString* ORTM700DriveOverTempChanged		= @"ORTM700DriveOverTempChanged";
NSString* ORTM700ModelErrorCodeChanged		= @"ORTM700ModelErrorCodeChanged";
NSString* ORTM700Lock						= @"ORTM700Lock";
NSString* ORTM700ConstraintsChanged			= @"ORTM700ConstraintsChanged";
NSString* ORTM700ConstraintsDisabledChanged    = @"ORTM700ConstraintsDisabledChanged";

#pragma mark •••Status Parameters

#define kStandby		2
#define kRunUpTimeCtrl	4
#define kMotorPower		23
#define kErrorAck       9
#define kStationPower	10

#define kErrorCode      303
#define kTempDriveUnit	304
#define kTempTurbo		305
#define kSpeedAttained	306
#define kAccelerating	307
#define kSetSpeed		308
#define kActualSpeed	309
#define kMotorCurrent	310

#define kRunUpTime		700
#define kTMPRotSet		707
#define kDeviceAddress	797

@interface ORTM700Model (private)
- (NSString*) formatExp:(float)aFloat;
- (void)	processOneCommandFromQueue;
- (int)		checkSum:(NSString*)aString;
- (void)	enqueCmdString:(NSString*)aString;
- (void)	processReceivedString:(NSString*)aCommand;
- (BOOL)	extractBool:(NSString*)aCommand;
- (int)		extractInt:(NSString*)aCommand;
- (float)	extractFloat:(NSString*)aCommand;
- (NSString*) extractString:(NSString*)aCommand;
- (void)	pollHardware;
- (void)	clearDelay;
- (void)    postCouchDBRecord;
@end

@implementation ORTM700Model
- (id) init
{
	self = [super init];
	
	runUpTime = 8; //default
	
	return self;
}

- (void) dealloc
{
	[inComingData release];
	[super dealloc];
}

- (void) wakeUp
{
	if(pollTime)[self pollHardware];
	[super wakeUp];
}

- (void) sleep
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super sleep];
}

- (void) setUpImage
{
	[self setImage:[NSImage imageNamed:@"TM700.tif"]];
}

- (void) makeMainController
{
	[self linkToController:@"ORTM700Controller"];
}

- (BOOL) acceptsGuardian: (OrcaObject *)aGuardian
{
	return [super acceptsGuardian:aGuardian] || 
		   [aGuardian isMemberOfClass:NSClassFromString(@"ORMJDVacuumModel")] || 
		   [aGuardian isMemberOfClass:NSClassFromString(@"ORMJDPumpCartModel")];
}

#pragma mark •••Accessors

- (BOOL) inStandBy
{
    return inStandBy;
}

- (void) setInStandBy:(BOOL)aInStandBy
{
    inStandBy = aInStandBy;

    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ModelInStandByChanged object:self];
}

- (NSString*) errorCode
{
    if(!errorCode)return @"";
    else return errorCode;
}

- (void) setErrorCode:(NSString *)aCode
{
    if(!aCode)aCode= @"";
    [errorCode autorelease];
    errorCode = [aCode copy];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ModelErrorCodeChanged object:self];
}

- (int) runUpTime
{
    return runUpTime;
}

- (void) setRunUpTime:(int)aRunUpTime
{
    [[[self undoManager] prepareWithInvocationTarget:self] setRunUpTime:runUpTime];
    runUpTime = aRunUpTime;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ModelRunUpTimeChanged object:self];
}

- (BOOL) runUpTimeCtrl
{
    return runUpTimeCtrl;
}

- (void) setRunUpTimeCtrl:(BOOL)aRunUpTimeCtrl
{
    runUpTimeCtrl = aRunUpTimeCtrl;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ModelRunUpTimeCtrlChanged object:self];
}

- (int) tmpRotSet
{
    return tmpRotSet;
}

- (void) setTmpRotSet:(int)aTmpRotSet
{
	if(aTmpRotSet<20)aTmpRotSet = 20;
	else if(aTmpRotSet>100)aTmpRotSet=100;
    [[[self undoManager] prepareWithInvocationTarget:self] setTmpRotSet:tmpRotSet];
    tmpRotSet = aTmpRotSet;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ModelTmpRotSetChanged object:self];
}

- (int) pollTime
{
    return pollTime;
}

- (void) setPollTime:(int)aPollTime
{
    [[[self undoManager] prepareWithInvocationTarget:self] setPollTime:pollTime];
    pollTime = aPollTime;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ModelPollTimeChanged object:self];
	
	if(pollTime){
		[self performSelector:@selector(pollHardware) withObject:nil afterDelay:pollTime];
	}
	else {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pollHardware) object:nil];
	}
}

- (BOOL) stationPower
{
    return stationPower;
}

- (void) setStationPower:(BOOL)aStationPower
{
    stationPower = aStationPower;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ModelStationPowerChanged object:self];
}

- (BOOL) motorPower
{
    return motorPower;
}

- (void) setMotorPower:(BOOL)aMotorPower
{
    motorPower = aMotorPower;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ModelMotorPowerChanged object:self];
}


- (float) motorCurrent
{
    return motorCurrent;
}

- (void) setMotorCurrent:(float)aMotorCurrent
{
    motorCurrent = aMotorCurrent;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ModelMotorCurrentChanged object:self];
}


- (int) actualRotorSpeed
{
    return actualRotorSpeed;
}

- (void) setActualRotorSpeed:(int)aActualRotorSpeed
{
    actualRotorSpeed = aActualRotorSpeed;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ModelActualRotorSpeedChanged object:self];
}

- (int) setRotorSpeed
{
    return setRotorSpeed;
}

- (void) setSetRotorSpeed:(int)aSetRotorSpeed
{
    setRotorSpeed = aSetRotorSpeed;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ModelSetRotorSpeedChanged object:self];
}

- (BOOL) turboAccelerating
{
    return turboAccelerating;
}

- (void) setTurboAccelerating:(BOOL)aTurboAccelerating
{
    turboAccelerating = aTurboAccelerating;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700TurboAcceleratingChanged object:self];
}

- (BOOL) speedAttained
{
    return speedAttained;
}

- (void) setSpeedAttained:(BOOL)aSpeedAttained
{
    speedAttained = aSpeedAttained;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700TurboSpeedAttainedChanged object:self];
}

- (BOOL) turboPumpOverTemp
{
    return turboPumpOverTemp;
}

- (void) setTurboPumpOverTemp:(BOOL)aTurboPumpOverTemp
{
    turboPumpOverTemp = aTurboPumpOverTemp;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700TurboOverTempChanged object:self];
}

- (BOOL) driveUnitOverTemp
{
    return driveUnitOverTemp;
}

- (void) setDriveUnitOverTemp:(BOOL)aDriveUnitOverTemp
{
    driveUnitOverTemp = aDriveUnitOverTemp;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700DriveOverTempChanged object:self];
}

- (int) deviceAddress
{
    return deviceAddress;
}

- (void) setDeviceAddress:(int)aDeviceAddress
{
	if(aDeviceAddress<1)aDeviceAddress = 1;
	else if(aDeviceAddress>255)aDeviceAddress= 255;
	
    [[[self undoManager] prepareWithInvocationTarget:self] setDeviceAddress:deviceAddress];
	//if([serialPort isOpen]){
		//[self sendDataSet:kDeviceAddress integer:aDeviceAddress];
		//}
    deviceAddress = aDeviceAddress;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ModelDeviceAddressChanged object:self];
}

- (void) setUpPort
{
	[serialPort setSpeed:9600];
	[serialPort setParityNone];
	[serialPort setStopBits2:NO];
	[serialPort setDataBits:8];
}

- (void) firstActionAfterOpeningPort
{
	[self performSelector:@selector(updateAll) withObject:nil afterDelay:1]; 
}

#pragma mark •••Archival
- (id) initWithCoder:(NSCoder*)decoder
{
	self = [super initWithCoder:decoder];
	[[self undoManager] disableUndoRegistration];
	[self setRunUpTime:     [decoder decodeIntForKey:   @"runUpTime"]];
	[self setTmpRotSet:		[decoder decodeIntForKey:	@"tmpRotSet"]];
	[self setPollTime:		[decoder decodeIntForKey:	@"pollTime"]];
	[self setDeviceAddress:	[decoder decodeIntForKey:	@"deviceAddress"]];
	[[self undoManager] enableUndoRegistration];
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeInteger:runUpTime        forKey: @"runUpTime"];
    [encoder encodeInteger:tmpRotSet		forKey: @"tmpRotSet"];
    [encoder encodeInteger:deviceAddress	forKey: @"deviceAddress"];
    [encoder encodeInteger:pollTime			forKey: @"pollTime"];
}

#pragma mark •••HW Methods
- (void) initUnit
{
	[self sendTmpRotSet:[self tmpRotSet]];
	if([self runUpTime] == 0){
		[self sendRunUpTimeCtrl:NO];
	}
	else {
		[self sendRunUpTimeCtrl:YES];
		[self sendRunUpTime:[self runUpTime]];
	}
}

- (void) getDeviceAddress	{ [self sendDataRequest:kDeviceAddress]; }
- (void) getTMPRotSet		{ [self sendDataRequest:kTMPRotSet]; }
- (void) getTurboTemp		{ [self sendDataRequest:kTempTurbo]; }
- (void) getDriveTemp		{ [self sendDataRequest:kTempDriveUnit]; }
- (void) getSpeedAttained	{ [self sendDataRequest:kSpeedAttained]; }
- (void) getAccelerating	{ [self sendDataRequest:kAccelerating]; }
- (void) getSetSpeed		{ [self sendDataRequest:kSetSpeed]; }
- (void) getActualSpeed		{ [self sendDataRequest:kActualSpeed]; }
- (void) getMotorCurrent	{ [self sendDataRequest:kMotorCurrent]; }
- (void) getMotorPower		{ [self sendDataRequest:kMotorPower]; }
- (void) getStationPower	{ [self sendDataRequest:kStationPower]; }
- (void) getStandby			{ [self sendDataRequest:kStandby]; }
- (void) getRunUpTimeCtrl	{ [self sendDataRequest:kRunUpTimeCtrl]; }
- (void) getRunUpTime		{ [self sendDataRequest:kRunUpTime]; }
- (void) getErrorCode		{ [self sendDataRequest:kErrorCode]; }

- (void) updateAll
{
	[self getTurboTemp];
	[self getDriveTemp];
	[self getAccelerating];
	[self getSpeedAttained];
	[self getSetSpeed];
	[self getActualSpeed];
	[self getMotorCurrent];
	[self getStandby];
	[self getStationPower];
	[self getMotorPower];
	[self getRunUpTimeCtrl];
	[self getErrorCode];
}

- (void) sendErrorAck
{
	[self sendDataSet:kErrorAck bool:1];
    [self getErrorCode];
}

- (void) sendTmpRotSet:(int)aValue
{
	[self sendDataSet:kTMPRotSet real:aValue];
}

- (void) sendMotorPower:(BOOL)aState
{
	[self sendDataSet:kMotorPower bool:aState];
}

- (void) sendStationPower:(BOOL)aState
{
	[self sendDataSet:kStationPower bool:aState];
}

- (void) sendStandby:(BOOL)aState
{
	[self sendDataSet:kStandby bool:aState];
}

- (void) sendRunUpTimeCtrl:(BOOL)aState
{
	[self sendDataSet:kRunUpTimeCtrl bool:aState];
}

- (void) sendRunUpTime:(int)aValue
{
	[self sendDataSet:kRunUpTime integer:aValue];
}

- (void) turnStationOn
{
	[self initUnit];
	[self sendStationPower:YES];
	[self sendStandby:YES];
	[self sendMotorPower:YES];
	[self performSelector:@selector(updateAll) withObject:nil afterDelay:1];
}

- (void) turnStationOff
{
    
    if([[self pumpOffConstraints]count] && constraintsDisabled){
        NSLogColor([NSColor redColor],@"The turbopump was turned off with constraints in place:\n");
        NSLogColor([NSColor redColor],@"%@",[self pumpOffConstraintReport]);
    }
    
	[self sendMotorPower:NO];
	[self sendStationPower:NO];
	[self sendStandby:NO];
}

//------------------------------------------------------------------------------------
//some extra convenience methods that are common to several objects
- (NSString*) auxStatusString:(int)aChannel
{
	if([self isValid]){
		if(stationPower){
			if(turboAccelerating)return @"ACCEL";
			else return @"ON";
		}
		else return @"OFF";
	}
	else return @"?";
}



- (BOOL) isOn:(int)aChannel
{
	return stationPower;
}
//------------------------------------------------------------------------------------

#pragma mark •••Commands
- (void) sendDataRequest:(int)aParamNum 
{
	//---------------------------
	//format of a data request
	//xxx00yyy02=?zzz\r
	//xxx = device address
	//yyy = parameter number
	//zzz = checksum
	//---------------------------
	NSString* cmdString = [NSString stringWithFormat:@"%03d00%03d02=?",deviceAddress,aParamNum];
	cmdString = [cmdString stringByAppendingFormat:@"%03d\r",[self checkSum:cmdString]];
	[self enqueCmdString:cmdString];
	
	//-VVVVVVVVVVVVVVVVVVVVV
	//for testing only.  Echoes back a response......
	//NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
	//NSString* s = [NSString stringWithFormat:@"%03d00%03d061.2E-2",deviceAddress,aParamNum];
	//s = [s stringByAppendingFormat:@"%03d\r",[self checkSum:cmdString]];

	//[userInfo setObject:[s dataUsingEncoding:NSASCIIStringEncoding] forKey:@"data"];
	//NSNotification* note =  [NSNotification notificationWithName:@"junk" object:nil userInfo:userInfo]; 
	//[self dataReceived:note];
	//-^^^^^^^^^^^^^^^^^^^^^^^
}

//---------------------------
//format of a data set
//xxx10yyyLLDD..DDzzz\r
//xxx = device address
//yyy = parameter number
//LL  = data length
//DD..DD = the data (variable length
//zzz = checksum
//---------------------------

- (void) sendDataSet:(int)aParamNum bool:(BOOL)aState 
{
	NSString* trueString = @"111111";
	NSString* falseString = @"000000";
	NSString* cmdString = [NSString stringWithFormat:@"%03d10%03d06%@",deviceAddress,aParamNum,aState?trueString:falseString];
	cmdString = [cmdString stringByAppendingFormat:@"%03d\r",[self checkSum:cmdString]];
	[self enqueCmdString:cmdString];
}

- (void) sendDataSet:(int)aParamNum integer:(unsigned int)anInt 
{
	NSString* cmdString = [NSString stringWithFormat:@"%03d10%03d06%06u",deviceAddress,aParamNum,anInt];
	cmdString = [cmdString stringByAppendingFormat:@"%03d\r",[self checkSum:cmdString]];
	[self enqueCmdString:cmdString];
}

- (void) sendDataSet:(int)aParamNum real:(float)aFloat 
{
	NSString* cmdString = [NSString stringWithFormat:@"%03d10%03d06%06d",deviceAddress,aParamNum,(int)(aFloat*100)];
	cmdString = [cmdString stringByAppendingFormat:@"%03d\r",[self checkSum:cmdString]];
	[self enqueCmdString:cmdString];
}

- (void) sendDataSet:(int)aParamNum expo:(float)aFloat 
{
	NSString* cmdString = [NSString stringWithFormat:@"%03d10%03d06%@",deviceAddress,aParamNum,[self formatExp:aFloat]];
	cmdString = [cmdString stringByAppendingFormat:@"%03d\r",[self checkSum:cmdString]];
	[self enqueCmdString:cmdString];
}

- (void) sendDataSet:(int)aParamNum shortInteger:(unsigned short)aShort 
{
	NSString* cmdString = [NSString stringWithFormat:@"%03d10%03d03%03u",deviceAddress,aParamNum,aShort];
	cmdString = [cmdString stringByAppendingFormat:@"%03d\r",[self checkSum:cmdString]];
	[self enqueCmdString:cmdString];
}

- (void) dataReceived:(NSNotification*)note
{
	if(!lastRequest)return;
	
    if([[note userInfo] objectForKey:@"serialPort"] == serialPort){
		if(!inComingData)inComingData = [[NSMutableData data] retain];
		[inComingData appendData:[[note userInfo] objectForKey:@"data"]];
		
		char* p = (char*)[inComingData bytes];
		int i;
		int numCharsProcessed=0;
		NSMutableData* cmd =  [NSMutableData dataWithCapacity:64];
		for(i=0;i<[inComingData length];i++){
			[cmd appendBytes:p length:1];
			if(*p == '\r'){
				NSString* s = [[[NSString alloc] initWithData:cmd encoding:NSASCIIStringEncoding] autorelease];
				numCharsProcessed += [cmd length];
				[cmd setLength:0];
				if([s rangeOfString:@"=?"].location == NSNotFound){
					//NSLog(@"received: %@\n",s);
					[self processReceivedString:s];
				}
			}
			p++;
		}
		if(numCharsProcessed){
			[inComingData replaceBytesInRange:NSMakeRange(0,numCharsProcessed) withBytes:nil length:0];
		}
	}
}

- (void) recoverFromTimeout
{
	//there was a timout on the serial line, try again.
	[self pollHardware];
}

- (void) decode:(int)paramNumber command:(NSString*)aCommand
{
	switch (paramNumber) {
		case kDeviceAddress: [self setDeviceAddress:	[self extractInt:aCommand]];    break;
		case kStationPower:	 [self setStationPower:		[self extractBool:aCommand]];   break;
		case kMotorPower:	 [self setMotorPower:		[self extractBool:aCommand]];   break;
		case kTempDriveUnit: [self setDriveUnitOverTemp:[self extractBool:aCommand]];   break;
		case kTempTurbo:	 [self setTurboPumpOverTemp:[self extractBool:aCommand]];   break;
		case kSpeedAttained: [self setSpeedAttained:	[self extractBool:aCommand]];   break;
		case kAccelerating:  [self setTurboAccelerating:[self extractBool:aCommand]];   break;
		case kRunUpTimeCtrl: [self setRunUpTimeCtrl:	[self extractBool:aCommand]];   break;
		case kErrorCode:     [self setErrorCode:        [self extractString:aCommand]]; break;

		case kStandby:		[self setInStandBy:         [self extractBool:aCommand]];   break;
		case kSetSpeed:		[self setSetRotorSpeed:		[self extractInt:aCommand]];    break;
		case kActualSpeed:  [self setActualRotorSpeed:	[self extractInt:aCommand]];    break;
		case kMotorCurrent: [self setMotorCurrent:		[self extractFloat:aCommand]];  break;
		default:
		break;
	}
}

#pragma mark •••Bit Processing Protocol
- (void) processIsStarting { }
- (void) processIsStopping { }
- (void) startProcessCycle { }
- (void) endProcessCycle   { }

- (NSString*) identifier
{
	NSString* s;
 	@synchronized(self){
		s= [NSString stringWithFormat:@"TM700,%u",[self uniqueIdNumber]];
	}
	return s;
}

- (NSString*) processingTitle
{
	NSString* s;
 	@synchronized(self){
		s= [self identifier];
	}
	return s;
}

- (BOOL) processValue:(int)channel
{
	BOOL theValue = 0;
	@synchronized(self){
		switch(channel){
			case 0: theValue = 	[self speedAttained];	break;
		}
	}
	return theValue;
}

- (void) setProcessOutput:(int)channel value:(int)value { }


#pragma mark •••Constraints
- (void) addPumpOffConstraint:(NSString*)aName reason:(NSString*)aReason
{
	if(!pumpOffConstraints)pumpOffConstraints = [[NSMutableDictionary dictionary] retain];
	[pumpOffConstraints setObject:aReason forKey:aName];
	[[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ConstraintsChanged object:self];
}
- (void) removePumpOffConstraint:(NSString*)aName
{
	[pumpOffConstraints removeObjectForKey:aName];
	[[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ConstraintsChanged object:self];
}

- (NSDictionary*)pumpOffConstraints		 { return pumpOffConstraints; }

- (NSString*) pumpOffConstraintReport
{
    NSString* s=@"";
    for(id aKey in pumpOffConstraints){
        s = [s stringByAppendingFormat:@"%@ : %@\n",aKey,[pumpOffConstraints objectForKey:aKey]];
    }
    return s;
}

- (void) disableConstraints
{
    constraintsDisabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ConstraintsDisabledChanged object:self];
}

- (void) enableConstraints
{
    constraintsDisabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORTM700ConstraintsDisabledChanged object:self];
}

- (BOOL) constraintsDisabled
{
    return constraintsDisabled;
}


@end

@implementation ORTM700Model (private)
- (BOOL)  extractBool: (NSString*)aCommand	{ return [[aCommand substringWithRange:NSMakeRange(10,6)] intValue]!=0; }
- (int)   extractInt:  (NSString*)aCommand	{ return [[aCommand substringWithRange:NSMakeRange(10,6)] intValue]; }
- (float) extractFloat:(NSString*)aCommand	{ return [[aCommand substringWithRange:NSMakeRange(10,6)] floatValue]; }
- (NSString*) extractString:(NSString*)aCommand	
{
	int numChars = [[aCommand substringWithRange:NSMakeRange(8,2)] intValue];
	return [aCommand substringWithRange:NSMakeRange(10,numChars)];
}

- (void) clearDelay
{
	delay = NO;
	[self processOneCommandFromQueue];
}


- (void) processOneCommandFromQueue
{
    if(delay) return;
	
	NSString* cmdString = [self nextCmd];
	if(cmdString){
		if([cmdString isEqualToString:@"++Delay"]){
			delay = YES;
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearDelay) object:nil];
			[self performSelector:@selector(clearDelay) withObject:nil afterDelay:.2];
		}
		else {
            [self setLastRequest:cmdString];
            [serialPort writeDataInBackground:[cmdString dataUsingEncoding:NSASCIIStringEncoding]];
			[self startTimeout:3];
        }
	}

}

- (int) checkSum:(NSString*)aString
{
	int i;
	int sum = 0;
	for(i=0;i<[aString length];i++){
		sum += (int)[aString characterAtIndex:i];
	}
	return sum%256;
}

- (void) enqueCmdString:(NSString*)aString
{
	[self enqueueCmd:aString];
	[self enqueueCmd:@"++Delay"];
	if(!lastRequest)[self processOneCommandFromQueue];
}

- (NSString*) formatExp:(float)aFloat
{
	NSString* s = [NSString stringWithFormat:@"%.1E",aFloat];
	NSArray* parts = [s componentsSeparatedByString:@"E"];
	float m = [[parts objectAtIndex:0] floatValue];
	int e = [[parts objectAtIndex:1] intValue];
	s= [NSString stringWithFormat:@"%.1fE%d",m,e];
	s = [[s componentsSeparatedByString:@".0"] componentsJoinedByString:@""];
	NSInteger len = [s length];
	if(len<6){
		int i;
		for(i=0;i<6-len;i++){
			s = [NSString stringWithFormat:@"0%@",s];
		}
	}
	return s;
}

- (void) processReceivedString:(NSString*)aCommand
{
	//double check that the device address matches.
	int anAddress = [[aCommand substringToIndex:3] intValue];
	if(anAddress == deviceAddress){
		[self cancelTimeout];
		[self setIsValid:YES];
		int receivedParam = [[aCommand substringWithRange:NSMakeRange(5,3)] intValue];
		[self decode:receivedParam command:aCommand];
	
		if(lastRequest){
			//if the param number matches the last cmd sent, then assume a match and remove the timeout
			int lastParam	  = [[lastRequest    substringWithRange:NSMakeRange(5,3)] intValue];
			if(receivedParam == lastParam){
				[self setLastRequest:nil];			 //clear the last request
                [self processOneCommandFromQueue];	 //do the next command in the queue
			}
		}
	}
}

- (void) pollHardware
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pollHardware) object:nil];
	[self updateAll];
    [self postCouchDBRecord];
	[self performSelector:@selector(pollHardware) withObject:nil afterDelay:pollTime];
}

- (void) postCouchDBRecord
{
    
    NSDictionary* values = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:   stationPower],      @"stationPower",
                            [NSNumber numberWithBool:   motorPower],        @"motorPower",
                            [NSNumber numberWithInt:    setRotorSpeed],     @"setRotorSpeed",
                            [NSNumber numberWithInt:    actualRotorSpeed],  @"actualRotorSpeed",
                            [NSNumber numberWithFloat:  motorCurrent],      @"motorCurrent",
                            [NSNumber numberWithBool:   driveUnitOverTemp], @"driveUnitOverTemp",
                            [NSNumber numberWithBool:   turboPumpOverTemp], @"turboPumpOverTemp",
                            [NSNumber numberWithInt:    runUpTime],         @"runUpTime",
                            [NSNumber numberWithInt:    pollTime],          @"pollTime",
                            [NSNumber numberWithBool:   speedAttained],     @"speedAttained",
                            nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ORCouchDBAddObjectRecord" object:self userInfo:values];
}
@end
