//
//  ScrollViewPageViewController.swift
//  CityParty
//
//  Created by hcy on 15/11/8.
//  Copyright © 2015年 hcy. All rights reserved.
//

import UIKit

///滚动页
class ScrollViewPageViewController: UIViewController, UIScrollViewDelegate {
    
    //类似于OC中的typedef
    typealias CallbackSelectedValue=(_ value:Int,_ isLast:Bool)->Void
    
    //声明一个闭包
    var myCallbackValue:CallbackSelectedValue?
    //下面这个方法需要传入上个界面的函数指针
    func  Callback_SelectedValue(_ value:CallbackSelectedValue?){
        //将函数指针赋值给闭
        myCallbackValue = value
    }
    
    //按钮跳转点击后回调
    typealias CallbackJumpValue=(_ selectedImage:UIImage)->Void
    
    //声明一个闭包
    var myCallbackJumpValue:CallbackJumpValue?
    //下面这个方法需要传入上个界面的函数指针
    func  Callback_JumpValue(_ value:CallbackJumpValue?){
        //将函数指针赋值给闭
        myCallbackJumpValue = value
    }
    
    fileprivate  var pageControl: UIPageControl!
    fileprivate  var scrollView: UIScrollView!
    fileprivate  var jump:UIButton!     //跳转按钮
    fileprivate  var timer:Timer!     //滑动计时器
    fileprivate  var _frame:CGRect!
    
    fileprivate  var imageW:CGFloat!
    fileprivate var imageH:CGFloat!
    fileprivate var imageY:CGFloat!
    
    /// 是否触发计时器
    fileprivate  var  Enabletimer=false
    /// 是否显示跳转按钮
    fileprivate  var  isJumpBtn = false
    /// 设置计时器的滚动秒数
    fileprivate  var timerInterval:Double=3
    /// 图片集合
    fileprivate  var ImageList = [String]()
    
    /**
     初始化参数
     
     - parameter Enabletimer:   是否启动轮播
     - parameter timerInterval: 秒数
     - parameter ImageList:     图片集合NSArray 如 a=["1.png","2.png"]
     - parameter frame:         self.View.frame 大小
     - parameter Callback_SelectedValue:  回调选择的index
     - parameter isJumpBtn:     是否有跳转按钮
     
     - returns:
     */
    init(Enabletimer:Bool,timerInterval:Double,ImageList:[String],frame:CGRect,Callback_SelectedValue:CallbackSelectedValue?,isJumpBtn:Bool?,Callback_JumpValue:CallbackJumpValue?){
        super.init(nibName: nil, bundle: nil)
        self.Enabletimer=Enabletimer
        self.timerInterval=timerInterval
        self.ImageList = ImageList 
        _frame=frame
        self.myCallbackValue=Callback_SelectedValue
        if(isJumpBtn != nil){
            self.isJumpBtn=isJumpBtn!
        }
        self.myCallbackJumpValue=Callback_JumpValue
        self.view.frame=_frame
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLoad() 
    }
    
    func initLoad(){
        
        if(Enabletimer==true){
            self.timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(ScrollViewPageViewController.NextPage(_:)), userInfo: nil, repeats: true);
        }
        if(_frame != nil){
            
            pageControl=UIPageControl(frame: CGRect(x: 0, y: _frame.height-20,width: _frame.width, height: 20))
            scrollView=UIScrollView(frame: CGRect(x: 0, y: 0, width: _frame.width, height: _frame.height))
          
            
            imageW = _frame.size.width;//获取ScrollView的宽作为图片的宽；
            imageH = _frame.size.height;//获取ScrollView的高作为图片的高；
        }
        if(isJumpBtn==true){
            //跳转按钮
            jump=UIButton(frame: CGRect(x: self.view.frame.maxX-70, y: 35, width: 50, height: 25))
            jump.setTitle("跳转", for: UIControlState())
            jump.titleLabel?.font=UIFont.systemFont(ofSize: 14)
            jump.layer.cornerRadius=2
            jump.layer.borderColor=UIColor.white.cgColor
            jump.layer.borderWidth=0.5
            jump.addTarget(self, action: #selector(ScrollViewPageViewController.JumpBtnEvent), for: .touchUpInside)
            
        }
        //关闭滚动条显示
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        //协议代理，在本类中处理滚动事件
        scrollView.delegate = self
        //滚动时只能停留到某一页
        scrollView.isPagingEnabled = true
        //添加页面到滚动面板里
        
        imageY  = 0;//图片的Y坐标就在ScrollView的顶端；
        var index=0
        for i in ImageList {
            let imageView=UIImageView(image:UIImage(named:i ))
            let imageX:CGFloat = CGFloat(index) * imageW;
            imageView.frame = CGRect(x: imageX, y: imageY, width: imageW, height: imageH);//设置图片的大小，注意Image和ScrollView的关系，其实几张图片是按顺序从左向右依次放置在ScrollView中的，但是ScrollView在界面中显示的只是一张图片的大小，效果类似与画廊；
            imageView.contentMode=UIViewContentMode.scaleToFill
            imageView.isUserInteractionEnabled=true   //可点击的
            let tapGesture = UITapGestureRecognizer(target: self, action:#selector(ScrollViewPageViewController.ImagepageChanged(_:)) )  //设置点击手势
            tapGesture.numberOfTapsRequired = 1 //设置手势点击数,双击：点1下
            tapGesture.ExpTagString=index.description
            imageView.addGestureRecognizer(tapGesture)
            scrollView.addSubview(imageView)
            index += 1
        }
        //需要非常注意的是：ScrollView控件一定要设置contentSize;包括长和宽；
        let contentW:CGFloat = imageW * CGFloat(index);//这里的宽度就是所有的图片宽度之和；
        self.scrollView.contentSize = CGSize(width: contentW, height: 0);
        //        self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0)
        //页控件属性
        pageControl.backgroundColor = UIColor.clear
        pageControl.numberOfPages = ImageList.count   //所有页数
        pageControl.currentPage = 0     //默认当前第一页
        //        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        //        pageControl.currentPageIndicatorTintColor = UIColor.redColor()
        
        self.view.addSubview(scrollView)
        self.view.addSubview(pageControl)
        if(isJumpBtn==true){
        self.view.addSubview(jump)
        }
    }
    
    
    //UIScrollViewDelegate方法，每次滚动结束后调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //通过scrollView内容的偏移计算当前显示的是第几页
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //设置pageController的当前页
        pageControl.currentPage = page
        self.page=page
        //手动控制图片滚动应该取消那个三秒的计时器
        if(timer != nil){
            timer.fireDate = Date(timeIntervalSinceNow: 2)
        }
    }
    //点击回调
    func  JumpBtnEvent(){
        if(myCallbackJumpValue != nil){ //点击回调
            myCallbackJumpValue!(UIImage(named:ImageList[page] )! )
        }
    }
    
    //点击页控件时事件处理
    func ImagepageChanged(_ sender:UITapGestureRecognizer) {
        //根据点击的页数，计算scrollView需要显示的偏移量
        if(myCallbackValue != nil){ //点击回调
            if(Int(sender.ExpTagString)==ImageList.count-1) {
                myCallbackValue!(Int(sender.ExpTagString)!,true)
            }else{
                myCallbackValue!(Int(sender.ExpTagString)!,false)
            }
        }
    }
    
    var page:Int = 0;
    func NextPage(_ sender:AnyObject!){//图片轮播；
        
        if(page == ImageList.count-1){   //循环；
            page = 0;
        }
        else{
            page += 1;
        }
        pageControl.currentPage = page
        let x:CGFloat = CGFloat(page) * self.scrollView.frame.size.width;
        if(page==0){    //如果是最后一张图片了 准备轮播到进入到第一张图片  直接跳转
            self.scrollView.contentOffset = CGPoint(x: x,y: 0)
        }
        else{
            //动画方式跳转
            self.scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
