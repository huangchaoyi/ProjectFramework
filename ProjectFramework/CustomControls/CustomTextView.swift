//
//  CustomTextView.swift
//  ProjectFramework
//
//  Created by hcy on 16/6/12.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

///自定义textview
class CustomTextView: UIView,UITextViewDelegate{
    
    fileprivate var placeholder:NSString=""
    
    fileprivate var maxlength:NSInteger=0
    
    fileprivate let labplaceholder=UILabel()
    fileprivate let numwords=UILabel()
    
    var textview:UITextView?
    
    var cornerRadius:CGFloat=5  ///圆角
    var borderWidth:CGFloat=1.0 ///边框
    var borderColor:CGColor=UIColor.groupTableViewBackground.cgColor ///颜色
    
    
    fileprivate  func load(){
        
        //创建一个view
        let background=UIView(frame: CGRect(x: 0,y: 0,width: self.frame.width,height: self.frame.height))
        self.layer.cornerRadius=cornerRadius
        self.layer.borderWidth=borderWidth    //边框
        self.layer.borderColor=borderColor    //颜色
        self.addSubview(background) //添加
        let numwordsheight:CGFloat=12   //统计数字的高度
        textview=UITextView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height-numwordsheight))
        textview!.delegate=self
        textview!.font=UIFont.systemFont(ofSize: 14)
        textview!.textColor=UIColor.darkGray
        textview!.returnKeyType = .done
        background.addSubview(textview!)
        
        //placeholder
        labplaceholder.frame=CGRect(x: 5,y: 5,width: self.frame.width,height: 20)
        labplaceholder.textColor=UIColor.lightGray
        labplaceholder.font=UIFont.systemFont(ofSize: 13)
        self.addSubview(labplaceholder)
        
        //数字
        numwords.frame=CGRect(x: 0,y: textview!.frame.maxY,width: self.frame.width-5,height: numwordsheight)
        numwords.textAlignment = .right
        numwords.font=UIFont.systemFont(ofSize: 10)
        numwords.textColor=UIColor.gray
        background.addSubview(numwords)
    }
    
    
    //用代码创建的时候会进入这个init函数体
    override init(frame: CGRect) {
        super.init(frame: frame )
        load()
        
    }
    
    //用Storyboard/xib继承这个类的时候会进入这个init函数体
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load()
    }
    
    ///设置最大长度
    func SetMaxLength(_ maxlength:NSInteger){
        self.maxlength=maxlength
        numwords.text = "0/\(Int(maxlength))"
        
        
    }
    ///设置Placeholder
    func SetPlaceholder(_ placeholder:NSString){
        self.placeholder=placeholder
        self.labplaceholder.text = self.placeholder as String;
    }
    
    func textViewDidChange(_ textView: UITextView) {
        numwords.text = "\(Int(textView.text.characters.count))/\(Int(maxlength))"
        labplaceholder.isHidden = (textView.text.characters.count > 0);
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text=="\n"){
            CustomTextResignFirstResponder()
            return false
        }
        let length = textView.text.characters.count - range.length + text.characters.count;
        return length <= self.maxlength;
    }
    //隐藏键盘
    func  CustomTextResignFirstResponder (){
        textview?.resignFirstResponder()
    }
    
}
