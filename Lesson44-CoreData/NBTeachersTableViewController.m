//
//  NBTeachersTableViewController.m
//  Lesson44-CoreData
//
//  Created by Nick Bibikov on 2/24/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import "NBTeachersTableViewController.h"
#import "NBAddTeacherTableViewController.h"
#import "NBTeachers.h"

@interface NBTeachersTableViewController ()

@end

@implementation NBTeachersTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"NBTeachers"
                                                   inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:description];
    NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        
    }
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NBTeachers* teacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [super configureCell:cell atIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", teacher.firstName, teacher.lastName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NBAddTeacherTableViewController* vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"NBAddTeacherTableViewController"];
    
    NBTeachers *teacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    vc.teacher = teacher;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - Actions

- (IBAction)addBarButton:(UIBarButtonItem *)sender {
    NBAddTeacherTableViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"NBAddTeacherTableViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
