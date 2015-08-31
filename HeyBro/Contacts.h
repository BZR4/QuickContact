//
//  Contacts.h
//  Tinder
//
//  Created by Marco on 8/28/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

#ifndef Tinder_Contacts_h
#define Tinder_Contacts_h

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface Contacts : NSObject

-(BOOL)showUnknownPersonViewController: (NSString *) firstName
                                  name: (NSString *) lastName
                                 phone: (NSString *) phoneNumber
                           emailString: (NSString *) email
                               faceURL: (NSString *) face;

-(void)showPeoplePickerController: (ABPeoplePickerNavigationController *) picker;


-(void) atributes: (ABPersonViewController *) picker;

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person;

@end

#endif

