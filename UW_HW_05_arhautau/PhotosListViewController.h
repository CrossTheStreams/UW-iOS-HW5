//
//  PhotosListViewController.h
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/11/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckIn.h"

@interface PhotosListViewController : UICollectionViewController

+ (instancetype) createPhotosListViewControllerWithCheckIn: (CheckIn*) checkIn;

@end
