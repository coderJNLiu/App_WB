//
//  commentCell.m
//  新浪微博
//
//  Created by bxipad on 15/10/20.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import "commentCell.h"
#import "UITableViewCell+Func.h"
#import "UIImageView+AFNetworking.h"
#import "commentEntity.h"
@interface commentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headimageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@end

@implementation commentCell

- (void)setCellInfo:(commentEntity *)obj
{
    self.nameLabel.text = obj.name;
    self.commentsLabel.attributedText = obj.attributedStringCommentsText;
    [self.headimageView setImageWithURL:obj.headImageURL placeholderImage:[UIImage imageNamed:@"111.png"]];

}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
