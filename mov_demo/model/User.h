//
//  User.h
//  mov_demo
//
//  Created by Mountain on 14/04/2024.
//

#import <Foundation/Foundation.h>


// User.h
@interface User : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *company;
@end

// Post.h
@interface Post : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, assign) NSInteger userId;
// 其他属性...
@end
