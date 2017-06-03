//
//  NBTeachers.h
//  Lesson44-CoreData
//
//  Created by Nick Bibikov on 2/21/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NBCourses;

@interface NBTeachers : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *courses;
@end

@interface NBTeachers (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(NBCourses *)value;
- (void)removeCoursesObject:(NBCourses *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
