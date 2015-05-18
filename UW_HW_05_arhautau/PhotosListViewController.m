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
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypePhotoLibrary];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:^{
        //
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"%@",info);
    
    
}


@end
