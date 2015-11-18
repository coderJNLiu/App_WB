//
//  commentViewController.m
//  新浪微博
//
//  Created by bxipad on 15/10/20.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import "commentViewController.h"
#import "UITableViewCell+Func.h"
#import "WeiboManager.h"
#import "commentEntity.h"
@interface commentViewController ()
@property (strong, nonatomic) WeiboManager * manager;
@property (strong, nonatomic) NSArray * comments_Array;

@end

@implementation commentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    self.manager = [WeiboManager shareWeiboManager];
    __weak __block commentViewController * copy_self = self;
    [self.manager getWeiboCommentsWithWeiboID:self.idstr HandleBlock:^(NSArray *comments_arr) {
        copy_self.comments_Array = comments_arr;
        [copy_self.tableView reloadData];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.comments_Array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    commentEntity * c = self.comments_Array[indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([c class]) forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setCellInfo:c];
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *vc = [segue destinationViewController];
    [vc setValue:self.idstr forKey:@"idstr"];
}


@end
