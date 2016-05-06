//
//  AnnotateView.m
//  anotate
//
//  Created by Malin on 2016-05-05.
//  Copyright © 2016 Malin Soeun. All rights reserved.
//

#import "AnnotateView.h"
#import "DrawingView.h"

@interface AnnotateView ()
@property (strong) UIImageView *imageView;
@property (strong) DrawingView *drawView;
@end

@implementation AnnotateView

// set annotate image
-(void)setImage:(UIImage *)image
{
    if ( nil == _imageView )
    {
        // create image view
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.userInteractionEnabled = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:_imageView];
        
        // create drawing view
        _drawView = [[DrawingView alloc] initWithFrame:self.bounds];
        [self addSubview:_drawView];
    }
    
    // set image to image view
    _imageView.image = image;
}

// clear all drawing in view
-(void)clearDrawing
{
    //reset drawing
    [_drawView reset];
    
}
@end
