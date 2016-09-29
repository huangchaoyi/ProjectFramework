//
//  FeedbackViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/16.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController,UITextFieldDelegate  {

    @IBOutlet weak var feedbackInfo: UIView!            //反馈信息view
    @IBOutlet weak var contact: UITextField!            //联系方式
    var customTextView:CustomTextView?                  //反馈信息textview
 
    @IBOutlet weak var contactview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="意见反馈"
        //反馈信息
          customTextView = CustomTextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-30, height: 150))
        customTextView!.SetPlaceholder("请简单的描述下您遇到的问题和意见")
        customTextView!.SetMaxLength(500)
        self.feedbackInfo.addSubview(customTextView!)
        
        contact.delegate=self       //实现代理
        contact.returnKeyType = .done   //设置键盘类型为完成
        
        let tapGRs = UITapGestureRecognizer(target: self, action:#selector(FeedbackViewController.tapHandlermoreKey))    //点击手势
        tapGRs.numberOfTapsRequired = 1  //点击一次触发
        self.view.addGestureRecognizer(tapGRs)  //添加手势点击操作
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //提交
    @IBAction func Submit(_ sender: AnyObject) {
        //提交操作
        
        
    }
    
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //按完成的时候键盘移除
        if(string=="\n"){
            contact.resignFirstResponder()
            return false
        }
    
        return true

    }
    
    //点击当前view隐藏键盘
    func tapHandlermoreKey( ) {
        hidekeyboard()
    }
    
    //隐藏当前弹出的键盘
    func hidekeyboard(){
        contact.resignFirstResponder() //隐藏当前键盘 
        customTextView?.CustomTextResignFirstResponder()
    }
    
    
  

}
