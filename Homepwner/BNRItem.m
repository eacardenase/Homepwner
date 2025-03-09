//
//  BNRItem.m
//  Homepwner
//
//  Created by Edwin Cardenas on 3/6/25.
//

#import "BNRItem.h"

@implementation BNRItem

- (void)setThumbnailFromImage:(UIImage *)image
{
    UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
    format.scale = 1.0;
    
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc]
                                         initWithSize:CGSizeMake(40, 40) format:format];
    self.thumbnail = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        [image drawInRect:renderer.format.bounds];
    }];
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    
    self.itemKey = key;
    self.dateCreated = [NSDate date];
    
    UIImage *defaultThumbnail = [UIImage systemImageNamed:@"photo"];
    
    self.thumbnail = defaultThumbnail;
}

@end
