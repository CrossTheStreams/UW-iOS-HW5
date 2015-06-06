//
//  PhotosListViewController.m
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/11/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "PhotosListViewController.h"
#import "PhotoCell.h"
#import "CheckIn.h"
#import <UIKit/UIKit.h>

@interface PhotosListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) CheckIn *checkIn;

@end


@implementation PhotosListViewController {

}

+ (instancetype) createPhotosListViewControllerWithCheckIn: (CheckIn*) checkIn {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    PhotosListViewController *photosVC = [storyboard instantiateViewControllerWithIdentifier: @"PhotosListViewController"];
    photosVC.checkIn = checkIn;
    return photosVC;
}

-(void) viewDidLoad {
    
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"PhotoCell" bundle:nil];
    [self.collectionView registerNib: nib forCellWithReuseIdentifier:@"PhotoCell"];
    
    
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID= @"PhotoCell";
    
    PhotoCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath: indexPath];
    
    if (cell == nil) {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil];
        cell = (PhotoCell *) [nibObjects firstObject];
    }
    
    NSUInteger index = [indexPath row];
    UIImage *img;
    
    NSArray *checkInPhotos = [[self checkIn] photos];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Get the docs directory
    NSString *documentsPath = [paths objectAtIndex:0];
    // Add the file name
    NSString *fileName = [checkInPhotos objectAtIndex: index];
    NSString *checkInPhotoPath = [documentsPath stringByAppendingPathComponent: fileName];

    img = [[UIImage alloc] initWithContentsOfFile: checkInPhotoPath];
    
    [cell.photo setImage: img];

    return cell;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger checkInPhotosCount = [[[self checkIn] photos] count];
    
    return checkInPhotosCount;
}

-(BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

# pragma mark IBActions

- (IBAction)tappedCameraButton:(id)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: nil
                                                                   message: nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Camera" style: UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                            
                                                                [self presentCamera];
                                                            }];
        [alert addAction: cameraAction];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertAction* photoLibraryAction = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 
                                                                 [self presentPhotoLibrary];
                                                                 
                                                             }];
        [alert addAction: photoLibraryAction];
    }
    

    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}

# pragma mark Present Photo Library

-(void) presentCamera {
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:^{
        //
    }];
}

-(void) presentPhotoLibrary {
    UIImagePickerController *photoLibrary = [[UIImagePickerController alloc] init];
    photoLibrary .sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    photoLibrary.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypePhotoLibrary];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    photoLibrary.allowsEditing = NO;
    
    photoLibrary.delegate = self;
    
    [self presentViewController:photoLibrary animated:YES completion:^{
        //
    }];
}

# pragma mark Callback after picking photo

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *pngData = UIImagePNGRepresentation(originalImage);
     
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Get the docs directory
    NSString *documentsPath = [paths objectAtIndex:0];
    // Add the file name
    NSString *fileName = [[[NSUUID UUID] UUIDString] stringByAppendingString:@".png"];
    NSString *filePath = [documentsPath stringByAppendingPathComponent: fileName];
    
    NSArray *directoryContent = [[NSFileManager defaultManager] directoryContentsAtPath: documentsPath];
    
    
    // Write the file
    BOOL success = [pngData writeToFile: filePath atomically:YES];
    
    
    [[[self checkIn] photos] addObject: fileName];
    
    // archive the CheckInCollection to persist the photo
    [[NSNotificationCenter defaultCenter] postNotificationName:@"archiveCollection" object:self];
    
    [self dismissViewControllerAnimated:YES completion:^{
       
        [self.collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem: ([[[self checkIn] photos] count] - 1) inSection:0];
            [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        } completion: nil];
        
    }];
    
    // If the user has opted to save images in Settings.app, save the image to the Camera Roll album
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"save_images"] isEqualToString:@"1"]) {
            UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
        }
        
    }

    
}

-(CheckIn*) checkIn {
    return  _checkIn;
}

- (IBAction)doneAddingPhotos:(id)sender {
    [[[self navigationController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
