//
//  LoginLogic.swift
//  ProjectFramework
//
//  Created by hcy on 16/7/8.
//  Copyright © 2016年 HCY. All rights reserved.
//

import Foundation

class LoginLogicViewModel {
    
    func LoginLogicViewModel(_ vc:UIViewController){
        
        let loginvc =  CommonFunction.ViewControllerWithStoryboardName("SB_Login", Identifier: "SB_Login") as! LoginViewController
        /*---登录----*/
        loginvc.Callback_loginInValue { (phone, password) in
            //操作登录逻辑
            debugPrint("用户登录")
            //如果登录成功 可以退出该页面了
            vc.dismiss(animated: true, completion: nil)
        }
        /*---用户注册----*/
        loginvc.Callback_RegisterVerificationCodeValue  {
            debugPrint("用户注册验证码")
        }
        loginvc.Callback_RegisterSubmitValue {  (phone, password, againpassword, VerificationCode) in
            debugPrint("用户注册提交")
            vc.dismiss(animated: true, completion: nil)
        }
        
        /*---忘记密码----*/
        loginvc.Callback_ForgetpasswordVerificationCodeValue {
            debugPrint("用户注册验证码")
        }
        loginvc.Callback_ForgetpasswordSubmitValue {  (phone, password, againpassword, VerificationCode) in
            debugPrint("用户忘记密码提交")
        }
        
        //present类型 (用户登录)
        vc.present(loginvc, animated: true, completion: nil)
        
    }
}
