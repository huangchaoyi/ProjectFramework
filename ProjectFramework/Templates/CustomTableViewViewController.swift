//
//  CustomTableViewViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/4.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import MJRefresh

class CustomTableViewViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,CYLTableViewPlaceHolderDelegate {
    
    fileprivate var tableView:UITableView? = nil
    fileprivate var collection:UICollectionView? = nil
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    ///Tableview
    internal func InitCongif(_ tableView:UITableView){
        self.tableView=tableView
        tableView.delegate=self //设置代理
        tableView.dataSource=self   //设置数据源
        self.tableView?.tableFooterView=UIView() //去除多余底部线条
        self.automaticallyAdjustsScrollViewInsets=false // //取消掉被NavigationController管理的自动留白
        
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction:#selector(CustomTableViewViewController.headerRefresh))
        self.tableView?.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction:#selector(CustomTableViewViewController.footerRefresh))
        self.tableView?.mj_footer = footer
        self.view.addSubview(tableView)
        
        self.footer.isAutomaticallyHidden=true    //隐藏当前footer 会自动根据数据来隐藏和显示
    }
    
    ///Collection
    internal func InitCongifCollection(_ Collection:UICollectionView){
        self.collection=Collection
        Collection.delegate=self //设置代理
        Collection.dataSource=self   //设置数据源
        self.automaticallyAdjustsScrollViewInsets=false // //取消掉被NavigationController管理的自动留白
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction:#selector(CustomTableViewViewController.headerRefresh))
        self.collection?.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction:#selector(CustomTableViewViewController.footerRefresh))
        self.collection?.mj_footer = footer
        self.view.addSubview(Collection)
        
        self.footer.isAutomaticallyHidden=true    //隐藏当前footer 会自动根据数据来隐藏和显示
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - 上拉下拉 刷新
    
    /// 顶部刷新
    func headerRefresh(){
        
    }
    
    /// 底部刷新
    func footerRefresh(){
        
    }
    
    // MARK: - 空数据的时候TableView Placeholder
    func makePlaceHolderView() -> UIView! {
        if(NetWordStatus==true){
            let vc =   TableViewEmptyView(1, target: self,action: #selector(CustomTableViewViewController.EmptyOverlayClicked))
            return vc
        }else{
            let vc =   TableViewEmptyView(2, target: self,action: #selector(CustomTableViewViewController.EmptyOverlayClicked))
            return vc
        }
        
    }
    
    // MARK:网络失败或者获取数据为空的占位空视图
    ///类型1 无数据 2无法连接到网络
    fileprivate    func TableViewEmptyView(_ type:Int,target: AnyObject?,action:Selector ) ->UIView{
        let uiview = UIView(frame: CGRect(x: 0, y: 0, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight))   //创建一个uiview
        let   customImageView = UIImageView(frame:uiview.frame) //创建图片
        customImageView.contentMode = .center   //图片设置
        customImageView.isUserInteractionEnabled=true //设置可以触发的
        let tapGesture = UITapGestureRecognizer(target: target, action:action )  //设置点击手势
        tapGesture.numberOfTapsRequired = 1 //设置手势点击数,双击：点1下
        customImageView.addGestureRecognizer(tapGesture)
        switch(type){
        case 1:
            customImageView.image=UIImage(named: "TemplatesSettings.bundle/NoData.jpeg")
            break
        case 2:
            customImageView.image=UIImage(named: "TemplatesSettings.bundle/Nonetwork.jpeg")
            break
        default:break
        }
        
        uiview.addSubview(customImageView)  //uiview添加图片
        return uiview   //返回
    }
    
    /**
     空视图点击
     */
    func EmptyOverlayClicked(){
        
    }
    //-------------------------Tableview------------------------
    // MARK: - UITableViewDelegate,UITableViewDataSources 需要实现的函数
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //返回节的个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    //返回某个节中的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    //为表视图单元格提供数据，该方法是必须实现的方法
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
        
    }
    //选中
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //-------------------------Coll------------------------
    // MARK: - UICollectionViewDelegate,UICollectionViewDataSource 需要实现的函数
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
}
