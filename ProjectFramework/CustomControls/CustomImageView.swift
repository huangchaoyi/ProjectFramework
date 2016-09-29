//
//  CustomImageView.swift
//  ProjectFramework
//
//  Created by 猪朋狗友 on 16/6/16.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

///自定义UIImageView 目前提供4个属性 customImageView（图片）、deletebtn(删除按钮)、progress（进度条)、imageUploadStatus(Bool 配合进度条使用的上传或者下载完成的标识符,当然可以用本身的tag来标识，看个人需求吧)
class CustomImageView: UIImageView {
     
    ///自定义图片
    var customImageView:UIImageView? 
    
    ///自定义删除按钮
    var deletebtn:UIButton?
     
    ///图片上传进度条
    var progress:UIProgressView?
    
    fileprivate var _imageUploadStatus = false
    //图片上传下载状态 true=完成
    var imageUploadStatus:Bool{
        
        get{
            let result = objc_getAssociatedObject(self, &_imageUploadStatus) as? Bool
            if result == nil {
                return false
            }
            
            return result!
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &_imageUploadStatus, newValue, objc_AssociationPolicy(rawValue: 3)!)
        }
    }

    
    fileprivate func  load(){
        
        if(customImageView==nil&&deletebtn==nil&&progress==nil){
            self.isUserInteractionEnabled=true
            let def:CGFloat=8  //默认的view高宽度多8个像素 (customImageView.frame.height=100-8=92)
            //创建一个view 覆盖当前的UIImageView
            let backview=UIView(frame: CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
            self.addSubview(backview) //添加
            //删除按钮
            deletebtn = UIButton(frame: CGRect(x: backview.frame.width-22,y: 0,width: 22,height: 22) )
//            deletebtn!.layer.cornerRadius=11    //圆圈
//            deletebtn!.backgroundColor = CommonFunction.RGBA(23, g: 170, b: 255)
//            deletebtn!.setTitle("X", forState: UIControlState.Normal)
            deletebtn!.setImage(UIImage(named: "CustomSettings.bundle/photo_delete.png"), for: UIControlState()) 
            deletebtn!.isHidden=true //默认是不显示删除按钮的
            //图片 图片默认xy/2 高宽-def 让图片居中
            customImageView = UIImageView(frame: CGRect(x: def/2, y: def/2, width: self.frame.size.width-def, height: self.frame.size.height-def)) //设置图片居中在view
           
            progress=UIProgressView(frame: CGRect(x: 0,y: (customImageView?.frame.maxY)!-7,width: (customImageView?.frame.size.width)!,height: 7))
            progress!.progressViewStyle = .default
            let transform = CGAffineTransform(scaleX: 1.0, y: 2.0);
            progress!.transform = transform;
            progress!.progressTintColor=UIColor.yellow  //进度颜色
            progress!.trackTintColor=UIColor.clear  //剩余进度颜色（即进度槽颜色）
            backview.addSubview(customImageView!) //view添加图片
            customImageView!.addSubview(progress!) //customImageView添加进度条
            backview.addSubview(deletebtn!)   //view添加删除按钮
            backview.bringSubview(toFront: deletebtn!)  //把删除按钮置顶在最上面
        }
    }
    
    //用代码创建的时候会进入这个init函数体
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        load()
    }
    
    //用Storyboard/xib继承这个类的时候会进入这个init函数体
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         load()
    }
}
