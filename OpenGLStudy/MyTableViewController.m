//
//  MyTableViewController.m
//  OpenGLStudy
//
//  Created by zjj on 2019/10/22.
//  Copyright © 2019 zjj. All rights reserved.
//

#import "MyTableViewController.h"

@interface MyTableViewController ()

@end

@implementation MyTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *identifier = cell.reuseIdentifier;
    Class cla = NSClassFromString(identifier);
    if (cla) {
        UIViewController *vc = [[cla alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSLog(@"class not found: %@", identifier);
    }
}

@end
