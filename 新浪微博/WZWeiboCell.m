//
//  WZWeiboCell.m
//  新浪微博
//
//  Created by bxipad on 15/10/19.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import "WZWeiboCell.h"
#import "WZWeibo.h"
#import "UIImageView+AFNetworking.h"
@interface WZWeiboCell ()
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textL;

@property (weak, nonatomic) IBOutlet UIButton *ZFBtn;
@property (weak, nonatomic) IBOutlet UIButton *PLBtn;
@property (weak, nonatomic) IBOutlet UIButton *ZANBtn;
@property (strong, nonatomic) TapFunctionButtonBlock tapBlock;

@end


@implementation WZWeiboCell
- (void)setCellInfo:(WZWeibo *)obj
{

    self.nameLabel.text = obj.name;
    self.textL.attributedText = obj.attributedStringText;
    [self.headImage setImageWithURL:obj.headImageURL placeholderImage:[UIImage imageNamed:@"111.png"]];
    [self.ZFBtn setTitle:[NSString stringWithFormat:@"转发(%@)",obj.reposts_count] forState:UIControlStateNormal];
    [self.PLBtn setTitle:[NSString stringWithFormat:@"评论(%@)",obj.comments_count] forState:UIControlStateNormal];
    [self.ZANBtn setTitle:[NSString stringWithFormat:@"赞(%@)",obj.attitudes_count] forState:UIControlStateNormal];

}

- (IBAction)tapFunction:(UIButton *)sender
{
    
    switch (sender.tag) {
        case 1:
        {
            if (self.tapBlock) {
                self.tapBlock(1);
            }
            break;
        }
        case 2:
        {
            if (self.tapBlock) {
                self.tapBlock(2);
            }
            break;
        }
        case 3:
        {
            if (self.tapBlock) {
                self.tapBlock(3);
            }
            break;
        }
        default:
            break;
    }

    
}






@end
