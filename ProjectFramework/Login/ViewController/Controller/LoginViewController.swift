//
//  LoginViewController.swift
//  ProjectFramework
//
//  Created by hcy on 16/5/25.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController,UITextFieldDelegate  {
    
    //登录逻辑回调
    typealias CallbackloginInValue=(_ phone:String,_ password:String)->Void
    var  loginInCallbackValue:CallbackloginInValue?  //声明一个闭包
    func  Callback_loginInValue(_ value:CallbackloginInValue?){
        loginInCallbackValue = value //返回值
    }
    
    //注册逻辑( 获取验证码回调事件 )
    typealias CallbackRegisterVerificationCodeValue=()->Void
    var  RegisterVerificationCodeCallbackValue:CallbackRegisterVerificationCodeValue?  //声明一个闭包
    func  Callback_RegisterVerificationCodeValue(_ value:CallbackRegisterVerificationCodeValue?){
        RegisterVerificationCodeCallbackValue = value //返回值
    }
    
    //注册逻辑( 提交回调事件 )
    typealias CallbackRegisterSubmitValue=(_ phone:String,_ password:String,_ againpassword:String,_ VerificationCode:String)->Void
    var  RegisterSubmitCallbackValue:CallbackRegisterSubmitValue?  //声明一个闭包
    func  Callback_RegisterSubmitValue(_ value:CallbackRegisterSubmitValue?){
        RegisterSubmitCallbackValue = value //返回值
    }
    
    //忘记密码逻辑( 获取验证码回调事件 )
    typealias CallbackForgetpasswordVerificationCodeValue=()->Void
    var  ForgetpasswordVerificationCodeCallbackValue:CallbackForgetpasswordVerificationCodeValue?  //声明一个闭包
    func  Callback_ForgetpasswordVerificationCodeValue(_ value:CallbackForgetpasswordVerificationCodeValue?){
        ForgetpasswordVerificationCodeCallbackValue = value //返回值
    }
    
    //忘记密码逻辑( 提交回调事件 )
    typealias CallbackForgetpasswordSubmitValue=(_ phone:String,_ password:String,_ againpassword:String,_ VerificationCode:String)->Void
    var  ForgetpasswordSubmitCallbackValue:CallbackForgetpasswordSubmitValue?  //声明一个闭包
    func  Callback_ForgetpasswordSubmitValue(_ value:CallbackForgetpasswordSubmitValue?){
        ForgetpasswordSubmitCallbackValue = value //返回值
    }

    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var loginin: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var topview: UIView!
    
    @IBOutlet weak var region: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img.image=UIImage(named: "LoginSettings.bundle/Line.png")
        loginin.layer.cornerRadius=0
        loginin.layer.masksToBounds=true
        password.delegate=self
        phone.delegate=self
        let tapGRs = UITapGestureRecognizer(target: self, action:#selector(LoginViewController.tapHandlermoreKey(_:)))    //点击手势
        tapGRs.numberOfTapsRequired = 1  //点击一次触发
        self.view.addGestureRecognizer(tapGRs)  //添加手势点击操作
        
    }
    
    //编码区域
    @IBAction func region(_ sender: AnyObject) {
        
        let vc  = CommonFunction.ViewControllerWithStoryboardName("SB_Region", Identifier: "SB_Region") as! RegionViewController
        vc.funcCallbackValue { (value) -> Void in   //闭包回调
            self.region.tag=value   //区域编码存储到tag里去
            self.region.titleLabel?.text="+"+value.description  //显示
            
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    //注册
    @IBAction func register(_ sender: AnyObject) {
        let vc =  CommonFunction.ViewControllerWithStoryboardName("SB_Register", Identifier: "SB_Register") as! RegisterViewController
        //验证码
        vc.Callback_VerificationCodeValue { 
            if(self.RegisterVerificationCodeCallbackValue != nil ){
                self.RegisterVerificationCodeCallbackValue!()
            }
        }
        //提交回调
        vc.Callback_SubmitValue { (phone, password, againpassword, VerificationCode) in
            if(self.RegisterSubmitCallbackValue != nil ){
                self.RegisterSubmitCallbackValue!(phone, password, againpassword, VerificationCode)
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    //忘记密码
    @IBAction func forget_password(_ sender: AnyObject) {
        let vc =  CommonFunction.ViewControllerWithStoryboardName("SB_forget+password", Identifier: "SB_Forget_password") as! Forget_passwordViewController
        //验证码
        vc.Callback_VerificationCodeValue {
            if(self.ForgetpasswordVerificationCodeCallbackValue != nil ){
                self.ForgetpasswordVerificationCodeCallbackValue!()
            }
        }
        //提交回调
        vc.Callback_SubmitValue { (phone, password, againpassword, VerificationCode) in
            if(self.ForgetpasswordSubmitCallbackValue != nil ){
                self.ForgetpasswordSubmitCallbackValue!(phone, password, againpassword, VerificationCode)
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    //请求登录
    @IBAction func loginIn(_ sender: AnyObject) { 
        if(phone.text == ""){
            CommonFunction.HUD("请输入手机号码", type: .error)
            return
        }
        if(password.text == "" ){
            
            CommonFunction.HUD("请输入密码", type: .error)
            return
        }
        if (loginInCallbackValue != nil){
            hidekeyboard()
            loginInCallbackValue!(phone.text!,password.text!) //回调。
        }
    }
    
    //取消
    @IBAction func cancel(_ sender: AnyObject) {
        dismissViewControllerAnimated(true)
    }
    
    ///关闭当前登录的ViewController
    func dismissViewControllerAnimated(_ flag: Bool){
        self.dismiss(animated: flag, completion: nil)
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
        password.resignFirstResponder() //隐藏当前键盘
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated) 
    }
    
}
