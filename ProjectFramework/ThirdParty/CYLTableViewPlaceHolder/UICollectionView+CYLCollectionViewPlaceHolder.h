//
//  UITableView+CYLCollectionViewPlaceHolder.h
//  ProjectFramework
//
//  Created by 购友住朋 on 16/10/13.
//  Copyright © 2016年 HCY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (CYLTableViewPlaceHolder)

/*!
 @brief just use this method to replace `reloadData` ,and it can help you to add or remove place holder view automatically
 @attention this method has already reload the tableView,so do not reload tableView any more.
 */
- (void)cyl_reloadData;

@end
