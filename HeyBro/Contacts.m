//

//  ViewController.m

//  QuickTutorial

//

//  Created by Jessica Oliveira on 21/08/15.

//  Copyright (c) 2015 Jessica Oliveira. All rights reserved.

//



#import "Contacts.h"



@interface Contacts ()

@property (nonatomic, assign) ABAddressBookRef addressBook;

@property (nonatomic, assign) ABRecordRef group;

@end

@implementation Contacts

- (id)init {
    
    if (self = [super init]) {
        
        [self begin];
        
    }
    return self;
}

-(BOOL)showUnknownPersonViewController: (NSString *) firstName
                                  name: (NSString *) lastName
                                 phone: (NSString *) phoneNumber
                           emailString: (NSString *) email
                               faceURL: (NSString *) face
{
    BOOL isSuccess = NO;
    
    if(![firstName  isEqual: @""] && ![lastName  isEqual: @""] ){
        
        
        CFErrorRef error;
        
        ABRecordRef record = ABPersonCreate();
        
        isSuccess  = ABRecordSetValue(record, kABPersonFirstNameProperty, CFBridgingRetain(firstName), &error);
        isSuccess = ABRecordSetValue(record, kABPersonLastNameProperty, CFBridgingRetain(lastName), &error);
        
        
        if(![email isEqualToString:@""]){
            ABMutableMultiValueRef emailRef = ABMultiValueCreateMutable(kABPersonEmailProperty);
            ABMultiValueAddValueAndLabel(emailRef, (__bridge CFTypeRef)(email),kABHomeLabel,NULL);
            isSuccess = ABRecordSetValue(record, kABPersonEmailProperty, emailRef, &error);
            //            CFRelease(email);
            
        }
        
        if(![phoneNumber isEqualToString:@""]){
            
            ABMutableMultiValueRef phone2 = ABMultiValueCreateMutable(kABPersonPhoneProperty);
            ABMultiValueAddValueAndLabel(phone2, (__bridge CFTypeRef)(phoneNumber),nil,NULL);
            isSuccess = ABRecordSetValue(record, kABPersonPhoneProperty, phone2, &error);
        }
        
        if(![face isEqualToString:@""]){
            ABMutableMultiValueRef faceRef = ABMultiValueCreateMutable(kABPersonURLProperty);
            ABMultiValueAddValueAndLabel(faceRef, (__bridge CFTypeRef)face,kABPersonSocialProfileServiceFacebook,NULL);
            isSuccess = ABRecordSetValue(record, kABPersonURLProperty, faceRef, &error);
        }
        
        isSuccess = ABAddressBookAddRecord(self.addressBook, record, &error);
        
        ABGroupAddMember(self.group, record, &error);
        
        isSuccess = ABAddressBookSave(self.addressBook, &error);
        
        
        NSLog(@"is success %d", isSuccess);
        
        ABAddressBookSave(self.addressBook, &error);
        CFRelease(record);
        
    }
    return isSuccess;
    
}



-(void)showPeoplePickerController: (ABPeoplePickerNavigationController *) picker{
    
    //    [[UIBarButtonItem appearanceWhenContainedIn:[ABPeoplePickerNavigationController class], nil] setTintColor:[UIColor whiteColor]];
    //
    //    [[UINavigationBar appearanceWhenContainedIn:[ABPeoplePickerNavigationController class], nil] setBarTintColor:[UIColor colorWithRed:0.f/255.f green:144.f/255.f blue:255.f/255.f alpha:1.0f]];
    //
    //
    //
    //    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor whiteColor], UITextAttributeTextShadowColor, nil];
    //
    
    //    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    
    [picker.navigationController.navigationBar setTranslucent:NO];
    
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonURLProperty], nil];
    
    picker.displayedProperties = displayedItems;
    
}



-(void) atributes: (ABPersonViewController *) picker{
    
    // Allow users to edit the person’s information
    picker.allowsEditing = YES;
    
    // Display only a person's: phone, email, and birthdate
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonURLProperty], nil];
    
    picker.displayedProperties = displayedItems;
    
}



-(void)begin{
    
    self.addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    
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

@end

