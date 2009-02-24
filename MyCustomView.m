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
	rotation = 0;
	oneFinger = NO;
	twoFingers = NO;
	
	// You have to explicity turn on multitouch for the view
	self.multipleTouchEnabled = YES;
	
	// configure for accelerometer
	[self configureAccelerometer];
}

-(void)configureAccelerometer
{
	UIAccelerometer* theAccelerometer = [UIAccelerometer sharedAccelerometer];
	
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

	touches = [event allTouches];

	UITouch *theTouch = [touches anyObject];
	CGPoint point = [theTouch locationInView:nil]; // only used for log
	NSLog(@"x: %f and y: %f", point.x, point.y);
	
	if([touches count] == 1)
	{
		oneFinger = YES;
		NSLog(@"%d finger", [touches count]);
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

	touches = [event allTouches];
	
	if(twoFingers) {
		NSArray *twoTouches = [touches allObjects];
			
		UITouch *touch1 = [twoTouches objectAtIndex:0];
		UITouch *touch2 = [twoTouches objectAtIndex:1];
		
		CGPoint currentPoint1 = [touch1 locationInView:nil];
		CGPoint currentPoint2 = [touch2 locationInView:nil];
		CGFloat currentAngle = atan2 (currentPoint2.y - currentPoint1.y, currentPoint2.x - currentPoint1.x);
		
		rotation = currentAngle;
		squareSize = currentPoint1.y - currentPoint2.y;

		rField.text = [NSString stringWithFormat:@"%.5f", rotation];
		sField.text = [NSString stringWithFormat:@"%.5f", squareSize];
		
		// tell the view to redraw
		[self setNeedsDisplay];
	}
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"touches moved count %d, %@", [touches count], touches);
	
	// reset the var
	oneFinger = NO;
	twoFingers = NO;

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
		
	if(oneFinger)
	{
		CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
		CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);		
	}
	else if(twoFingers)
	{
		CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
		CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1.0);	
		CGContextRotateCTM(context, rotation);	
	}
	else
	{
		CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
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