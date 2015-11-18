//
//  UITableViewCell+Func.h
//  新浪微博
//
//  Created by bxipad on 15/10/19.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TapFunctionButtonBlock)(int index);
@interface UITableViewCell (Func)
@property (strong, nonatomic) TapFunctionButtonBlock tapBlock;

- (void)setCellInfo:(id)obj;
@end
