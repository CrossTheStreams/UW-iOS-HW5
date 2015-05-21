//
//  PhotosListViewController.m
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/11/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "PhotosListViewController.h"
#import "PhotoCell.h"

@interface PhotosListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end


@implementation PhotosListViewController

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
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(10, 10, cell.bounds.size.width, 40)];
    [label setText:@"foo"];
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"mario" ofType:@"jpg"];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile: thePath];
    
    [cell.photo setImage: img];
    
    
    
    return cell;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
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

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *pngData = UIImagePNGRepresentation(originalImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Get the docs directory
    NSString *documentsPath = [paths objectAtIndex:0];
    // Add the file name
    NSString *filePath = [documentsPath stringByAppendingPathComponent: [[[NSUUID UUID] UUIDString] stringByAppendingString:@".png"]];
    // Write the file
    
    NSArray *directoryContent = [[NSFileManager defaultManager] directoryContentsAtPath: documentsPath];
    
    NSLog(@"%@",directoryContent);
    
//   delete all files in documents folder
//    for (NSString *path in directoryContent) {
//        NSError *error;
//        NSString *fullPath = [[documentsPath stringByAppendingString: @"/"] stringByAppendingString: path];
//        BOOL success = [[NSFileManager defaultManager] removeItemAtPath: fullPath error: &error];
//        if (!success) {
//            NSLog(@"%@",error);
//        }
//    }
    
    [pngData writeToFile:filePath atomically:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];

    
}


@end
