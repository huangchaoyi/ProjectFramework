//
//  UpLoadPicManagerViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/6/27.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

class UpLoadPicManagerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //类似于OC中的typedef
    typealias CallbackSelectedValue=(_ SelectedImageValue:[UIImage])->Void
    
    //声明一个闭包
    var myCallbackValue:CallbackSelectedValue?
    //下面这个方法需要传入上个界面的函数指针
    func  Callback_SelectedValue(_ value:CallbackSelectedValue?){
        //将函数指针赋值给闭
        myCallbackValue = value
    }
    
    fileprivate let reuseIdentifier = "Cell"
    fileprivate let DefaultName="CustomSettings.bundle/add.png"   //默认添加图片名称
    fileprivate var ImgItem=Array<UIImage>()    //选中图片的集合，默认第一个是未选择
    fileprivate var DefaultImg=UIImage()   //默认图片（加号 、add）
    fileprivate var collectionView:UICollectionView!    //UICollectionView控件
    /// 自增高
    var Sincethehigher=false
    ///竖屏显示的图片数 （暂时未做横屏手机item  间距直接也存在点差异 ipad 没事 iPhone需要修改
    ///默认是4张   建议最多一行设置不要超过5张
    var Showrowsitem:CGFloat=4
    /// 最多能选择的图片总数  默认10张
    var SelectedImgMaxCount:Int  = 10
    /// 获取图片高度
    var GetImgHeight:CGFloat=0
    ///self
    var delegate : UIViewController?
    
    init(frame: CGRect,delegate:UIViewController,Callback_SelectedValue:@escaping CallbackSelectedValue) {
        super.init(frame: frame)
        self.myCallbackValue=Callback_SelectedValue
        self.delegate=delegate
        load()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load()
    }
    
    /**
     背景颜色 默认白色
     
     - parameter color: color
     */
    func backgroundColor(_ color:UIColor=UIColor.white){
        collectionView.backgroundColor=color
        
    }
    
    /**
     获取Img集合
     
     - returns: 返回所选图片的集合 [UIImage]
     */
    func GetImgItem()->[UIImage]{
        
        var imgitem=[UIImage]()
        
        for item in ImgItem {
            
            if(item != DefaultImg){ //判断如果是默认图片则不传外部
                imgitem.append(item)
            }
        }
        return imgitem
    }
    
    /**
     获取viewCellAll
     
     - returns: CustomImageView
     */
    func GetCellImgItem()->[CustomImageView]{
      var customImageView=[CustomImageView]()
        for item in self.collectionView.visibleCells {
            if(item.isKind(of: VFisrstCollectionViewCell.self)){
                let cell = item as! VFisrstCollectionViewCell
                if(cell.showImage?.customImageView?.image != DefaultImg){
                    customImageView.append(cell.showImage!)
                }
                
            }
            
        }
        return customImageView
    }
    
    /**
     设置图片 图片数不要超过 SelectedImgMaxCount
     
     - parameter imgitem: 图片集合
     */
    func SetImgItem(_ imgitem:[UIImage]){
        
        if(self.ImgItem.count+imgitem.count>self.SelectedImgMaxCount+1){
            MBProgressHUD.showError("最多只能选择 \(self.SelectedImgMaxCount) 张图片")
            return
        }
        
        if(self.ImgItem.count>0){
            //已经有图片添加过了 那么就删除最后一个图 （默认的图片)
            self.ImgItem.removeLast()   //删除默认的图片
        }
        for item in imgitem {
            ImgItem.append(item)
        }
        if(self.ImgItem.count<self.SelectedImgMaxCount){
            //如果当前选择的图片小鱼设定的图片总数
            self.ImgItem.append(self.DefaultImg)    //添加一张默认的 add 图片
        }
        self.collectionView.reloadData()
    }
    
    func load(){
        DefaultImg=UIImage(named: DefaultName)!
        
        self.delegate?.automaticallyAdjustsScrollViewInsets=false
        //设置flowlayout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing=2 // minimumInteritemSpacingForSectionAtIndex  上下间距
        layout.minimumInteritemSpacing=2     //minimumLineSpacingForSectionAtIndex  左右间距
        layout.sectionInset=UIEdgeInsets(top: 0, left: 2, bottom:0, right: 2)   //设置每个cell的间距
        let itemsSpacing=layout.minimumLineSpacing + layout.sectionInset.left-1 //获取设置间距长度
        GetImgHeight=(self.bounds.size.width/Showrowsitem)/120.0*90
        layout.itemSize = CGSize(width: self.bounds.size.width/Showrowsitem-itemsSpacing, height: GetImgHeight)
        layout.headerReferenceSize = CGSize(width: self.frame.width, height: 0.5) //设置顶部高度
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), collectionViewLayout: layout)
        
        // 注册CollectionViewCell
        self.collectionView.register(VFisrstCollectionViewCell.self,
                                          forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.scrollsToTop = false
        self.collectionView.isScrollEnabled=false
        self.collectionView.dataSource=self
        self.collectionView.delegate=self
        self.collectionView.backgroundColor=UIColor.white
        self.addSubview(collectionView)
        
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(Sincethehigher){ //如果自动自增高
            var thisheight:CGFloat=0
            switch ImgItem.count/Int(Showrowsitem) {
            case 0: thisheight=GetImgHeight*1;break
            case 1: thisheight=GetImgHeight*2;break
            case 2: thisheight=GetImgHeight*3;break
            case 3: thisheight=GetImgHeight*4;break
            case 4: thisheight=GetImgHeight*5;break //20张图片
            case 5: thisheight=GetImgHeight*6;break
            case 6: thisheight=GetImgHeight*7;break
            case 7: thisheight=GetImgHeight*8;break
            case 8: thisheight=GetImgHeight*9;break
            case 9: thisheight=GetImgHeight*10;break //40张图片
            default: break
            }
            self.frame=CGRect(x: self.frame.minX,y: self.frame.minY, width: self.frame.width, height: thisheight)
            self.collectionView.frame=CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if(ImgItem.count==0){
            ImgItem.append(DefaultImg)  //如果是第一次进来，默认一张图片
            return 1
        }
        return ImgItem.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VFisrstCollectionViewCell
        
        cell.showImage?.customImageView?.image=ImgItem[(indexPath as NSIndexPath).row]
        if(ImgItem[(indexPath as NSIndexPath).row]==DefaultImg){
            cell.showImage?.deletebtn?.isHidden=true   //隐藏删除按钮
        }else{
            cell.showImage?.deletebtn?.isHidden=false   //显示删除按钮
        }
        cell.showImage?.deletebtn?.tag=(indexPath as NSIndexPath).row
        cell.tag=(indexPath as NSIndexPath).row
        cell.showImage?.deletebtn?.addTarget(self, action: #selector(UpLoadPicManagerView.DeleteImg(_:)), for: .touchUpInside)    //删除事件
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(ImgItem[(indexPath as NSIndexPath).row]==DefaultImg){ //如果当前点击的图片是默认的图片则选择图片
            SelectedImg()
        }else{  //查看大图
            let vc = ShowImageViewController()
            vc.image=ImgItem[(indexPath as NSIndexPath).row]
            self.delegate?.navigationController?.pushViewController(vc, animated: true) 
           
        }
    }
    
    @objc fileprivate  func DeleteImg(_ sender: UIButton){
        progressvaluenil()
        ImgItem.remove(at: sender.tag)
        var defaultImg=false    //是否存在默认图片
        for item in ImgItem {
            //每次删除之前都去检查当前图片集合里是否存在默认add图片 ，如果不存在，则表明之前已经添加满最大SelectedImgMaxCount图片了，并且现在删除了一张图片,需要把默认add图片再次添加
            if(item == DefaultImg){
                defaultImg=true //修改标识表示存在默认add图片
            }
        }
        if(defaultImg==false){  //如果未存在默认add图片
            self.ImgItem.append(self.DefaultImg)//添加默认add图片
        }
        self.collectionView.reloadData()
    }
    
    //每次删除都先把控件进度条=0
    fileprivate func progressvaluenil(){
        for item in self.collectionView.subviews {
            if(item.isKind(of: VFisrstCollectionViewCell.self)){
                let cell = item as! VFisrstCollectionViewCell
                cell.showImage?.progress?.setProgress(0, animated: false)
            }
        }

    }
    //选择图片
    fileprivate func SelectedImg(){
        let vc = PictrueSelectedViewController(IsSelecetdMultiple: true) { (value) in
            self.progressvaluenil()
            self.SetImgItem(value)
            
            if(self.myCallbackValue != nil){    //必包回调
                self.myCallbackValue!(value)
            }
        } 
        self.delegate?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //collectionView Cell
    class VFisrstCollectionViewCell: UICollectionViewCell {
        
        var showImage: CustomImageView? //自定义图片
        override func awakeFromNib() {
            super.awakeFromNib()
            
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            showImage=CustomImageView(frame: self.bounds)
            showImage?.customImageView?.contentMode = .scaleToFill
            
            self.addSubview(showImage!)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    
    
    //显示的图片viewcontroller
    class ShowImageViewController: UIViewController {
        
        var image=UIImage()
        override func viewDidLoad() {
            super.viewDidLoad()
            let ShowImage=UIImageView(frame: self.view.frame)
            self.view.addSubview(ShowImage)
            ShowImage.image=image
            ShowImage.contentMode = UIViewContentMode.scaleAspectFit
            self.view.backgroundColor=UIColor.black
            let   TapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(ShowImageViewController.handleTapGesture(_:)))
            TapGestureRecognizer.numberOfTapsRequired = 1
            
            ShowImage.isUserInteractionEnabled = true //设置交互
            ShowImage.addGestureRecognizer(TapGestureRecognizer)
        }
        
        //点击屏幕时会调用此方法,放大和缩小图片
        func handleTapGesture(_ sender: UITapGestureRecognizer){
            if(self.navigationController?.isNavigationBarHidden==true){
                //带有滑动的隐藏方式
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }
            else{
                //带有滑动的显示方式
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
        }
        
        
      
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        //即将出现
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //设置刚进来的时候默认的透明Bar
            self.navigationController?.navigationBar.isTranslucent=true
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(),for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            //返回视图的时候设置导航为不透明
            self.navigationController?.navigationBar.isTranslucent=false
        }
        
    }
    
}
