//
//  SettingsViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/15.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import SDWebImage

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    //itme图片
    let MyitemImage = ["add-circular","add-circular","add-circular","add-circular"]
    //item名称
    let MyitemName = ["个人信息","清除缓存","意见反馈","关于我们" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self //设置代理
        tableView.dataSource=self   //设置数据源
        self.tableView.tableFooterView=UIView() //去除多余底部线条
        self.automaticallyAdjustsScrollViewInsets=false // //取消掉被NavigationController管理的自动留白 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //设置行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
    }
    
    //返回节的个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //返回某个节中的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return MyitemImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Settings", for: indexPath) as! SettingsTableViewCell
        var Clear="0"
        if((indexPath as NSIndexPath).row==1){   //清除缓存
            Clear="1"
        }
        cell.InitConfig([MyitemImage[(indexPath as NSIndexPath).row],MyitemName[(indexPath as NSIndexPath).row],Clear])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch((indexPath as NSIndexPath).row){
        case 0 :    //个人信息
            SelectedItem("Myinfo",Identifier: "Myinfo")
            break
        case 1 :    //清除缓存
            Clear()
            break
        case 2 :    //意见反馈
            SelectedItem("Feedback",Identifier: "Feedback")
            break
        case 3 :    //关于我们
            SelectedItem("About",Identifier: "About")
            break
 
        default:break
        }

    }
    
    //选择的Item
   fileprivate func SelectedItem(_ stroryboardName: String,Identifier: String){
        let vc =  CommonFunction.ViewControllerWithStoryboardName(stroryboardName, Identifier: Identifier)
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
    fileprivate func Clear(){
        CommonFunction.AlertController(self, title: "消息", message: "确定清除缓存吗?", ok_name: "确定", cancel_name: "取消", style: .alert, OK_Callback: { 
            SDImageCache.shared().clearDisk(onCompletion: {
                //清除缓存
                SDImageCache.shared().clearMemory()
                self.tableView.reloadData()
            })
            }) { 
                
        }
    }
    
}
