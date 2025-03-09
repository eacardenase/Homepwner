//
//  AppDelegate.h
//  Homepwner
//
//  Created by Edwin Cardenas on 3/02/25.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

