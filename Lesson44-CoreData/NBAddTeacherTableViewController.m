//
//  NBAddTeacherTableViewController.m
//  Lesson44-CoreData
//
//  Created by Nick Bibikov on 2/24/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "NBAddTeacherTableViewController.h"
#import "NBSharedManager.h"
#import "NBCourses.h"
#import "NBStudents.h"
#import "NBTeachers.h"
#import "NBChooseCourseTableViewController.h"

@interface NBAddTeacherTableViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NBChooseCourseTableViewControllerDelegate>

@property (strong, nonatomic) UITextField* firstNameTextField;
@property (strong, nonatomic) UITextField* lastNameTextField;

@end

@implementation NBAddTeacherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]; [self.tableView addGestureRecognizer:gestureRecognizer];*/
    
    self.firstNameTextField = [self createTextField:UIReturnKeyNext andWithKeyboardType:UIKeyboardTypeDefault];
    self.lastNameTextField = [self createTextField:UIReturnKeyDone andWithKeyboardType:UIKeyboardTypeDefault];

    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    
    if (self.teacher != nil) {
        self.firstNameTextField.text = self.teacher.firstName;
        self.lastNameTextField.text = self.teacher.lastName;
        
    } else {
        self.teacher = [NSEntityDescription insertNewObjectForEntityForName:@"NBTeachers" inManagedObjectContext:[[NBSharedManager sharedManager] managedObjectContext]];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
    
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
    
    if (indexPath.row == 0) {
        label.text = @"First name";
        
        [cell addSubview:label];
        [cell addSubview:self.firstNameTextField];
        
    } else if (indexPath.row == 1) {
        label.text = @"Last name";
        
        [cell addSubview:label];
        [cell addSubview:self.lastNameTextField];

    }
    return cell;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - NBChooseCourseTableViewControllerDelegate

- (void) chooseDataArray:(NSMutableArray*)datatArray andType:(NBDataType)entityType {
    
    
    
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.firstNameTextField) {
        [self.lastNameTextField becomeFirstResponder];
        
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
    self.teacher.firstName = self.firstNameTextField.text;
    self.teacher.lastName = self.lastNameTextField.text;
    
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
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];
    
}*/


- (void) dealloc {
    NSLog(@"NBAddCourseTableTableViewController deallocated");
    
}


@end