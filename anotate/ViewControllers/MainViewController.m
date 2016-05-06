//
//  MainViewController.m
//  anotate
//
//  Created by Malin on 2016-05-05.
//  Copyright © 2016 Malin Soeun. All rights reserved.
//

#import "MainViewController.h"
#import "AnnotateView.h"

@interface MainViewController ()
@property(weak)IBOutlet AnnotateView     *annotateView;
@property(weak)IBOutlet UIBarButtonItem  *btnClear;
@property(weak)IBOutlet UIBarButtonItem  *btnSave;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)setupBarButtons
{
    NSMutableArray *buttons = @[].mutableCopy;
    
    // create new button
    UIBarButtonItem *btnNew = [[UIBarButtonItem alloc] initWithTitle:@"New"
                              style:UIBarButtonItemStylePlain target:self
                              action:@selector(btnNewPressed:)];
    [buttons addObject:btnNew];
    
    // create clear button
    UIBarButtonItem *btnClear = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                style:UIBarButtonItemStylePlain target:self
                                action:@selector(btnClearPressed:)];
    [buttons addObject:btnClear];
    
    // set left bar button items
    [self.navigationController.navigationBar.topItem setLeftBarButtonItems:buttons];
    
    
    // create save button
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                style:UIBarButtonItemStylePlain target:self
                                action:@selector(btnSavePressed:)];
    
    // set right bar button item
    [self.navigationController.navigationBar.topItem setRightBarButtonItem: btnSave];
}

// create options view to get image
-(void)createOptionsView
{
    UIAlertController *actionSheet;
    
    actionSheet = [UIAlertController alertControllerWithTitle:@"Add Photo"
                                                      message:nil
                                               preferredStyle:UIAlertControllerStyleAlert];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // choose image from photo library
        [self chooseFromLibrary];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // take photo from camera
        [self takePhoto];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - Action Sheet Methods

// take photo from camera
-(void)takePhoto
{
    UIImagePickerController *imagePickerController;
    
    imagePickerController = [[UIImagePickerController alloc] init];
    
    // use camera as source type
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate   = self;

    // show image picker
    [self presentViewController:imagePickerController
                       animated:YES completion:nil];
}

// get image from library
-(void)chooseFromLibrary
{
    UIImagePickerController *imagePickerController;
    
    imagePickerController = [[UIImagePickerController alloc] init];
    
    // use photo libray as source type
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate   = self;
    
    // show image picker
    [self presentViewController:imagePickerController
                       animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // get uncropped image
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // dismiss image picker view controller
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    CGFloat ratio = image.size.width / image.size.height;
    CGSize  size = CGSizeMake(500, 500/ratio);
    
    // compress image size
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // get image from current image context
    UIImage *compressImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // display image in view
    _annotateView.image = compressImage;
    
    // clear anotation
    [_annotateView clearDrawing];
    
    // show clear and save buttons
    [self setupBarButtons];
}

#pragma mark - Action Methods

// save annotate image to photo album
-(IBAction)btnSavePressed:(id)sender
{
    CALayer *layer;
    
    layer = self.view.layer;
    
    //create image context
    UIGraphicsBeginImageContext(self.view.bounds.size);
    
    // capture screen
    CGContextClipToRect (UIGraphicsGetCurrentContext(),self.view.bounds);
    
    // draw image in current context
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // get image from current image context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // save image to photos album
    UIImageWriteToSavedPhotosAlbum(image, self,
                                   @selector(savedImageToPhotosAlbum:
                                             didFinishSavingWithError:
                                             contextInfo:), nil);
}

// get response from save image to phtos album
-(void)savedImageToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error
                   contextInfo:(void *)contextInfo
{
    
    UIAlertView  *alertView;
    NSString     *message;
    
    if ( nil == error )
    {
        message = @"Image Saved";
    }
    else
    {
        message = @"Failed to Save Image";
    }
    
    // alert save image status
    alertView = [[UIAlertView alloc] initWithTitle:nil message:message
                                          delegate:nil cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    
    [alertView show];
}

// clear any drawing data
-(IBAction)btnClearPressed:(id)sender
{
    // clear anotation
    [_annotateView clearDrawing];
}

// load new image
-(IBAction)btnNewPressed:(id)sender
{
    // show options view
    [self createOptionsView];
}
@end
