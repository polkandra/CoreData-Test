//
//  NBCourses.h
//  Lesson44-CoreData
//
//  Created by Nick Bibikov on 2/21/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NBStudents, NBTeachers;

@interface NBCourses : NSManagedObject

@property (nonatomic, retain) NSString * industry;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * object;
@property (nonatomic, retain) NSSet *students;
@property (nonatomic, retain) NBTeachers *teacher;
@end

@interface NBCourses (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(NBStudents *)value;
- (void)removeStudentsObject:(NBStudents *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
