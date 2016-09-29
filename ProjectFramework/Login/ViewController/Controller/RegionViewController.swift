//
//  RegionController.swift
//  ProjectFramework
//
//  Created by hcy on 16/5/29.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

class RegionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    typealias CallbackValue=(_ value:Int)->Void //类似于OC中的typedef
    var myCallbackValue:CallbackValue?  //声明一个闭包
    func  funcCallbackValue(_ value:CallbackValue?){
        myCallbackValue = value //返回值
    }
    
    
    let Identifier="RegionCell"
    var region=[Region]()
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.red
        
        self.tableView.delegate=self
        self.tableView.dataSource=self
        print(tableView.frame)
        //注册cell
        //        self.tableView.registerClass(RegionViewCell.self, forCellReuseIdentifier: Identifier)
        self.region=HttpsRegion().GetRegionCode()   //获取区号编码
        self.tableView.tableFooterView=UIView()
        self.tableView.reloadData()
        //初始化tableview和topview控件高宽度
        let topviewHeight:CGFloat=70
        topview.frame=CGRect(x: 0, y: 0, width: CommonFunction.kScreenWidth, height: topviewHeight)
        tableView.frame=CGRect(x: 0, y: topview.frame.maxY, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight-topviewHeight)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return region.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier, for: indexPath)
        
        //      cell.config(region[indexPath.row])
        cell.textLabel?.text="+"+region[(indexPath as NSIndexPath).row].RegionCode.description
        cell.textLabel?.tag=region[(indexPath as NSIndexPath).row].RegionCode
        cell.detailTextLabel?.text=region[(indexPath as NSIndexPath).row].RegionName
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (myCallbackValue != nil){
            myCallbackValue!(region[(indexPath as NSIndexPath).row].RegionCode)//回调。
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    
}
