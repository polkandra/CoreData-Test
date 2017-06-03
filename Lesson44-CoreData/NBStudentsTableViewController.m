//
//  NBStudentsViewController.m
//  Lesson44-CoreData
//
//  Created by Nick Bibikov on 2/18/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import "NBStudentsTableViewController.h"
#import "NBStudents.h"
#import "NBAddStudentTableViewController.h"


@interface NBStudentsTableViewController ()

@end

@implementation NBStudentsTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    NSEntityDescription* description = [NSEntityDescription entityForName:@"NBStudents"
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
    
    NBStudents* student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [super configureCell:cell atIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NBAddStudentTableViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"NBAddStudentTableTableViewController"];

    NBStudents *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    vc.student = student;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - Actions

- (IBAction)addStudentButton:(UIBarButtonItem *)sender {
    NBAddStudentTableViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"NBAddStudentTableTableViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
