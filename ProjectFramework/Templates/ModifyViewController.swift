//
//  ModifyViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/18.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

class ModifyViewController: UIViewController {
    
    typealias CallbackSaveValue=(_ value:String)->Void
    //声明一个闭包
    fileprivate var myCallbackValue:CallbackSaveValue?  //保存后的必包数据
    fileprivate var DataSource=""       //数据源
    
    fileprivate var customTextView:CustomTextView?                  //textview
    
    /**
     
     
     - parameter DataSource:      数据源（原始数据
     - parameter myCallbackValue: 保存后的数据
     
     - returns:
     */
    init (DataSource:String,myCallbackValue:@escaping CallbackSaveValue){
        super.init(nibName: nil, bundle: nil)
        self.myCallbackValue=myCallbackValue
        self.DataSource=DataSource
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets=false
        self.title="修改信息"
        self.view.backgroundColor=UIColor.white
        //自定义textview
        customTextView = CustomTextView(frame: CGRect(x: 10, y: 70, width: self.view.frame.width-20,height: 150))
        customTextView!.SetMaxLength(100)
        self.view.addSubview(customTextView!)
        if(self.DataSource==""){
            customTextView!.SetPlaceholder("请输入信息")
        }
        customTextView!.textview?.text=DataSource
        
        //保存按钮
        let save = UIButton(frame: CGRect(x: 10, y: customTextView!.frame.maxY+10, width: self.view.frame.width-20,height: 30))
        save.setTitle("保存", for: UIControlState())
        save.setTitleColor(UIColor.white, for: UIControlState())
        save.backgroundColor=CommonFunction.RGBA(55, g: 184, b: 249)
        save.titleLabel?.font=UIFont.systemFont(ofSize: 14)
        save.addTarget(self, action: #selector(ModifyViewController.save), for: UIControlEvents.touchUpInside)
        self.view.addSubview(save)
        
        let tapGRs = UITapGestureRecognizer(target: self, action:#selector(ModifyViewController.tapHandlermoreKey))    //点击手势
        tapGRs.numberOfTapsRequired = 1  //点击一次触发
        self.view.addGestureRecognizer(tapGRs)  //添加手势点击操作
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //保存
    func save(){
        hidekeyboard()
        if myCallbackValue != nil {
            myCallbackValue!((customTextView?.textview?.text)!)
            _=navigationController?.popViewController( animated: true)
        }
    }
    
    //点击当前view隐藏键盘
    func tapHandlermoreKey( ) {
        hidekeyboard()
    }
    
    //隐藏当前弹出的键盘
    func hidekeyboard(){
        customTextView?.CustomTextResignFirstResponder()
    }
    
}
