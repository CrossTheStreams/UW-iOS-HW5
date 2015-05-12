//
//  PhotosListViewController.m
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/11/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "PhotosListViewController.h"
#import "PhotoCell.h"

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
    UIImageView *imgView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 10, cell.bounds.size.width, cell.bounds.size.height)];
    [imgView setImage: img];
    
    [cell setPhoto:imgView];
    
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

@end
