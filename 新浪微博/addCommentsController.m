//
//  addCommentsController.m
//  新浪微博
//
//  Created by bxipad on 15/10/20.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import "addCommentsController.h"
#import "WeiboManager.h"
@interface addCommentsController ()

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) WeiboManager * manager;


@end

@implementation addCommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.manager = [WeiboManager shareWeiboManager];
}


- (IBAction)tapSendCommentsBtn:(id)sender
{
    NSString *text = self.textView.text;
    [self.manager sendWeiboComment:text WithWeiboID:self.idstr HandelBlock:^(BOOL isOK) {
        if (isOK)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"字数超过140字" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self showDetailViewController:alert sender:nil];
        }
    }];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
