//
//  CalendarViewController.swift
//  CityParty
//
//  Created by hcy on 15/12/7.
//  Copyright © 2015年 hcy. All rights reserved.
//

import UIKit

///日期
class CalendarViewController: UIViewController {
    
    fileprivate  var CalendarView=UIView()   //日历view
    fileprivate  var TopView=UIView()        //头顶view
    fileprivate var MainView=UIView()       //中间view
    fileprivate var BottomView=UIView()     //底部view
    
    fileprivate var btnleft=UIButton()      //上一月
    fileprivate  var btnriright=UIButton()   //下一月
    fileprivate  var btnyyyymmdd=UIButton()  //年月日
    
    fileprivate var btnSelected=UIButton()  //选中
    fileprivate  var btnCancel=UIButton()    //取消
    
    fileprivate  var nowDate: Date = Date()  //当前日期
    fileprivate  var getOneweek=0    //获取到年月的1号是周几
    fileprivate  var daycount=0        //获取到年月的总天数
    
    /// 是否可以多选
    var IsSelecetdMultiple=true
    
    //类似于OC中的typedef
    typealias CallbackSelectedValue=(_ value:[String])->Void
    
    //声明一个闭包
    var myCallbackValue:CallbackSelectedValue?
    //下面这个方法需要传入上个界面的函数指针
    func  Callback_SelectedValue(_ value:CallbackSelectedValue?){
        //将函数指针赋值给闭
        myCallbackValue = value
    }
    
    /**
     初始化 参数1 是否多选 参数2 返回选取值,返回对象[String]
     
     - parameter IsSelecetdMultiple:     是否多选 true多选  false 单选
     - parameter Callback_SelectedValue: 回调选取值 返回对象 [String]
     
     - returns:  
     */
    init (IsSelecetdMultiple:Bool,Callback_SelectedValue:@escaping CallbackSelectedValue){
        super.init(nibName: nil, bundle: nil)
        self.myCallbackValue=Callback_SelectedValue
        self.IsSelecetdMultiple=IsSelecetdMultiple
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha:0.5)  //背景色
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .custom  //半透明
        
        CalendarView.frame=CGRect(x: 20, y: 100, width: self.view.frame.width-40, height: self.view.frame.height/2+50)
        CalendarView.backgroundColor=UIColor.white
        
        TopView.frame=CGRect(x:0, y: 0, width: CalendarView.frame.width, height: 70)
        TopView.backgroundColor=UIColor.white
        CalendarView.addSubview(TopView)
        
        MainView.frame=CGRect(x:0, y: 70, width: CalendarView.frame.width, height: CalendarView.frame.height-110)
        MainView.backgroundColor=UIColor.white
        CalendarView.addSubview(MainView)
        
        
        BottomView.frame=CGRect(x:0, y: CalendarView.frame.height-39.9, width: CalendarView.frame.width, height: 40)
        BottomView.backgroundColor=UIColor.white
        CalendarView.addSubview(BottomView)
        
        self.view.addSubview(CalendarView)
        //初始化日期
        initLoadDate()
        //添加头部试图信息
        AddTop()
        //添加日历内容
        AddMain()
        //加载底部选取部分
        AddBottomView()
    }
    
    func initLoadDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //得到年月的1号
        let date = dateFormatter.date(from: "\(nowDate.currentYear)-\(nowDate.currentMonth)-01 23:59:59")
        getOneweek = date!.toMonthOneDayWeek(date!)
        
        daycount = date!.TotaldaysInThisMonth(date!)
        
        
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(CalendarViewController._handleSwipeGesture(_:)))
        swipeGestureRight.direction = UISwipeGestureRecognizerDirection.right //滑动的样式
        self.CalendarView.addGestureRecognizer(swipeGestureRight)
        
        let swipeGestureleft = UISwipeGestureRecognizer(target: self, action: #selector(CalendarViewController._handleSwipeGesture(_:)))
        swipeGestureleft.direction = UISwipeGestureRecognizerDirection.left //滑动的样式
        self.CalendarView.addGestureRecognizer(swipeGestureleft)
        
    }
    
    
    func AddTop(){
        
        let  _width = (TopView.frame.width*(1+1)-TopView.frame.width) / CGFloat(7) //整个TopView宽度的100% / 7
        for i:Int in 0  ..< 7 {
            let lb  = UILabel(frame: CGRect(x: CGFloat(i)*_width, y: TopView.frame.height-30, width: _width, height: 30))
            lb.textColor=UIColor.black
            var str=""
            switch(i){
            case 0: str="日";lb.textColor=UIColor.red;break
            case 1: str="一";break
            case 2: str="二";break
            case 3: str="三";break
            case 4: str="四";break
            case 5: str="五";break
            case 6: str="六";lb.textColor=UIColor.red;break
            default:
                break
            }
            
            lb.text=str
            lb.font=UIFont.systemFont(ofSize: 13)
            lb.textAlignment = .center
            
            TopView.addSubview(lb)
        }
        let  _width1 = (TopView.frame.width*(1+1)-TopView.frame.width) / CGFloat(3) //整个TopView宽度的100% / 3
        for  i:Int in 0  ..< 3  {
            
            var str=""
            switch(i){
            case 0: str="◀"
            btnleft.frame=CGRect(x: CGFloat(i)*_width1, y: TopView.frame.height-60, width: _width1, height: 30)
            btnleft.titleLabel?.font=UIFont.systemFont(ofSize: 20)
            btnleft.setTitleColor(UIColor.blue, for: UIControlState())
            btnleft.setTitle(str, for: UIControlState())
            TopView.addSubview(btnleft)
                break
            case 1: str="nyyyymmdd"
            btnyyyymmdd.frame=CGRect(x: CGFloat(i)*_width1, y: TopView.frame.height-60, width: _width1, height: 30)
            btnyyyymmdd.titleLabel?.font=UIFont.boldSystemFont(ofSize: 15)
            btnyyyymmdd.setTitleColor(UIColor(red: 50/255, green: 205/255, blue: 50/255, alpha: 1), for: UIControlState())
            TopView.addSubview(btnyyyymmdd)
                break
            case 2: str="▶"
            btnriright.frame=CGRect(x: CGFloat(i)*_width1, y: TopView.frame.height-60, width: _width1, height: 30)
            btnriright.titleLabel?.font=UIFont.systemFont(ofSize: 20)
            btnriright.setTitleColor(UIColor.blue, for: UIControlState())
            btnriright.setTitle(str, for: UIControlState())
            
            TopView.addSubview(btnriright)
                break
            default:
                break
            }
            
        }
        btnleft.addTarget(self, action: #selector(CalendarViewController.btnleft_Click), for: .touchUpInside)
        btnriright.addTarget(self, action: #selector(CalendarViewController.btnriright_Click), for: .touchUpInside)
        btnyyyymmdd.addTarget(self, action: #selector(CalendarViewController.btnyyyymmdd_Click), for: .touchUpInside)
    }
    
    
    func AddMain(){
        
        btnyyyymmdd.setTitle("\(nowDate.currentYear)年\(nowDate.currentMonth)月", for: UIControlState()) //更改年月
        
        for sub in MainView.subviews{   //如果存在子项先清空当前子项的内容
            sub.removeFromSuperview()
        }
        let toYear=Date().currentYear //当前日期的年
        let toMonth=Date().currentMonth   //当前月
        let today=Date().currentDay       //当前日
        let  _width = (MainView.frame.width*(1+1)-MainView.frame.width) / CGFloat(7) //整个MainView宽度的100% / 7
        let _heigth=MainView.frame.height/6
        var indexday=0  //第0位开始
        for index in  0...5 {
            for  i:Int in 0  ..< 7  {
                let btn  = UIButton(frame: CGRect(x: CGFloat(i)*_width, y: CGFloat(index)*_heigth, width: _width, height: _heigth ))
                btn.titleLabel?.font=UIFont.systemFont(ofSize: 13)
                btn.setTitleColor(UIColor.black, for: UIControlState())
                btn.tag=indexday
                btn.layer.cornerRadius=0
                btn.layer.borderColor=UIColor(red: 51/255, green: 161/255, blue: 202/255, alpha: 1).cgColor
                btn.layer.borderWidth=0.3
                btn.addTarget(self, action: #selector(CalendarViewController.selectedCheck(_:)), for: .touchUpInside)
                //创建一个点击的时候有勾选的lable
                let check_lb  = UILabel(frame:CGRect( x: btn.frame.width-10,y: 0,width: 10,height: 10))
                check_lb.textColor=UIColor.blue
                check_lb.font=UIFont.boldSystemFont(ofSize: 10)
                btn.addSubview(check_lb)
                if(indexday==today+1){  //因为是第0开始的  索引天数后面需要+1
                    if(toYear==nowDate.currentYear&&toMonth==nowDate.currentMonth){ //判断是否是今年今月
                        
                    btn.titleLabel?.font=UIFont.boldSystemFont(ofSize: 15)
                        btn.setTitleColor(UIColor(red: 227/255, green:23/255, blue: 13/255, alpha: 1), for: UIControlState())
                    }
                }
                MainView.addSubview(btn)
                indexday += 1
            }
        }
        indexday=1
        for sub in MainView.subviews{
            let btn =  sub as!  UIButton
            if(btn.tag==getOneweek){
                btn.setTitle(indexday.description, for: UIControlState())
                indexday += 1
                continue
            }
            if(indexday>1){
                if(indexday<=daycount){ //当前的天数如果小于等于当总天数
                    btn.setTitle(indexday.description, for: UIControlState())
                    indexday += 1
                }
            }
            
        }
    }
    
    
    func AddBottomView (){
        let  _width1 = (BottomView.frame.width*(1+1)-BottomView.frame.width) / CGFloat(2) //整个BottomView宽度的100% / 2
        for  i:Int in 0  ..< 2 {
            switch(i){
            case 0:
                btnSelected.frame=CGRect(x: CGFloat(i)*_width1, y: 10, width: _width1, height: 20)
                btnSelected.titleLabel?.font=UIFont.systemFont(ofSize: 15)
                btnSelected.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1), for: UIControlState())
                btnSelected.setTitle("选取", for: UIControlState())
                BottomView.addSubview(btnSelected)
                break
            case 1:
                btnCancel.frame=CGRect(x: CGFloat(i)*_width1, y: 10, width: _width1, height: 20)
                btnCancel.titleLabel?.font=UIFont.systemFont(ofSize: 15)
                btnCancel.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1), for: UIControlState())
                btnCancel.setTitle("取消", for: UIControlState())
                
                BottomView.addSubview(btnCancel)
                break
                
            default:
                break
            }
        }
        btnSelected.addTarget(self, action: #selector(CalendarViewController.selected), for: UIControlEvents.touchUpInside)
        btnCancel.addTarget(self, action: #selector(CalendarViewController.cancel), for: UIControlEvents.touchUpInside)
    }
    
    
    
    func btnleft_Click(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var date = Date()
        //得到年月的1号
        if((nowDate.currentMonth-1)==0){
            let str:String="\(nowDate.currentYear-1)-\(12)-01 23:59:59"
            date = dateFormatter.date(from: str)!
        }
        else{
            let str:String="\(nowDate.currentYear)-\(nowDate.currentMonth-1)-01 23:59:59"
            date = dateFormatter.date(from: str)!
        }
        nowDate=date    //更新当前的年月
        getOneweek = date.toMonthOneDayWeek(date)   //更新当前年月周
        daycount = date.TotaldaysInThisMonth(date)  //更新当前年月天数
        MoveAnimation(CalendarView ,Type: UIViewAnimationTransition.curlUp)
        AddMain()
    }
    
    func btnriright_Click(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var date = Date()
        //得到年月的1号
        if((nowDate.currentMonth+1)==13){
            date = dateFormatter.date(from: "\(nowDate.currentYear+1)-\(01)-01 23:59:59")!
        }
        else{
            date = dateFormatter.date(from: "\(nowDate.currentYear)-\(nowDate.currentMonth+1)-01 23:59:59")!
        }
        nowDate=date    //更新当前的年月
        getOneweek = date.toMonthOneDayWeek(date)    //更新当前年月周
        daycount = date.TotaldaysInThisMonth(date)   //更新当前年月天数
        MoveAnimation(CalendarView ,Type: UIViewAnimationTransition.curlDown)
        AddMain()
    }
    
    func btnyyyymmdd_Click(){
        
    }
    
    func selected(){
        var value=[String]()
        for sub in MainView.subviews{
            let btn =  sub as!  UIButton
            if(btn.titleLabel?.text != nil){
                for sub in btn.subviews{
                    
                    let check_lb =  sub  as!  UILabel
                    if(check_lb.text=="√"){ 
                        let str=nowDate.currentYear.description+"-"+nowDate.currentMonth.description+"-"+(btn.titleLabel?.text)!
                        value.append(str)
                    }
                    
                }
                
            }
        }
        if(myCallbackValue != nil){
            myCallbackValue!(value)
            cancel()
        }
    }
    
    func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var ischeck=false   //是否已经选择过
    //点击处理
    func selectedCheck(_ sender:UIButton) {
        let btn =  sender
        if(btn.titleLabel?.text != nil){
            var isbtnlabel=false
            for sub in btn.subviews{
                if(isbtnlabel==false){    //先判断是否是uibtton自带的uilable
                    isbtnlabel=true
                    continue
                }else{
                   
                let check_lb =  sub  as!  UILabel
                 
                if(check_lb.text=="√"){
                    check_lb.text=""
                    ischeck=false
                }else{
                    
                    if(IsSelecetdMultiple==false&&ischeck==true){
                        return
                    }
                    check_lb.text="√"
                    ischeck=true
                    }
                }
                
            }
            
        }
        
    }
    
    
    func MoveAnimation (_ view:UIView ,Type: UIViewAnimationTransition){
        //开始动画
        UIView.beginAnimations("",context: nil)
        //动画时长
        UIView.setAnimationDuration(0.7)
        // FlipFromRight
        // CurlUp
        //动画样式
        UIView.setAnimationTransition(Type,
            for :  view,
            cache:true)
        
        //更改view顺序
        view.exchangeSubview(at: 0,withSubviewAt :1)
        //提交动画
        UIView.commitAnimations()
    }
    
    
    //划动手势
    func _handleSwipeGesture(_ sender: UISwipeGestureRecognizer){
        //划动的方向
        let direction = sender.direction
        //判断是上下左右
        switch (direction){
        case UISwipeGestureRecognizerDirection.right:   //右
            btnriright_Click()
            break
        case UISwipeGestureRecognizerDirection.left:   //左
            btnleft_Click()
            break
        default:
            break;
        }
    }
    
    //即将出现
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

