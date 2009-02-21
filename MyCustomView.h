//
//  MyCustomView.h
//  RedSquare
//
//  Created by David Nolen on 2/16/09. Modified by Peter Horvath on 2/21/09.
//  Copyright 2009 David Nolen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyCustomView : UIView 
{
	CGFloat                    squareSize;
	CGFloat                    rotationLeft;
	CGFloat                    rotationRight;
	CGColorRef                 aColor;
	BOOL                       twoFingers;
	BOOL                       oneFinger;
	BOOL                       rotateLeft;
	BOOL                       rotateRight;
	
	
	IBOutlet UILabel           *xField;
	IBOutlet UILabel           *yField;
	IBOutlet UILabel           *zField;
}


@end
