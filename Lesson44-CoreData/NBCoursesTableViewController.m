//
//  NBCoursesTableViewController.m
//  Lesson44-CoreData
//
//  Created by Nick Bibikov on 2/19/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import "NBCoursesTableViewController.h"
#import "NBCourses.h"
#import "NBAddCourseTableViewController.h"

@interface NBCoursesTableViewController ()

@end

@implementation NBCoursesTableViewController
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
    NSEntityDescription* description = [NSEntityDescription entityForName:@"NBCourses"
                                                   inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:description];
    NSSortDescriptor* nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[nameDescriptor]];
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
    
    NBCourses* course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [super configureCell:cell atIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", course.name];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", ]
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NBAddCourseTableViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"NBAddCourseTableTableViewController"];
    
    NBCourses *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    vc.course = course;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark - Actions

- (IBAction)addCourseButton:(UIBarButtonItem *)sender {
    NBAddCourseTableViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"NBAddCourseTableTableViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
