//
//  AboutViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/16.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController   {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="关于我们"
        self.tableView.tableFooterView=UIView() //去除多余底部线条 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch((indexPath as NSIndexPath).row){
        case 0 :    //应用推荐
            break
        case 1 :    //产品评分
            break
        case 2 :    //联系客服
            CommonFunction.CallPhone(self, number: "")  //联系号码
            break 
        default:break
        }

    }

}
