//
//  NBAddStudentTableTableViewController.h
//  Lesson44-CoreData
//
//  Created by Nick Bibikov on 2/18/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//



#import <UIKit/UIKit.h>

@class NBStudents;


@interface NBAddStudentTableViewController : UITableViewController 

@property (strong, nonatomic) NBStudents* student;

- (IBAction)cancelBarButton:(UIBarButtonItem *)sender;
- (IBAction)saveBarButton:(UIBarButtonItem *)sender;

@end
