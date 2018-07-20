//--------------------------------------------------------
// ORcPCIcpuController
// Created by Mark  A. Howe on Tue Feb 07 2006
// Code partially generated by the OrcaCodeWizard. Written by Mark A. Howe.
// Copyright (c) 2006 CENPA, University of Washington. All rights reserved.
//--------------------------------------------------------
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

#import "OrcaObjectController.h"

@class ORQueueView;
@class ORTimedTextField;
@class ORValueBar;
@class ORCompositePlotView;
@class ORAxis;

@interface SBC_LinkController : OrcaObjectController
{
	IBOutlet NSButton*				lockButton;
	IBOutlet NSTabView*				tabView;
    IBOutlet ORGroupView*			groupView;

	//code management
	IBOutlet NSButton*		setFilePathButton;
	IBOutlet NSButton*      toggleCrateButton;
	IBOutlet NSButton*      verboseButton;
	IBOutlet NSButton*      forceReloadButton;
	IBOutlet ORTimedTextField*  statusField;
	IBOutlet NSTextField*   connectionStatusField;
	IBOutlet NSButton*      killCrateButton;
	IBOutlet NSMatrix*		loadModeMatrix;
	IBOutlet NSTextField*   filePathField;
    IBOutlet NSPanel*		passWordPanel;
    IBOutlet NSPanel*		setTimePanel;

    IBOutlet NSTextField*   rootPassWordField;
    IBOutlet NSTextField*   setTimePassWordField;
    
	IBOutlet NSTextField*   driverPassWordField;
	IBOutlet NSMatrix*		rebootMatrix;
	IBOutlet NSButton*		downloadDriverButton;
    IBOutlet NSPanel*		driverInstallPanel;
	IBOutlet NSTextField*   driverScriptInfoField;
	IBOutlet NSTextField*   shutdown1Field;
	IBOutlet NSTextField*   shutdown2Field;
	IBOutlet NSButton*		shutdownButton;
	IBOutlet NSButton*		shutdownRebootButton;
    IBOutlet NSButton*		checkVersionButton;
    IBOutlet NSButton*		checkTimeButton;
    IBOutlet NSButton*		setTimeButton;
    IBOutlet NSTextField*   timeSkewField;

	//Monitoring
	IBOutlet NSTextField*   runInfoField;
	IBOutlet ORQueueView*   queView;
	IBOutlet ORValueBar*    bytesSentRateBar;
	IBOutlet ORValueBar*    bytesReceivedRateBar;	
	IBOutlet ORAxis*		bytesReceivedRateAxis;	
	IBOutlet NSTextField*   byteRateSentField;
	IBOutlet NSTextField*   byteRateReceivedField;
	IBOutlet NSMatrix*      infoTypeMatrix;
	IBOutlet NSTextField*   cbPercentField;

	//IP Settings
	IBOutlet NSComboBox*	ipNumberComboBox;
	IBOutlet NSTextField*	portNumberField;
	IBOutlet NSTextField*	irqNumberField;
	IBOutlet NSSecureTextField* passWordField;
	IBOutlet NSTextField*   userNameField;
	IBOutlet NSTextField*	connectionStatus1Field;
	IBOutlet NSButton*		initAfterConnectButton;
	IBOutlet NSButton*		connectButton;
	IBOutlet NSButton*		connect1Button;
	IBOutlet NSTextField*	status1Field;
	IBOutlet NSPopUpButton* errorTimeOutPU;
	IBOutlet NSButton*		clearHistoryButton;
    IBOutlet NSPopUpButton* sbcPollingPU;
    IBOutlet NSMatrix*      disableThrottleMatrix;

	//Basic Ops
	IBOutlet NSTextField*	functionAllowedField;
	IBOutlet NSTextField*	addressField;
	IBOutlet NSStepper*		addressStepper;
	IBOutlet NSTextField*	writeValueField;
	IBOutlet NSStepper*		writeValueStepper;
	IBOutlet NSButton*		readButton;
	IBOutlet NSButton*		writeButton;
	IBOutlet NSButton*		resetCrateBusButton;
	IBOutlet NSTextField*	rangeTextField;
	IBOutlet NSStepper* 	rangeStepper;
	IBOutlet NSButton*		doRangeButton;
	IBOutlet NSMatrix*      readWriteTypeMatrix;
	IBOutlet NSPopUpButton* addressModifierPU;
	IBOutlet NSTextField*	codeVersionField;

	//TCP/IP Tuning
	IBOutlet NSButton*		pingButton;
	IBOutlet NSProgressIndicator* pingTaskProgress;
	IBOutlet NSButton*		cbTestButton;
	IBOutlet NSProgressIndicator* cbTestProgress;
	IBOutlet ORCompositePlotView*	plotter;
	IBOutlet ORCompositePlotView*	histogram;
	IBOutlet NSTextField*	numTestPointsField;
	IBOutlet NSTextField*	numRecordsField;
	IBOutlet NSTextField*	numErrorsField;
	IBOutlet NSTextField*	payloadSizeField;
	IBOutlet NSSlider*		payloadSizeSlider;
}

#pragma mark ¥¥¥Initialization
- (void) dealloc;
- (void) awakeFromNib;

#pragma mark ¥¥¥Notifications

- (void) registerNotificationObservers;
- (void) updateWindow;

#pragma mark ***Interface Management
- (void) disableThrottleChanged:(NSNotification*)aNote;
- (void) codeVersionChanged:(NSNotification*)aNote;
- (void) settingsLockChanged:(NSNotification*)aNote;
- (void) numTestPointsChanged:(NSNotification*)aNote;
- (void) filePathChanged:(NSNotification*)aNote;
- (void) verboseChanged:(NSNotification*)aNote;
- (void) forceReloadChanged:(NSNotification*)aNote;
- (void) startStatusChanged:(NSNotification*)aNote;
- (void) setToggleCrateButtonState;
- (void) loadModeChanged:(NSNotification*)aNote;
- (void) sbcPollingTimeChanged:(NSNotification*)aNote;

- (void) byteRateChanged:(NSNotification*)aNote;
- (void) statusInfoChanged:(NSNotification*)aNote;
- (void) infoTypeChanged:(NSNotification*)aNote;

- (void) initAfterConnectChanged:(NSNotification*)aNote;
- (void) startStatusChanged:(NSNotification*)aNote;
- (void) sbcLockChanged:(NSNotification*)aNote;
- (void) userNameChanged:(NSNotification*)aNote;
- (void) passWordChanged:(NSNotification*)aNote;
- (void) ipNumberChanged:(NSNotification*)aNote;
- (void) portNumberChanged:(NSNotification*)aNote;
- (void) lamSlotChanged:(NSNotification*)aNotification;
- (void) errorTimeOutChanged:(NSNotification*)aNote;

- (void) addressChanged:(NSNotification*)aNote;
- (void) writeValueChanged:(NSNotification*)aNote;
- (void) rangeChanged:(NSNotification*)aNote;
- (void) doRangeChanged:(NSNotification*)aNote;
- (void) readWriteTypeChanged:(NSNotification*)aNote;
- (void) addressModifierChanged:(NSNotification*)aNote;
- (void) pingTaskChanged:(NSNotification*)aNote;
- (void) cbTestChanged:(NSNotification*)aNote;
- (void) payloadSizeChanged:(NSNotification*)aNote;

- (void) timeSkewChanged:(NSNotification*)aNote;

- (NSString*) errorString:(int)errNum;
- (NSString*) literalToString:(int)aLiteral;
- (void) setDriverInfo;

#pragma mark ¥¥¥Actions
- (IBAction) clearHistory:(id) sender;
- (IBAction) lockAction:(id)sender;

- (IBAction) loadModeAction:(id)sender;
- (IBAction) filePathAction:(id)sender;
- (IBAction) verboseAction:(id)sender;
- (IBAction) forceReloadAction:(id)sender;
- (IBAction) toggleCrateAction:(id)sender;
- (IBAction) killCrateAction:(id)sender;
- (IBAction) shutdownAction:(id)sender;    
- (IBAction) closePassWordPanel:(id)sender;
- (IBAction) rebootHaltSelectionAction:(id)sender;
- (IBAction) closeSetTimePanel:(id)sender;

- (IBAction) initAfterConnectAction:(id)sender;
- (IBAction) ipNumberAction:(id)sender;
- (IBAction) portNumberAction:(id)sender;
- (IBAction) userNameAction:(id)sender;
- (IBAction) passWordAction:(id)sender;
- (IBAction) connectionAction:(id)sender;
- (IBAction) errorTimeOutAction:(id)sender;
- (IBAction) disableThrottleAction:(id)sender;

- (IBAction) addressAction:(id)sender;
- (IBAction) writeValueAction:(id)sender;
- (IBAction) writeAction:(id)sender;
- (IBAction) readAction:(id)sender;
- (IBAction) resetCrateBusAction:(id)sender;

- (IBAction) rangeTextFieldAction:(id)sender;
- (IBAction) doRangeAction:(id)sender;
- (IBAction) readWriteTypeMatrixAction:(id)sender;
- (IBAction) addressModifierPUAction:(id)sender;

- (IBAction) infoTypeAction:(id)sender;
- (IBAction) ping:(id)sender;
- (IBAction) cbTest:(id)sender;
- (IBAction) numTestPointsAction:(id)sender;
- (IBAction) payloadSizeAction:(id)sender;
- (IBAction) downloadDriverAction:(id)sender;
- (IBAction) closeDriverInstallPanel:(id)sender;
- (IBAction) getSbcCodeVersion:(id)sender;
- (IBAction) checkTimeAction:(id)sender;
- (IBAction) setTimeAction:(id)sender;
- (IBAction) sbcPollingTimeAction:(id)sender;

#pragma mark ¥¥¥DataSource
- (void) tabView:(NSTabView*)aTabView didSelectTabViewItem:(NSTabViewItem*)item;
- (void) getQueMinValue:(uint32_t*)aMinValue maxValue:(uint32_t*)aMaxValue head:(uint32_t*)aHeadValue tail:(uint32_t*)aTailValue;

- (int)	numberPointsInPlot:(id)aPlotter;
- (void) plotter:(id)aPlotter index:(uint32_t)index x:(double*)xValue y:(double*)yValue;
- (BOOL) plotter:(id)aPlotter crossHairX:(double*)xValue crossHairY:(double*)yValue;

@end

@interface OrcaObject (SBC_Link)
- (BOOL) showBasicOps;
@end
