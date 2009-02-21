//
//  MyCustomView.m
//  RedSquare
//
//  Created by David Nolen on 2/16/09. Modified by Peter Horvath on 2/21/09.
//  Copyright 2009 David Nolen. All rights reserved.
//

#import "MyCustomView.h"

#define kAccelerometerFrequency        10 //Hz

@implementation MyCustomView

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
	}
	return self;
}

- (void) awakeFromNib
{
	// you have to initialize your view here since it's getting
	// instantiated by the nib
	squareSize = 100.0f;
	twoFingers = NO;
	oneFinger = NO;
	rotateLeft = NO;
	rotateRight = NO;
	rotationRight = 0.5f;
	rotationLeft = -0.5f;

	// You have to explicity turn on multitouch for the view
	self.multipleTouchEnabled = YES;
	
	// configure for accelerometer
	[self configureAccelerometer];
}

-(void)configureAccelerometer
{
	UIAccelerometer*  theAccelerometer = [UIAccelerometer sharedAccelerometer];
	
	if(theAccelerometer)
	{
		theAccelerometer.updateInterval = 1 / kAccelerometerFrequency;
		theAccelerometer.delegate = self;
	}
	else
	{
		NSLog(@"Oops we're not running on the device!");
	}
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	UIAccelerationValue x, y, z;
	x = acceleration.x;
	y = acceleration.y;
	z = acceleration.z;
	
	// Do something with the values.
	xField.text = [NSString stringWithFormat:@"%.5f", x];
	yField.text = [NSString stringWithFormat:@"%.5f", y];
	zField.text = [NSString stringWithFormat:@"%.5f", z];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"touches began count %d, %@", [touches count], touches);

	UITouch *theTouch = [touches anyObject];
	CGPoint point = [theTouch locationInView:nil]; //only used for log
	NSLog(@"touches began at x: %f and y: %f", point.x, point.y);
	
	if([touches count] == 1 && point.x < 160)
	{
		oneFinger = YES;
		rotateLeft = YES;
		NSLog(@"%d finger, left side", [touches count]);
	}

	else if([touches count] == 1 && point.x > 160)
	{
		oneFinger = YES;
		rotateRight = YES;
		NSLog(@"%d finger, right side", [touches count]);
	}
	
	else if([touches count] == 2)
	{
		twoFingers = YES;
		NSLog(@"%d fingers", [touches count]);
	}
	
	// tell the view to redraw
	[self setNeedsDisplay];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	//NSLog(@"touches moved count %d, %@", [touches count], touches);
		
	// tell the view to redraw
	[self setNeedsDisplay];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"touches moved count %d, %@", [touches count], touches);
	
	// reset the var
	twoFingers = NO;
	oneFinger = NO;
	rotateLeft = NO;
	rotateRight = NO;
	
	// tell the view to redraw
	[self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
	//NSLog(@"drawRect");
	
	CGFloat centerx = rect.size.width/2;
	CGFloat centery = rect.size.height/2;
	CGFloat half = squareSize/2;
	CGRect theRect = CGRectMake(-half, -half, squareSize, squareSize);
	
	// Grab the drawing context
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// like Processing pushMatrix
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, centerx, centery);
		
	// Set red stroke
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
	
	// Set different based on multitouch
	if(oneFinger && rotateLeft)
	{
		CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1.0);	
		CGContextRotateCTM(context, rotationLeft);
	}
	else if(oneFinger && rotateRight)
	{
		CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1.0);	
		CGContextRotateCTM(context, rotationRight);
	}	
	else if(twoFingers)
	{
		CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
	}
	else
	{
		CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
	}
	
	// Draw a rect with a red stroke
	CGContextFillRect(context, theRect);
	CGContextStrokeRect(context, theRect);
	
	// like Processing popMatrix
	CGContextRestoreGState(context);
}

- (void) dealloc
{
	[super dealloc];
}

@end