//
//  CustomTableViewViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/4.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import MJRefresh
import DZNEmptyDataSet

class CustomTemplateViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
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
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        self.tableView?.tableFooterView=UIView() //去除多余底部线条
        self.automaticallyAdjustsScrollViewInsets=false // //取消掉被NavigationController管理的自动留白
        
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction:#selector(CustomTemplateViewController.headerRefresh))
        self.tableView?.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction:#selector(CustomTemplateViewController.footerRefresh))
        self.tableView?.mj_footer = footer
        self.view.addSubview(tableView)
        
        self.footer.isAutomaticallyHidden=true    //隐藏当前footer 会自动根据数据来隐藏和显示
    }
    
    ///Collection
    internal func InitCongifCollection(_ Collection:UICollectionView){
        self.collection=Collection
        Collection.delegate=self //设置代理
        Collection.dataSource=self   //设置数据源
        Collection.emptyDataSetSource = self;
        Collection.emptyDataSetDelegate = self;
        self.automaticallyAdjustsScrollViewInsets=false // //取消掉被NavigationController管理的自动留白
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction:#selector(CustomTemplateViewController.headerRefresh))
        self.collection?.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction:#selector(CustomTemplateViewController.footerRefresh))
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
    
    //-------------------------emptyDataSet-------------------------
    // MARK: - UICollectionViewDelegate,UICollectionViewDataSource
    /**
     *  返回标题文字
     */
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var text="我什么也没找到"
        if(NetWordStatus==false){    //断网时
            text="网络出现状况了"
        }
        let paragraph=NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let dic = [NSFontAttributeName:UIFont.systemFont(ofSize:14),
                   NSForegroundColorAttributeName:CommonFunction.RGBA(73, g: 76, b: 82),
                   NSParagraphStyleAttributeName:paragraph]
        let attributes = NSMutableAttributedString(string: text, attributes: dic)
        
        return attributes
    }
    /**
     *  标题明细文字
     */
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var text="我很努力加载数据了，但是还是没找到数据"
        if(NetWordStatus==false){    //断网时
            text="请检查网络是否正常连接"
        }
        let paragraph=NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let dic = [NSFontAttributeName:UIFont.systemFont(ofSize:13),
                   NSForegroundColorAttributeName:CommonFunction.RGBA(145, g: 148, b: 153),
                   NSParagraphStyleAttributeName:paragraph]
        let attributes = NSMutableAttributedString(string: text, attributes: dic)
        
        return attributes
    }
    
    /**
     *  按钮图标LOGO
     */
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        var text="我什么也没有,点我也没用"
        if(NetWordStatus==false){    //断网时
            text="点击我重新刷新数据"
        }
        let dic = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16),
                   NSForegroundColorAttributeName:CommonFunction.RGBA(0, g: 185, b: 249)]
        
        
        let attributes = NSMutableAttributedString(string: text, attributes: dic)
        
        return attributes
    }
    
    /**
     *  按钮图标
     */
    func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
        var imgname=""
        if(state == .normal){
            imgname=""
        }
        if(state == .highlighted){
            imgname=""
        }
        
        let capInsets:UIEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        let rectInsets:UIEdgeInsets  = UIEdgeInsets.zero
        
        let uiimage=UIImage(named: imgname)
        uiimage?.resizableImage(withCapInsets:capInsets, resizingMode:  .stretch)
        
        uiimage?.withAlignmentRectInsets(rectInsets)
        
        return  uiimage
    }
    
    
    /**
     *  返回图标LOGO
     */
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        var imgname="placeholder_vesper" //没有数据
        if(NetWordStatus==false){    //断网时
            imgname="placeholder_remote"    //断网
        }
        return UIImage(named: imgname)
    }
    
    /**
     *  返回背景颜色
     */
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
    
    /**
     *  返回高度的间隙(空间)
     */
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 15.0
    }
    
    
    /**
     *  数据源为空时是否渲染和显示
     */
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    /**
     *  是否允许点击
     */
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    /**
     *  是否允许滚动
     */
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
    /**
     *  空白处区域点击事件
     */
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        debugPrint("别点我,我是空白view点我干嘛？,我是在Deubg状态下才出来的哟")
    }
    /**
     *  按钮点击事件
     */
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        debugPrint("点击到了按钮!,我是在Deubg状态下才出来的哟")
    }
    
}
