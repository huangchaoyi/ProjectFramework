//
//  MyViewController.swift
//  ProjectFramework
//
//  Created by 猪朋狗友 on 16/6/20.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class MyViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    let MyIdentifier = "MyCell"
    let MyItemIdentifier = "MyItemCell"
    
    var My = [MyModel]()        //我的信息(个人信息
    
    //itme图片
    let MyitemImage = ["add-circular","add-circular","add-circular","add-circular","add-circular" ]
    //item名称
    let MyitemName = ["test1","test2","test3","test4","test5" ]
    
    @IBOutlet weak var tableView: UITableView!   // UItableview
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self //设置代理
        tableView.dataSource=self   //设置数据源
        self.tableView.tableFooterView=UIView() //去除多余底部线条
        self.automaticallyAdjustsScrollViewInsets=false // //取消掉被NavigationController管理的自动留白
        //设置去除tableview的底端横线
        
        ///这里就可以用登录后存储的用户数据来读取了，当然也可以每次进来都去网络请求数据（不建议这样做)
        let test1=MyModel()
        test1.phone="123"
        test1.name="张三"
        test1.userpic="https://www.baidu.com/img/baidu_jgylogo3.gif"
        My.append(test1  )
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //设置行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if((indexPath as NSIndexPath).section==0){
            return 100
        }
        else{
//            return  tableView.fd_heightForCellWithIdentifier(MyItemIdentifier, cacheByIndexPath: indexPath, configuration: { (cell)  in })
            return 65
        }
    }
    
    //返回节的个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //返回某个节中的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==0){
            return My.count
        }
        else  {
            return MyitemImage.count
        }
        
    }
    
    //为表视图单元格提供数据，该方法是必须实现的方法
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if( (indexPath as NSIndexPath).section == 0){    //我的信息
            let cell = tableView.dequeueReusableCell(withIdentifier: MyIdentifier, for: indexPath) as! MyTableViewCell
            cell.InitConfig(My[(indexPath as NSIndexPath).row])
            return cell
        }
        else{       //集合列表
            let cell = tableView.dequeueReusableCell(withIdentifier: MyItemIdentifier, for: indexPath) as! MyItemTableViewCell
            cell.InitConfig([MyitemImage[(indexPath as NSIndexPath).row],MyitemName[(indexPath as NSIndexPath).row]])
            return cell
        }
    }
    
    //点击某行的Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((indexPath as NSIndexPath).section==0){
           LoginLogicViewModel().LoginLogicViewModel(self)
        }
        else{
            switch((indexPath as NSIndexPath).row){
            case 0 :
                SelectedItem("",Identifier: "")
                break
            case 1 :
                SelectedItem("",Identifier: "")
                break
            case 2 :
                SelectedItem("",Identifier: "")
                break
            case 3 :
                SelectedItem("",Identifier: "")
                break
            case 4 :
                SelectedItem("",Identifier: "")
                break
            case 5 :
                SelectedItem("",Identifier: "")
                break
            case 6 :
                SelectedItem("",Identifier: "")
                break
            case 7 :
                SelectedItem("",Identifier: "")
                break
            case 8 :
                SelectedItem("",Identifier: "")
                break
            default:break
            }
        }
    }
    
    //选择的Item
    func SelectedItem(_ stroryboardName: String,Identifier: String){
        let vc =  CommonFunction.ViewControllerWithStoryboardName(stroryboardName, Identifier: Identifier)
        //present类型 (用在用户登录)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
