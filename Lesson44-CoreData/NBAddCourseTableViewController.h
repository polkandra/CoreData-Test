//
//  NBAddCourseTableTableViewController.h
//  Lesson44-CoreData
//
//  Created by Nick Bibikov on 2/19/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import "NBTableViewController.h"

@class NBCourses;

@interface NBAddCourseTableViewController : NBTableViewController 

@property (strong, nonatomic) NBCourses* course;


- (IBAction)cancelBarButton:(UIBarButtonItem *)sender;
- (IBAction)saveBarButton:(UIBarButtonItem *)sender;

@end
