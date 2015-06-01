//
//  CheckInListController.m
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/26/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "CheckInListController.h"
#import "CheckInCell.h"
#import "MapController.h"
#import "CheckInCollection.h"
#import "CheckIn.h"
#import "PhotosListViewController.h"

@interface CheckInListController ()

@end

@implementation CheckInListController {

    CheckInCollection * _collection;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    
    // Apparently, I had to do this in order to use a xib file?
    [self.tableView registerNib:[UINib nibWithNibName:@"CheckInCell" bundle:nil] forCellReuseIdentifier:@"CheckInCell"];

    
    // register acrhiveCollection notification
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(archiveCheckInCollection) name:@"archiveCollection" object:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"addCheckIn" object: nil queue:nil usingBlock:^(NSNotification *note) {
        
        
        [self addCheckIn: [note.userInfo objectForKey:@"CheckIn"]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [[self checkInCollection] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CheckInCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CheckInCell" forIndexPath:indexPath];
    CheckIn *checkIn = [[self checkInCollection] checkInForRow: [indexPath row]];
    [cell.checkInLabel setText: [checkIn name]];

    return cell;
}


#pragma mark checkInCollection

-(CheckInCollection*) checkInCollection {
    if (![_collection isKindOfClass: [CheckInCollection class]]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        // Get the docs directory
        NSString *documentsPath = [paths objectAtIndex:0];
        // Add the file name
        NSString *collectionPath = [documentsPath stringByAppendingPathComponent: @"CheckInCollection"];

        CheckInCollection * collection = [NSKeyedUnarchiver unarchiveObjectWithFile: collectionPath];

        if (collection) {
            _collection = collection;
        } else {
            _collection = [CheckInCollection createCheckInCollection];
            [self archiveCheckInCollection];
        }
    }
    return _collection;
}

# pragma mark archiveCheckInCollection

-(void) archiveCheckInCollection {
    NSLog(@"collection archived");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *collectionPath = [documentsPath stringByAppendingPathComponent: @"CheckInCollection"];
    [NSKeyedArchiver archiveRootObject: [self checkInCollection] toFile: collectionPath];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CheckIn *checkIn = [[self checkInCollection] checkInForRow: [indexPath row]];
    PhotosListViewController *photosVC = [PhotosListViewController createPhotosListViewControllerWithCheckIn: checkIn];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UINavigationController *photosNav = [storyboard instantiateViewControllerWithIdentifier: @"PhotosListViewControllerNav"];
    
    [photosNav setViewControllers: @[photosVC]];
    
    [[self navigationController] presentViewController: photosNav animated:YES completion: nil];

}

- (IBAction)presentMapController:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UINavigationController *nav = [storyboard instantiateViewControllerWithIdentifier:@"MapControllerNav"];
    MapController *mapVC = [storyboard instantiateViewControllerWithIdentifier:@"MapController"];
    [nav setViewControllers:@[mapVC]];
    [[self navigationController] presentViewController:nav animated:YES completion:^{
        //
    }];
}

-(void) addCheckIn: (CheckIn*) checkIn {
    
    CheckInCollection *collection = [self checkInCollection];
    [collection addCheckIn: checkIn];

    // insert row
    NSUInteger row = [collection rowForCheckIn: checkIn];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: 0];
    
    [self.tableView insertRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
}

-(void) removeCheckIn: (CheckIn*) checkIn {
    // TODO: implement
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
