//
//  NBAddCourseTableTableViewController.m
//  Lesson44-CoreData
//
//  Created by Nick Bibikov on 2/19/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "NBAddCourseTableViewController.h"
#import "NBSharedManager.h"
#import "NBCourses.h"
#import "NBStudents.h"
#import "NBTeachers.h"
#import "NBChooseCourseTableViewController.h"

@interface NBAddCourseTableViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NBChooseCourseTableViewControllerDelegate>

@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UITextField* objectTextField;
@property (strong, nonatomic) UITextField* industryTextField;
@property (strong, nonatomic) NSArray* studentsOfCourse;

@end

@implementation NBAddCourseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];*/
    
    self.nameTextField = [self createTextField:UIReturnKeyNext andWithKeyboardType:UIKeyboardTypeDefault];
    self.objectTextField = [self createTextField:UIReturnKeyNext andWithKeyboardType:UIKeyboardTypeDefault];
    self.industryTextField = [self createTextField:UIReturnKeyDone andWithKeyboardType:UIKeyboardTypeEmailAddress];
    self.nameTextField.delegate = self;
    self.objectTextField.delegate = self;
    self.industryTextField.delegate = self;
    
    self.studentsOfCourse = [[NSArray alloc] init];
    
    if (self.course != nil) {
        self.nameTextField.text = self.course.name;
        self.objectTextField.text = self.course.object;
        self.industryTextField.text = self.course.industry;
        
    } else {
        self.course = [NSEntityDescription insertNewObjectForEntityForName:@"NBCourses" inManagedObjectContext:[[NBSharedManager sharedManager] managedObjectContext]];
        
    }
    
    self.studentsOfCourse = [[self.course students] allObjects];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
        
    } else if (section == 1){
        if (self.course.teacher == nil) {
            return 1;
            
        } else {
            return 2;
            
        }
        
    } else if (section == 2) {
        return [self.studentsOfCourse count] + 1;
        
    }
    return 0;
    
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Course info";
        
    } else if (section == 1)  {
        return @"Teacher of course";
        
    } else {
        return @"Students of course";
        
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* indentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    
    UILabel* label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 6, 100, 30);
    label.font = [UIFont fontWithName:@"Avenir" size:17.f];
    label.textColor = UIColorFromRGB(0x5c6f7a);
    label.textAlignment = NSTextAlignmentRight;
    
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        label.text = @"Name";
        
        [cell addSubview:label];
        [cell addSubview:self.nameTextField];
        
    } else if (indexPath.section == 0 && indexPath.row == 1 ) {
        label.text = @"Object";
        
        [cell addSubview:label];
        [cell addSubview:self.objectTextField];
        
    } else if (indexPath.section == 0 && indexPath.row == 2 ) {
        label.text = @"Industry";
        
        [cell addSubview:label];
        [cell addSubview:self.industryTextField];
        
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = @"Add teacher";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    } else if (indexPath.section == 1 ) {
        if ([self.course teacher] != nil) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [self.course.teacher firstName], [self.course.teacher lastName]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        } else {
            cell.textLabel.text = nil;
            
        }
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        cell.textLabel.text = @"Add student";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    } else if (indexPath.section == 2) {
        NBStudents* student = [self.studentsOfCourse objectAtIndex:indexPath.row - 1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return cell;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return NO;
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        return NO;
        
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        return NO;
        
    } else {
        return YES;
        
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.section == 2) {
            NBStudents* student = [self.studentsOfCourse objectAtIndex:indexPath.row - 1];
            NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.studentsOfCourse];
            [tempArray removeObject:student];
            [self.course setStudents:[NSSet setWithArray:tempArray]];
            self.studentsOfCourse = tempArray;
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        } else if (indexPath.section == 1) {
            [self.course setTeacher:nil];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        NBChooseCourseTableViewController* vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"NBChooseCourseTableViewController"];
        vc.delegate = self;
        vc.data = self.course;
        vc.typeEntity = NBTeachersType;
        
        [self.navigationController pushViewController:vc animated:YES];
    
    }
}


#pragma mark - NBChooseCourseTableViewControllerDelegate

- (void) chooseDataArray:(NSMutableArray*)datatArray andType:(NBDataType)entityType {
    if (entityType == NBStudentsType) {
        self.studentsOfCourse = datatArray;
        [self.course setStudents:[NSSet setWithArray:self.studentsOfCourse]];
         
    } else if (entityType == NBTeachersType) {
        if ([datatArray count] > 0) {
            [self.course setTeacher:[datatArray firstObject]];
            [self.tableView reloadData];
            
        } else {
            self.course.teacher = nil;
            
        }
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.objectTextField becomeFirstResponder];
        
    } else if (textField == self.objectTextField)  {
        [self.industryTextField becomeFirstResponder];
        
    } else {
        [textField resignFirstResponder];
        
    }
    return YES;
}



#pragma mark - Actions

- (IBAction)cancelBarButton:(UIBarButtonItem *)sender {
    [[[NBSharedManager sharedManager] managedObjectContext] rollback];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (IBAction)saveBarButton:(UIBarButtonItem *)sender {
    self.course.name = self.nameTextField.text;
    self.course.object = self.objectTextField.text;
    self.course.industry = self.industryTextField.text;
    
    NSError* error = nil;
    
    if (![[[NBSharedManager sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


#pragma mark - Methods


- (UITextField*) createTextField:(UIReturnKeyType)ReturnKeyType andWithKeyboardType:(UIKeyboardType)keyboardType {
    UITextField* textField = [[UITextField alloc]init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = ReturnKeyType;
    textField.keyboardType = keyboardType;
    textField.frame = CGRectMake(130, 7, 220, 30);
    
    return textField;
    
}


/*- (void) hideKeyboard {
    [self.nameTextField resignFirstResponder];
    [self.objectTextField resignFirstResponder];
    [self.industryTextField resignFirstResponder];
    
}*/


- (void) dealloc {
    NSLog(@"NBAddCourseTableTableViewController deallocated");
    
}

@end
