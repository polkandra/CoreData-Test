//
//  NBChooseCourseTableTableViewController.h
//  Lesson44-CoreData
//
//  Created by Nick Bibikov on 2/20/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import "NBTableViewController.h"

typedef enum {
    NBStudentsType,
    NBCoursesType,
    NBTeachersType
    
} NBDataType;

@protocol NBChooseCourseTableViewControllerDelegate;
@interface NBChooseCourseTableViewController : NBTableViewController

@property (weak, nonatomic) id <NBChooseCourseTableViewControllerDelegate> delegate;
@property (strong, nonatomic) id data;
@property (assign, nonatomic) NBDataType typeEntity;

- (IBAction)cancelBarButton:(UIBarButtonItem *)sender;
- (IBAction)saveBarButton:(UIBarButtonItem *)sender;

@end


@protocol NBChooseCourseTableViewControllerDelegate

- (void) chooseDataArray:(NSMutableArray*)datatArray andType:(NBDataType)entityType;

@end
