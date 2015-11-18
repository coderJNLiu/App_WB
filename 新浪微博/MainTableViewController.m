//
//  MainTableViewController.m
//  新浪微博
//
//  Created by bxipad on 15/10/19.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import "MainTableViewController.h"
#import "UITableViewCell+Func.h"
#import "WeiboManager.h"
#import "BaseEntity.h"
@interface MainTableViewController ()
@property (strong, nonatomic) WeiboManager * manager;
@property (strong, nonatomic) NSArray * weiboItems;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //让cell进行自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    self.manager = [WeiboManager shareWeiboManager];
    
    __weak __block MainTableViewController * copy_self = self;
    [self.manager requestWeiboInfoWithCount:50 HandleBlock:^(NSArray *weibos) {
        copy_self.weiboItems = weibos;
        [copy_self.tableView reloadData];
        //        NSLog(@"---%ld",weibos.count);
    }];

}
- (IBAction)refresh:(UIRefreshControl *)sender
{
    __weak __block MainTableViewController * copy_self = self;
    [self.manager requestWeiboInfoWithCount:50 HandleBlock:^(NSArray *weibos) {
        copy_self.weiboItems = weibos;
        [copy_self.tableView reloadData];
        [copy_self.refreshControl endRefreshing];
}
     ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    __weak __block MainTableViewController * copy_self = self;
    [self.manager requestWeiboInfoWithCount:50 HandleBlock:^(NSArray *weibos) {
        copy_self.weiboItems = weibos;
        [copy_self.tableView reloadData];
        [copy_self.refreshControl endRefreshing];
    }
     ];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.weiboItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseEntity * w = self.weiboItems[indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([w class]) forIndexPath:indexPath];
    //[cell setCellInfo:w];
    cell.tapBlock = ^(int index){
        switch (index) {
            case 1:
            {
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZFVC"];
                //展示下一个界面时隐藏tabbar
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController showViewController:vc sender:nil];
                [vc setValue:w.weiboID forKey:@"idstr"];
                //返回时显示tabbar
                self.hidesBottomBarWhenPushed = NO;

                break;

            }
            case 2:
            {
                UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PLVC"];
                self.hidesBottomBarWhenPushed = YES;
                [self showViewController:vc sender:nil];
                [vc setValue:w.weiboID forKey:@"idstr"];
                self.hidesBottomBarWhenPushed = NO;
                break;
                
            }
            case 3:
            {
                NSLog(@"待添加");

                break;
                
            }
                
            default:
                break;
        }
    };
     [cell setCellInfo:w];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell * cell = (UITableViewCell *)sender;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    BaseEntity * w = self.weiboItems[indexPath.row];
    UIViewController * vc = [segue destinationViewController];
    [vc setValue:w.weiboID forKey:@"idstr"];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/







@end
