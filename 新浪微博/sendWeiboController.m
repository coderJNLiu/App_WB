//
//  sendWeiboController.m
//  新浪微博
//
//  Created by bxipad on 15/10/20.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import "sendWeiboController.h"
#import "WeiboManager.h"
@interface sendWeiboController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (strong, nonatomic) UIImagePickerController * picker;
@property (strong, nonatomic) WeiboManager * manager;

@end

@implementation sendWeiboController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.allowsEditing = YES;
    self.picker.delegate = self;
    
    self.manager = [WeiboManager shareWeiboManager];
    
    
}

- (IBAction)sendWeiboBtn:(id)sender
{
    NSString * text = self.textView.text;
    if (text.length >= 1)
    {
        [self.manager sendWeiboWithText:text andImage:self.imageBtn.currentImage];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        NSLog(@"文本不能为空！");
    }

}
- (IBAction)tapImageBtn:(id)sender
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择资源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册",@"胶卷", nil];
    [actionSheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                NSLog(@"相机不可用");
                return;
            }
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.picker animated:YES completion:nil];
            break;
        }
        case 1:
        {
            self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:self.picker animated:YES completion:nil];
            break;
        }
        case 2:
        {
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.picker animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = info[UIImagePickerControllerEditedImage];
    [self.imageBtn setImage:image forState:UIControlStateNormal];
    [self.imageBtn setTitle:@"" forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
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
