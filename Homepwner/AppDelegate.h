//
//  AppDelegate.h
//  Homepwner
//
//  Created by Edwin Cardenas on 3/02/25.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

extern NSString * const BNRNextItemValuePrefsKey;
extern NSString * const BNRNextItemNamePrefsKey;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

