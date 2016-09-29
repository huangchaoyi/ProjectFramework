//
//  NetworkImageViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/7.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import SDWebImage


class ImagePreviewViewController: UIViewController,UIScrollViewDelegate {
    
    fileprivate  var scrollView: UIScrollView!  //滑动控件
    fileprivate  var ImageUrlList =  [Any]()         //图片URL路径集合 [  ] (数组类型)
    fileprivate  var ImagenamedList =  [Any]()       //图片集合 [  ] (数组类型)
    fileprivate  var UIImageList = [UIImage] () //图片集合  [ ] 数组类型
    fileprivate  var DescribeList =  [Any]()       //描述集合  [ ] 数组类型
    fileprivate  var InsetImageViewList=[Int]()      //添加的UIImageView集合 （用于检测当前集合是否已经添加过)
    fileprivate var DescribeLab:UITextView?     //描述文本
    fileprivate var IsDescribe:Bool=false         //是否显示描述
    
    fileprivate  var imageW:CGFloat!
    fileprivate var imageH:CGFloat!
    fileprivate var imageY:CGFloat!
    /**
     图片浏览
     
     - parameter ImageUrlList: 网络图片路径url ["http://1.jpg","http://2.jpg","http://3.jpg" ]
     - parameter IsDescribe:   是否显示描述  true\false
     - parameter DescribeList: 描述列表 如 ["1","2","3"]
     
     - returns:
     */
    init( ImageUrlList:[String],IsDescribe:Bool,DescribeList:[String] ){
        super.init(nibName: nil, bundle: nil)
        self.ImageUrlList=ImageUrlList
        self.IsDescribe=IsDescribe
        self.DescribeList=DescribeList
    }
    /**
     图片浏览
     
     - parameter ImagenamedList: 图片路径url ["1.jpg","2.jpg","3.jpg" ]
     - parameter IsDescribe:   是否显示描述 true\false
     - parameter DescribeList: 描述列表 如 ["1","2","3"]
     
     - returns:
     */
    init(ImagenamedList:[String],IsDescribe:Bool,DescribeList:[String]){
        super.init(nibName: nil, bundle: nil)
        self.ImagenamedList=ImagenamedList
        self.IsDescribe=IsDescribe
        self.DescribeList=DescribeList
    }
    /**
     图片浏览
     
     - parameter UIImageList: 图片路径url [UIImage(),UIImage(),UIImage() ]
     - parameter IsDescribe:   是否显示描述 true\false
     - parameter DescribeList: 描述列表 如 ["1","2","3"]
     
     - returns:
     */
    init(UIImageList:[UIImage],IsDescribe:Bool,DescribeList:[String]){
        super.init(nibName: nil, bundle: nil)
        self.UIImageList=UIImageList
        self.IsDescribe=IsDescribe
        self.DescribeList=DescribeList
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLoad(){
        
        scrollView=UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        imageW = self.view.frame.size.width;//获取ScrollView的宽作为图片的宽；
        imageH = self.view.frame.size.height;//获取ScrollView的高作为图片的高；
        
        if(IsDescribe==true){
            //添加一个描述UITextView
            DescribeLab=UITextView(frame: CGRect(x: 0.5,y: self.view.frame.maxY-120,width: self.view.frame.width-1,height: 120))
            DescribeLab!.font=UIFont.systemFont(ofSize: 14)
            DescribeLab!.backgroundColor=UIColor(hue: 0/255, saturation: 0/255, brightness: 0/255, alpha: 0.5)  //透明背景
            DescribeLab!.textColor=UIColor.white
            DescribeLab?.isEditable=false      //不可编辑
            self.view.addSubview(DescribeLab!)    //添加一个描述UITextView
        }
        //关闭滚动条显示
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        //协议代理，在本类中处理滚动事件
        scrollView.delegate = self
        //滚动时只能停留到某一页
        scrollView.isPagingEnabled = true
        imageY  = 0;//图片的Y坐标就在ScrollView的顶端；
        var index=0
        if(ImagenamedList.count>0){
            for i in ImagenamedList {    //本地图片
                if(index==0){   //默认进来的第一张则添加
                    AddUIImageView(i as AnyObject ,index: index)
                }
                index += 1
            }
        }
        if(ImageUrlList.count>0){
            for i in ImageUrlList { //网络图
                if(index==0){   //默认进来的第一张则添加
                    AddUIImageView(i as AnyObject ,index: index)
                }
                index += 1
            }
        }
        if(self.UIImageList.count>0){
            for i in UIImageList { //网络图
                if(index==0){   //默认进来的第一张则添加
                    AddUIImageView(i,index: index)
                }
                index += 1
            }
        }
        //需要非常注意的是：ScrollView控件一定要设置contentSize;包括长和宽；
        let contentW:CGFloat = imageW * CGFloat(index);//这里的宽度就是所有的图片宽度之和；
        self.scrollView.contentSize = CGSize(width: contentW, height: 0);
        
        scrollView.backgroundColor=UIColor.black //背景图
        let   TapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(ImagePreviewViewController.handleTapGesture(_:)))
        TapGestureRecognizer.numberOfTapsRequired = 1
        scrollView.isUserInteractionEnabled = true //设置交互
        scrollView.addGestureRecognizer(TapGestureRecognizer)   //点击手势
        
        self.view.addSubview(scrollView)
        if(IsDescribe==true){
            self.view.bringSubview(toFront: DescribeLab!)  //把当前描述的控件置顶
        }
        self.view.backgroundColor=UIColor.black  //背景色为黑色,要设置 不然设置透明bar就会出现白色底部
    }
    
    //UIScrollViewDelegate方法，每次滚动结束后调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //通过scrollView内容的偏移计算当前显示的是第几页
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //每次滑动都添加UIImageview
        if(ImagenamedList.count>0){
            AddUIImageView(ImagenamedList[page] as AnyObject ,index: page)
        }
        if(ImageUrlList.count>0){
            AddUIImageView(ImageUrlList[page] as AnyObject ,index: page)
        }
        if(UIImageList.count>0){
            AddUIImageView(UIImageList[page],index: page)
        }
    }
    
    //当前index 页面的 url 添加imageuiview
    fileprivate func AddUIImageView(_ url:AnyObject,index:Int){
        
        if(ImagenamedList.count>0){
            self.title="\((index+1))/"+ImagenamedList.count.description
        }
        if(ImageUrlList.count>0) {
            self.title="\((index+1))/"+ImageUrlList.count.description
        }
        if(UIImageList.count>0){
             self.title="\((index+1))/"+UIImageList.count.description
        }
        if(IsDescribe==true){
            //添加描述
            if(ImagenamedList.count>0){
                DescribeLab!.text="\((index+1))/"+ImagenamedList.count.description+"  "+(DescribeList[index] as! String)
            }
            if(ImageUrlList.count>0){
                DescribeLab!.text="\((index+1))/"+ImageUrlList.count.description+"  "+(DescribeList[index] as! String)
            }
            if(UIImageList.count>0){
                 DescribeLab!.text="\((index+1))/"+UIImageList.count.description+"  "+(DescribeList[index] as! String)
            }
        }
        for item in InsetImageViewList {
            if(item==index){
                return
            }
        }
        let imageX:CGFloat = CGFloat(index) * imageW;
        //创建图片
        let imageView=UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageW, height: imageH))//设置图片的大小，注意Image和ScrollView的关系，其实几张图片是按顺序从左向右依次放置在ScrollView中的，但是ScrollView在界面中显示的只是一张图片的大小，效果类似与画廊
        
        //添加图片
        if(ImagenamedList.count>0){
            imageView.image=UIImage(named: url as! String)
        }
        if(ImageUrlList.count>0){
             imageView.sd_setImage(with:URL(string: url as! String), placeholderImage: UIImage(named: placeholderImage),options:  SDWebImageOptions.retryFailed){ (UIImage, Error, SDImageCacheType, URL) in 
                if(UIImage != nil){
                     imageView.image=UIImage
                }
 
            }
        }
        if(UIImageList.count>0){ 
             imageView.image = url as? UIImage
        }
       
        imageView.contentMode=UIViewContentMode.scaleAspectFit 
        scrollView.addSubview(imageView)
        InsetImageViewList.append(index)    //把当前加载到Srcollview里面的Index加载到数组里去(判断是否已经该Index是否已经添加到Srcollview）
        
    }
    
    
    //点击屏幕时会调用此方法,放大和缩小图片
    func handleTapGesture(_ sender: UITapGestureRecognizer){
      
        if(self.navigationController?.isNavigationBarHidden==true){
            //带有滑动的隐藏方式
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            DescribeLab?.isHidden=false
        }
        else{
            //带有滑动的显示方式
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            DescribeLab?.isHidden=true
        }
    }
    
    //即将出现
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets=false
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
