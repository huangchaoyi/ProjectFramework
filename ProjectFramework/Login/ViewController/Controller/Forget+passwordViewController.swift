//
//  Forget+passwordViewController.swift
//  ProjectFramework
//
//  Created by hcy on 16/6/12.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

class Forget_passwordViewController: UITableViewController,UITextFieldDelegate {
   
    //获取验证码回调事件
    typealias CallbackVerificationCodeValue=()->Void
    var  VerificationCodeCallbackValue:CallbackVerificationCodeValue?  //声明一个闭包
    func  Callback_VerificationCodeValue(_ value:CallbackVerificationCodeValue?){
        VerificationCodeCallbackValue = value //返回值
    }
    
    //提交回调事件
    typealias CallbackSubmitValue=(_ phone:String,_ password:String,_ againpassword:String,_ VerificationCode:String)->Void
    var  SubmitCallbackValue:CallbackSubmitValue?  //声明一个闭包
    func  Callback_SubmitValue(_ value:CallbackSubmitValue?){
        SubmitCallbackValue = value //返回值
    }
    
    fileprivate  var timer:Timer!     //计时器（点击.验证码)
    /// 设置计时器的最大秒数
    fileprivate  var timerMaxInterval:Int=60
    
    @IBOutlet weak var password: UITextField!   //密码
    @IBOutlet weak var againpassword: UITextField!  //再次输入密码
    @IBOutlet weak var phone: UITextField!  //手机号
    
    @IBOutlet weak var VerifiacationCodeBtn: UIButton!  //验证码按钮
    @IBOutlet weak var VerificationCode: UITextField!   //验证码
    @IBOutlet weak var img: UIImageView!    //img
    @IBOutlet weak var submit: UIButton!    //提交
    
    @IBOutlet weak var region: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img.image=UIImage(named: "LoginSettings.bundle/Line.png")
        submit.layer.cornerRadius=0
        submit.layer.masksToBounds=true
        password.delegate=self
        againpassword.delegate=self
        phone.delegate=self
        VerificationCode.delegate=self
        let tapGRs = UITapGestureRecognizer(target: self, action:#selector(Forget_passwordViewController.tapHandlermoreKey(_:)))    //点击手势
        tapGRs.numberOfTapsRequired = 1  //点击一次触发
        self.view.addGestureRecognizer(tapGRs)  //添加手势点击操作
        
    }
    
    //取消(关闭
    @IBAction func Close(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //编码区域
    @IBAction func region(_ sender: AnyObject) {
        let vc  = CommonFunction.ViewControllerWithStoryboardName("SB_Region", Identifier: "SB_Region") as! RegionViewController
        vc.funcCallbackValue { (value) -> Void in   //闭包回调
            self.region.tag=value  //区域编码存储到tag里去
            self.region.titleLabel?.text="+"+value.description  //显示
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    //提交
    @IBAction func submit(_ sender: AnyObject) {
        if(phone.text == ""){
            CommonFunction.HUD("请输入手机号码", type: .error)
            return
        }
        if(password.text == "" ){
            
            CommonFunction.HUD("请输入密码", type: .error)
            return
        }
        if(againpassword.text == "" ){
            
            CommonFunction.HUD("请再次输入密码", type: .error)
            return
        }
        
        if(VerificationCode.text==""){
            CommonFunction.HUD("请输入验证码", type: .error)
            return
        }
        if(password.text != "" && againpassword.text != "" ){
            if(password.text != againpassword.text){
                CommonFunction.HUD("二次密码不相同", type: .error)
                return
            }
        }
        if(SubmitCallbackValue != nil ){
             hidekeyboard()
            SubmitCallbackValue!(phone.text!,password.text!,againpassword.text!,VerificationCode.text!)
        }
        
    }
    
    //获取验证码
    @IBAction func GetVerificationCode(_ sender: AnyObject) {
        if(phone.text == ""){
            CommonFunction.HUD("请输入手机号码", type: .error)
            return
        }
        if(VerificationCodeCallbackValue != nil ){
             hidekeyboard()
            VerificationCodeCallbackValue!()
        }
        //启动计时器
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.VerificationCodeTime), userInfo: nil, repeats: true)
        
    }
    
    fileprivate var IntervalInitialize=0    //计时器自增数
    //获取验证码计时器
    func VerificationCodeTime(){
        IntervalInitialize+=1
        VerifiacationCodeBtn.isEnabled=false  //使能 不可用 可点击
        VerifiacationCodeBtn.backgroundColor=UIColor.gray  //设置颜色
        VerifiacationCodeBtn.setTitle((timerMaxInterval-IntervalInitialize).description+" 秒", for: UIControlState())    //设置秒数
        
        if(IntervalInitialize>=timerMaxInterval){
            VerifiacationCodeBtn.isEnabled=true   //可用 可点击
            VerifiacationCodeBtn.backgroundColor=CommonFunction.RGBA(23, g: 170, b: 255) //设置颜色
            self.timer.invalidate() //停止计时器
            IntervalInitialize=0    //初始化
            VerifiacationCodeBtn.setTitle("获取验证码", for: UIControlState())
        }
    }
    
    //按下完成键盘按钮事件
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        hidekeyboard()
        return true;
    }
    
    //点击当前view隐藏键盘
    func tapHandlermoreKey(_ sender:UIGestureRecognizer) {
        hidekeyboard()
    }
    
    //隐藏当前弹出的键盘
    func hidekeyboard(){
        phone.resignFirstResponder() //隐藏当前键盘
        password.resignFirstResponder()
        againpassword.resignFirstResponder()
        VerificationCode.resignFirstResponder()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
