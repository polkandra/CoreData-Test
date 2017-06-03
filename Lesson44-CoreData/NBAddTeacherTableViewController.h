//
//  NBAddTeacherTableViewController.h
//  Lesson44-CoreData
//
//  Created by Nick Bibikov on 2/24/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import "NBTableViewController.h"

@class NBTeachers;

@interface NBAddTeacherTableViewController : NBTableViewController

@property (strong, nonatomic) NBTeachers* teacher;

- (IBAction)cancelBarButton:(UIBarButtonItem *)sender;
- (IBAction)saveBarButton:(UIBarButtonItem *)sender;


@end
