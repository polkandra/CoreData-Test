//
//  NBChooseCourseTableTableViewController.m
//  Lesson44-CoreData
//
//  Created by Nick Bibikov on 2/20/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import "NBChooseCourseTableViewController.h"
#import "NBStudents.h"
#import "NBCourses.h"
#import "NBTeachers.h"

@interface NBChooseCourseTableViewController ()

@end

@implementation NBChooseCourseTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Methods

- (NSString*) entityName:(NBDataType)dataType {
    if (self.typeEntity == NBStudentsType) {
        return @"NBStudents";
        
    } else if (self.typeEntity == NBCoursesType) {
        return @"NBCourses";
        
    } else if (self.typeEntity == NBTeachersType) {
        return @"NBTeachers";
        
    }
    return nil;
    
}


- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* description = [NSEntityDescription entityForName:[self entityName:self.typeEntity]
                                                   inManagedObjectContext:self.managedObjectContext];
    
    
    [fetchRequest setEntity:description];
    
    if (self.typeEntity != NBCoursesType) {
        NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
        
    } else {
        NSSortDescriptor* name = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:@[name]];
        
    }
    
    
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
    if (self.typeEntity == NBStudentsType) {
        NBStudents* student = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        
        NBCourses* course = self.data;
        if ([[course students] containsObject:student]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
            
        }
        
    } else if (self.typeEntity == NBCoursesType) {
        NBCourses* course = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = course.name;
        NBStudents* student = self.data;
        
        if ([[student courses] containsObject:course]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
            
        }
        
    } else if (self.typeEntity == NBTeachersType) {
        NBTeachers* teacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", teacher.firstName, teacher.lastName];
        NBCourses* course = self.data;
        
        if ([[course teacher] isEqual:teacher]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
            
        }
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.typeEntity == NBTeachersType) {
        if ([[self.tableView indexPathsForSelectedRows] count] == 2) {
            [tableView deselectRowAtIndexPath:[[self.tableView indexPathsForSelectedRows] firstObject] animated:YES];
        
        }
    }
}




#pragma mark - Actions


- (IBAction)cancelBarButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)saveBarButton:(UIBarButtonItem *)sender {
    NSArray* selectedRowsArray = [self.tableView indexPathsForSelectedRows];
    NSMutableArray* selectedItems = [NSMutableArray new];
    
    for (NSIndexPath* numberSelectionRow in selectedRowsArray) {
        [selectedItems addObject:[self.fetchedResultsController objectAtIndexPath:numberSelectionRow]];
        
    }
    [self.delegate chooseDataArray:selectedItems andType:self.typeEntity];
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
