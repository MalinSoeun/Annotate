//
//  DrawingView.m
//  anotate
//
//  Created by Malin on 2016-05-05.
//  Copyright © 2016 Malin Soeun. All rights reserved.
//

#import "DrawingView.h"

@interface DrawingView ()

@property (strong) NSMutableArray *lines;
@property (strong) NSMutableArray *lastLine;

@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;
@property CGFloat brush;
@property CGFloat opacity;

@end

@implementation DrawingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _red = 0.0/255.0;
        _green = 0.0/255.0;
        _blue = 0.0/255.0;
        _brush = 5.0;
        _opacity = 1.0;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self){
        _red = 0.0/255.0;
        _green = 0.0/255.0;
        _blue = 0.0/255.0;
        _brush = 5.0;
        _opacity = 1.0;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - touches Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // get current point
    CGPoint currentPoint = [touch locationInView:self];
    
    if ( nil == _lines )
    {
        _lines = [[NSMutableArray alloc] init];
    }
    
    _lastLine = [[NSMutableArray alloc] init];
    
    // add new line to lines
    [_lines addObject:_lastLine];
    
    // add current point to line
    [_lastLine addObject:[NSValue valueWithCGPoint:currentPoint]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // get current point
    CGPoint currentPoint = [touch locationInView:self];
    
    // add current point to line
    [_lastLine addObject:[NSValue valueWithCGPoint:currentPoint]];
    
    //redraw view
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // get current point
    CGPoint currentPoint = [touch locationInView:self];
    
    // add current point to line
    [_lastLine addObject:[NSValue valueWithCGPoint:currentPoint]];
    
    //redraw view
    [self setNeedsDisplay];
}

// drawing lines
-(void)drawRect:(CGRect)rect
{
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGPoint       point;
    CGPoint       nextPoint;
    NSInteger     i = 0;
    NSInteger     j = 0;
    
    for ( i = 0; i < _lines.count; i++)
    {
        NSMutableArray *line = [_lines objectAtIndex:i];
        
        for ( j = 0; j < line.count-1; j++)
        {
            point       = [[line objectAtIndex:j] CGPointValue];
            nextPoint   = [[line objectAtIndex:j+1] CGPointValue];
            
            // draw line
            CGContextMoveToPoint(context, point.x, point.y);
            CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
            
            CGContextSetLineCap(context, kCGLineCapRound);
            
            // set line width
            CGContextSetLineWidth(context, _brush);
            
            //set color
            CGContextSetRGBStrokeColor(context, _red, _green, _blue, 1.0);
            
            // paints a line with current path
            CGContextStrokePath(context);
            
        }
    }
}

// clear all drawing
-(void)reset
{
    // remove all lines
    _lines = nil;
    
    //redraw view
    [self setNeedsDisplay];
}
@end
