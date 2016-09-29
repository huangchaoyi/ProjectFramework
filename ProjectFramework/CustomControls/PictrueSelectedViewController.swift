

import UIKit
import AssetsLibrary

///图片选择
class PictrueSelectedViewController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource    {
    
    fileprivate let reuseIdentifier = "Cell"
    
    
    fileprivate let  SelectedCheckImg="CustomSettings.bundle/photo_sel_photoPickerVc.png"   //选中的图片名称
    fileprivate let NoCheckImg="CustomSettings.bundle/photo_def_photoPickerVc.png"                //未选中的图片名称
    
    //类似于OC中的typedef
    typealias CallbackSelectedValue=(_ value:[UIImage])->Void
    
    //声明一个闭包
    var myCallbackValue:CallbackSelectedValue?
    //下面这个方法需要传入上个界面的函数指针
    func  Callback_SelectedValue(_ value:CallbackSelectedValue?){
        //将函数指针赋值给闭
        myCallbackValue = value
    }
    
    /// 是否可以多选
    fileprivate   var IsSelecetdMultiple=true
    
    /**
     初始化 参数1 是否多选 参数2 返回选取值,返回对象[UIImage]
     
     - parameter IsSelecetdMultiple:     是否多选 true多选  false 单选
     - parameter Callback_SelectedValue: 回调选取值 返回对象 [UIImage]
     
     - returns:
     */
    init (IsSelecetdMultiple:Bool,Callback_SelectedValue:@escaping CallbackSelectedValue ){
        super.init(nibName: nil, bundle: nil)
        self.myCallbackValue=Callback_SelectedValue
        self.IsSelecetdMultiple=IsSelecetdMultiple
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate  var assetsLibrary =  ALAssetsLibrary() //资源库管理类
    
    fileprivate var assets = [ALAsset]()//保存照片集合
    fileprivate  var CheckItem=NSHashTable<AnyObject>()  //选中的(图片)HashTable集合
    fileprivate  var bartranslucent=false   //监测translucent=false的时候记录
    var collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="相册"
        if(IsSelecetdMultiple==true){
            //自定义一个完成的按钮
            self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "完成",style:  .done, target: self, action: #selector(PictrueSelectedViewController.Next)) 
        }
        let showrowsitem:CGFloat=4  //竖屏显示的图片数 （暂时未做横屏手机item  间距直接也存在点差异 ipad 没事 iPhone需要修改
        //设置flowlayout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing=2 // minimumInteritemSpacingForSectionAtIndex  上下间距
        layout.minimumInteritemSpacing=2     //minimumLineSpacingForSectionAtIndex  左右间距
        layout.sectionInset=UIEdgeInsets(top: 0, left: 2, bottom:0, right: 2)   //设置每个cell的间距
        let itemsSpacing=layout.minimumLineSpacing + layout.sectionInset.left-1 //获取设置间距长度
        layout.itemSize = CGSize(width: self.view.bounds.size.width/showrowsitem-itemsSpacing, height: (view.bounds.size.width/showrowsitem)/120.0*90)
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 3) //设置顶部高度
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        
        // 注册CollectionViewCell
        self.collectionView.register(VFisrstCollectionViewCell.self,
                                          forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.scrollsToTop = true
        self.collectionView.dataSource=self
        self.collectionView.delegate=self
        self.collectionView.backgroundColor=UIColor.white
        self.view.addSubview(collectionView)
        GetSystemImage()  //获取系统相机胶卷图片（可以全部获取)
    }
    
    func  GetSystemImage(){
        
        //ALAssetsGroupSavedPhotos表示只读取相机胶卷（ALAssetsGroupAll则读取全部相簿）ALAssetsGroupSavedPhotos
        assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (ALAssetsGroup,stop) in
            if ALAssetsGroup != nil
            {
                let assetBlock : ALAssetsGroupEnumerationResultsBlock = {
                    (result , index , stop) in
                    if result != nil
                    {
                        self.assets.insert(result!, at: 0)  //把当前最新的图片放在前面
                    }
                }
                ALAssetsGroup?.enumerateAssets(assetBlock)
                //                //collectionView网格重载数据
                self.collectionView.reloadData()
            }
            }) { (Error) in
                 print(Error!)
        }
        
    }
    
    //即将出现
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //判断translucent是否等于false 如果是false则需要-去当前的nav高度（64）位  因为视图占用问题
        if(self.navigationController?.navigationBar.isTranslucent==false){
            if(self.collectionView != nil){
                if(bartranslucent==false){
                    self.collectionView.frame=CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-CommonFunction.NavigationControllerHeight)
                    bartranslucent=true
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    
    //下一步
    func Next(){
        
        var  imglist = [UIImage]() //定义一个选中的图片集合
        
        let itme = CheckItem.allObjects.sorted(by: { n1, n2 in
            //进行从小到大的排序
            return n2 as! Int > n1 as! Int
        })
        //获取选中的相册
        for  i in itme {
            let myAsset = assets[i as! Int]
            //备注说明：如果使用模拟器调试会造成内存泄漏（检测工具：Instruments) 真机不会泄漏
            let img = UIImage(cgImage:myAsset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())  //原图 ( 没经过像素压缩处理的
            imglist.append(img)
        }
        if(myCallbackValue != nil){
            if(imglist.count>0){
                //有图片就回调
                myCallbackValue!(imglist)
            }
            _ = navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return assets.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VFisrstCollectionViewCell
        
        //取缩略图
        let myAsset = assets[(indexPath as NSIndexPath).row]
        //– thumbnail（小正方形的缩略图）
        //– aspectRatioThumbnail（按原始资源长宽比例的缩略图）
        cell.showImage!.image =
            UIImage(cgImage: myAsset.thumbnail().takeUnretainedValue())
        
        if(IsSelecetdMultiple==true){   //可以多选
            cell.SelectedPic!.isHidden=false
            cell.SelectedPic!.addTarget(self, action: #selector(PictrueSelectedViewController.SelectedPic(_:)), for: .touchUpInside)
            cell.SelectedPic!.tag=(indexPath as NSIndexPath).row
            
            //检查选选中和不选中（如果选中一个打钩，滑动的时候会默认一个index所以每次重写加载cell的时候
            //必须把所有当前看到的图片全部为未选中,如果当前index有选中的tag标识则改成选中状态
            if(CheckItem.contains((indexPath as NSIndexPath).row as AnyObject?)){ //检查当前存储的tag标识
                cell.SelectedPic!.setImage(UIImage(named: SelectedCheckImg), for: UIControlState())  //选中
            }
            else{
                cell.SelectedPic!.setImage(UIImage(named: NoCheckImg), for: UIControlState())  //不选中
            }
            
        }else{  //单选
            cell.SelectedPic!.isHidden=true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //点击大图
        let myAsset = assets[(indexPath as NSIndexPath).row]
        //获取文件名
        let representation =  myAsset.defaultRepresentation()
        //备注说明：如果使用模拟器调试会造成内存泄漏（检测工具：Instruments) 真机不会泄漏
        let img = UIImage(cgImage:(representation?.fullResolutionImage().takeUnretainedValue())!)  //原图 ( 没经过像素压缩处理的
        let vc =  ShowImageViewController()
        vc.title=representation?.filename() //图片名称
        vc.image=img
        vc.IsSelecetdMultiple=self.IsSelecetdMultiple
        vc.Callback_SelectedValue { (value) -> Void in
            
            if(self.myCallbackValue != nil){
                var imglist=[UIImage]()
                imglist.append(value)
                self.myCallbackValue!(imglist)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //选择图片时存储的标识
    func SelectedPic(_ sender: AnyObject){
        let btn = sender as! UIButton
        if(CheckItem.contains(btn.tag as AnyObject?)){ //检查当前存储的tag标识
            //存在的
            if(btn.currentImage==UIImage(named: NoCheckImg)){    //如果是未选中的
                btn.setImage(UIImage(named: SelectedCheckImg), for: UIControlState()) //设置为选中
                CheckItem.add(btn.tag as AnyObject?)  //增加到集合里
            }else {
                btn.setImage(UIImage(named: NoCheckImg), for: UIControlState())  //不选中
                CheckItem.remove(btn.tag as AnyObject?)   //移除集合
            }
        }else{
            
            btn.setImage(UIImage(named: SelectedCheckImg), for: UIControlState())    //选中
            CheckItem.add(btn.tag as AnyObject?)    //添加到集合
        }
        
    }
    
}

//collectionView Cell
class VFisrstCollectionViewCell: UICollectionViewCell {
    
    var showImage: UIImageView?
    var SelectedPic: UIButton?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        showImage=UIImageView(frame: self.bounds)
        showImage!.layer.cornerRadius=1
        showImage!.layer.borderColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1).cgColor
        showImage!.layer.borderWidth=1
        showImage!.contentMode = .scaleToFill
        SelectedPic=UIButton(frame: CGRect(x: self.frame.width-32, y: 3, width: 30, height: 28))
        self.addSubview(showImage!)
        self.addSubview(SelectedPic!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//显示的图片viewcontroller
class ShowImageViewController: UIViewController {
    
    //类似于OC中的typedef
    typealias CallbackSelectedValue=(_ value:UIImage)->Void
    
    //声明一个闭包
    var myCallbackValue:CallbackSelectedValue?
    //下面这个方法需要传入上个界面的函数指针
    func  Callback_SelectedValue(_ value:CallbackSelectedValue?){
        //将函数指针赋值给闭
        myCallbackValue = value
    }
    
    fileprivate var btnSelected=UIButton()  //选中
    fileprivate  var btnCancel=UIButton()    //取消
    fileprivate var BottomView=UIView()     //底部view
    
    var image=UIImage()
    var IsSelecetdMultiple=true //是否多选
    
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
        if(IsSelecetdMultiple==false){ //单选就增加选取功能
            initBottom()
        }
    }
    
    func  initBottom(){
        
        //添加uiview在底部
        BottomView =  UIView(frame: CGRect(x: 0, y: self.view.frame.height-60,width: self.view.frame.width, height: 60))
        BottomView.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        self.view.addSubview(BottomView)
        let  _width1 = (BottomView.frame.width*(1+1)-BottomView.frame.width) / CGFloat(2) //整个BottomView宽度的100% / 2
        for   i:Int in 0  ..< 2  {
            
            switch(i){
            case 0:
                btnSelected.frame=CGRect(x: CGFloat(i)*_width1, y: 0, width: _width1, height: 60)
                btnSelected.titleLabel?.font=UIFont.systemFont(ofSize: 15)
                btnSelected.setTitleColor(UIColor.white, for: UIControlState())
                btnSelected.setTitle("选取", for: UIControlState())
                BottomView.addSubview(btnSelected)
                break
            case 1:
                btnCancel.frame=CGRect(x: CGFloat(i)*_width1, y: 0, width: _width1, height: 60)
                btnCancel.titleLabel?.font=UIFont.systemFont(ofSize: 15)
                btnCancel.setTitleColor(UIColor.white, for: UIControlState())
                btnCancel.setTitle("取消", for: UIControlState())
                
                BottomView.addSubview(btnCancel)
                break
                
            default:
                break
            }
        }
        btnSelected.addTarget(self, action: #selector(ShowImageViewController.selected(_:)), for: .touchUpInside)
        btnCancel.addTarget(self, action: #selector(ShowImageViewController.cancel), for: .touchUpInside)
    }
    
    func cancel(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    //点击选中处理
    func selected(_ sender:UIButton) {
        
        if(myCallbackValue != nil){
            myCallbackValue!(image)
            _ = navigationController?.popViewController(animated: true)
        }
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
