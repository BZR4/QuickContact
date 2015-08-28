//
//  ViewController.m
//  QuickTutorial
//
//  Created by Jessica Oliveira on 21/08/15.
//  Copyright (c) 2015 Jessica Oliveira. All rights reserved.
//

#import "Contacts.h"

@interface ViewController ()

@property (nonatomic, assign) ABAddressBookRef addressBook;
@property (nonatomic, assign) ABRecordRef group;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self begin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Listing 1-2  Presenting the people picker

- (IBAction)showPicker:(id)sender
{
    [self showPeoplePickerController];
}

- (IBAction)create:(id)sender {
    
    [self showUnknownPersonViewController];
    
}

-(void)showUnknownPersonViewController
{
    //    ABRecordRef aContact = ABPersonCreate();
    //    CFErrorRef anError = NULL;
    //
    //
    //    ABMultiValueRef email = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    //    ABMultiValueRef phone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    //    ABMultiValueRef face = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    //
    //
    //    bool didAdd = ABMultiValueAddValueAndLabel(email, CFBridgingRetain(self.email.text), kABHomeLabel, NULL);
    //    bool didAddPhone = ABMultiValueAddValueAndLabel(phone, CFBridgingRetain(self.phoneNumber.text), nil, NULL);
    //    bool didAddFace = ABMultiValueAddValueAndLabel(face, CFBridgingRetain(self.face.text), kABPersonSocialProfileServiceFacebook , NULL);
    //
    //
    //    ABRecordSetValue(aContact, kABPersonFirstNameProperty, CFBridgingRetain(self.firstName.text), NULL);
    //    ABRecordSetValue(aContact, kABPersonLastNameProperty, CFBridgingRetain(self.lastName.text), NULL);
    //
    //
    //    if (didAdd == YES && didAddPhone == YES && didAddFace == YES)
    //    {
    //        ABRecordSetValue(aContact, kABPersonEmailProperty, email, &anError);
    //        ABRecordSetValue(aContact, kABPersonPhoneProperty, phone, &anError);
    //
    //        ABRecordSetValue(aContact, kABPersonURLProperty , face , &anError);
    //
    //
    //        if (anError == NULL)
    //        {
    //            ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    //            picker.newPersonViewDelegate = self;
    //
    //            picker.navigationController.tabBarItem.title = @"set";
    //
    //
    //            picker.displayedPerson = aContact;
    //
    //            picker.title = @"Jessica Oliveira";
    //
    //
    //            [self.navigationController pushViewController:picker animated:YES];
    //
    //
    //        }
    //        else
    //        {
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
    //                                                            message:@"Could not create unknown user"
    //                                                           delegate:nil
    //                                                  cancelButtonTitle:@"Cancel"
    //                                                  otherButtonTitles:nil];
    //            [alert show];
    //        }
    //    }
    //    CFRelease(face);
    //    CFRelease(email);
    //    CFRelease(phone);
    //    CFRelease(aContact);
    
    if(![self.firstName.text  isEqual: @""] && ![self.lastName.text  isEqual: @""] ){
        
        
        CFErrorRef error;
        
        ABRecordRef record = ABPersonCreate();
        BOOL isSuccess ;
        
        isSuccess  = ABRecordSetValue(record, kABPersonFirstNameProperty, CFBridgingRetain(self.firstName.text), &error);
        isSuccess = ABRecordSetValue(record, kABPersonLastNameProperty, CFBridgingRetain(self.lastName.text), &error);
        
        
        ABMutableMultiValueRef email = ABMultiValueCreateMutable(kABPersonEmailProperty);
        ABMutableMultiValueRef phone2 = ABMultiValueCreateMutable(kABPersonPhoneProperty);
        ABMutableMultiValueRef face = ABMultiValueCreateMutable(kABPersonURLProperty);
        
        
        CFTypeRef emailText= CFBridgingRetain(self.email.text);
        CFTypeRef phoneText= CFBridgingRetain(self.phoneNumber.text);
        CFTypeRef faceText= CFBridgingRetain(self.face.text);
        
        ABMultiValueAddValueAndLabel(email, emailText,kABHomeLabel,NULL);
        ABMultiValueAddValueAndLabel(phone2, phoneText,nil,NULL);
        ABMultiValueAddValueAndLabel(face, faceText,kABPersonSocialProfileServiceFacebook,NULL);
        
        
        isSuccess = ABRecordSetValue(record, kABPersonEmailProperty, email, &error);
        
        isSuccess = ABRecordSetValue(record, kABPersonPhoneProperty, phone2, &error);
        
        isSuccess = ABRecordSetValue(record, kABPersonURLProperty, face, &error);
        
        
        isSuccess = ABAddressBookAddRecord(self.addressBook, record, &error);
        isSuccess = ABAddressBookSave(self.addressBook, &error);
        
        ABGroupAddMember(self.group, record, &error);
        
        NSLog(@"is success %d", isSuccess);
        
        ABAddressBookSave(self.addressBook, &error);
        CFRelease(self.group);
        
        self.firstName.text = @"";
        self.lastName.text = @"";
        self.email.text = @"";
        self.phoneNumber.text = @"";
        self.face.text = @"";
        self.add.text = @"ADDED";
    }
    
}

-(void)showPeoplePickerController{
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    
    picker.peoplePickerDelegate = self;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[ABPeoplePickerNavigationController class], nil] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearanceWhenContainedIn:[ABPeoplePickerNavigationController class], nil] setBarTintColor:[UIColor colorWithRed:0.f/255.f green:144.f/255.f blue:255.f/255.f alpha:1.0f]];
    
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor whiteColor], UITextAttributeTextShadowColor, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    
    [picker.navigationController.navigationBar setTranslucent:NO];
    
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonURLProperty], nil];
    
    
    
    picker.displayedProperties = displayedItems;
    [self presentViewController:picker animated:YES completion:nil];
    
    
}

-(void)begin{
    _addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    
    CFArrayRef recordGroup;
    CFIndex nGroup = ABAddressBookGetGroupCount(self.addressBook);
    NSString *grpName;
    ABRecordRef recordGroupID;
    
    recordGroup = ABAddressBookCopyArrayOfAllGroups(self.addressBook);
    for( int i=0;i<= nGroup ;i++){
        recordGroupID = ABAddressBookGetGroupWithRecordID(self.addressBook, i);
        grpName = (NSString *)CFBridgingRelease(ABRecordCopyCompositeName(recordGroupID));
        if([grpName isEqualToString:@"Hey!New"]){
            break;
        }
    }
    
    if([grpName isEqualToString:@"Hey!New"]){
        self.group = recordGroupID;
    }else{
        CFErrorRef error;
        ABRecordRef group = ABGroupCreate();
        ABRecordSetValue(group, kABGroupNameProperty,@"Hey!New", &error);
        ABAddressBookAddRecord(self.addressBook, group, &error);
        ABAddressBookSave(self.addressBook, &error);
        self.group = group;
    }
    
}

#pragma mark - Listing 1-3  Responding to user actions in the people picker

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    return NO;
}

#pragma mark - Listing 1-4  Displaying a person’s information

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
                         didSelectPerson:(ABRecordRef)person{
    ABPersonViewController *picker = [[ABPersonViewController alloc] init];
    picker.personViewDelegate = self;
    picker.displayedPerson = person;
    
    // Allow users to edit the person’s information
    picker.allowsEditing = YES;
    // Display only a person's: phone, email, and birthdate
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonURLProperty], nil];
    
    
    
    picker.displayedProperties = displayedItems;
    
    [self.navigationController pushViewController:picker animated:YES];
    
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

#pragma mark ABUnknownPersonViewControllerDelegate methods
// Dismisses the picker when users are done creating a contact or adding the displayed person properties to an existing contact.
- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Does not allow users to perform default actions such as emailing a contact, when they select a contact property.
- (BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}

#pragma mark ABNewPersonViewControllerDelegate methods
// Dismisses the new-person view controller.
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController
shouldPerformDefaultActionForPerson:(ABRecordRef)person
                    property:(ABPropertyID)property
                  identifier:(ABMultiValueIdentifier)identifierForValue
{
    return NO;
}



@end
