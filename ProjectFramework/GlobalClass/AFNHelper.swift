//
//  AFNHelper.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/9/21.
//  Copyright © 2016年 HCY. All rights reserved.
//


import UIKit
import AFNetworking
import SwiftyJSON

class AFNHelper: AFHTTPSessionManager {
    
    /// 单利
    static let shareManager:AFNHelper = {
        let baseurl = URL(string: "")//后台URL
        let manager = AFNHelper(baseURL: baseurl, sessionConfiguration: URLSessionConfiguration.default)
        
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain", "text/html") as? Set<String>
        
        return manager
    }()
    
    
    /**
     get请求   (AFNHeleper.get(.....
     
     - parameter vc:            self 可以为nil
     - parameter urlString:     请求的url
     - parameter parameters:    请求的参数
     - parameter isHUD:         请求圈圈HUD 默认false
     - parameter isHUDMake:     请求圈圈HUD 增加蒙版？ 默认false
     - parameter success:       请求成功回调
     - parameter failure:       请求失败回调
     */
    class func get(_ vc:UIViewController?,urlString:String,parameters:NSDictionary?,isHUD:Bool=false,isHUDMake:Bool=false,success:((_ json:JSON?) -> Void)?,failure:((_ error:NSError) -> Void)?) -> Void {
        if(vc != nil ){    //nav进度条  vc.CustomNavProgress是拓展的进度函数
            vc!.performSelector(inBackground: #selector(vc!.CustomNavProgress), with: nil)
        }
        if(isHUD==true){ CommonFunction.HUD("数据加载中...", type: MsgType.load,ismask: isHUDMake)}  //HUD
        
        AFNHelper.shareManager.get(urlString, parameters: parameters, progress: { (progress) in
            
            }, success: { (task, responseObject) in
                
                //如果responseObject不为空时
                if responseObject != nil {
                    success?(JSON( responseObject))
                }
                else{
                     success?(nil)
                }
                
                if(isHUD==true){
                    CommonFunction.HUDHide()
                }    //隐藏HUD
                if(vc != nil ){   //如果用nav进度条 则用KVO通知已经收到消息了。
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "CustomNavProgress"), object: nil)
                }
                
        }) { (task, error) in
            failure!(error as NSError)
            if(isHUD==true){ CommonFunction.HUDHide()}    //隐藏HUD
            if(vc != nil ){   //如果用nav进度条 则用KVO通知已经收到消息了。
                NotificationCenter.default.post(name: Notification.Name(rawValue: "CustomNavProgress"), object: nil)
            }
        }
        
        
    }
    
    
    /**
     post请求   (AFNHeleper.get(.....
     
     - parameter vc:            self 可以为nil
     - parameter urlString:     请求的url
     - parameter parameters:    请求的参数
     - parameter isHUD:         请求圈圈HUD 默认false
     - parameter isHUDMake:     请求圈圈HUD 增加蒙版？ 默认false
     - parameter success:       请求成功回调
     - parameter failure:       请求失败回调
     */
    class func post(_ vc:UIViewController?,urlString:String,parameters:NSDictionary?,isHUD:Bool=false,isHUDMake:Bool=false,success:((_ json:JSON?) -> Void)?,failure:((_ error:NSError) -> Void)?) -> Void {
        
        if(vc != nil ){    //nav进度条  vc.CustomNavProgress是拓展的进度函数
            vc!.performSelector(inBackground: #selector(vc!.CustomNavProgress), with: nil)
        }
        
        if(isHUD==true){ CommonFunction.HUD("数据加载中...", type: MsgType.load,ismask: isHUDMake)}  //HUD
        
        AFNHelper.shareManager.post(urlString, parameters: parameters, progress: { (progress) in
            
            }, success: { (task, responseObject) in
                
                //如果responseObject不为空时
                if responseObject != nil {
                    success?(JSON(responseObject))
                }
                else{
                    success?(nil)
                }
                
                if(isHUD==true){
                    CommonFunction.HUDHide()
                }    //隐藏HUD
                if(vc != nil ){   //如果用nav进度条 则用KVO通知已经收到消息了。
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "CustomNavProgress"), object: nil)
                }
                
        }) { (task, error) in
            failure!(error as NSError)
            if(isHUD==true){ CommonFunction.HUDHide()}    //隐藏HUD
            if(vc != nil ){   //如果用nav进度条 则用KVO通知已经收到消息了。
                NotificationCenter.default.post(name: Notification.Name(rawValue: "CustomNavProgress"), object: nil)
            }
        }
        
    }
    
    /**
     文件上传  upload(.....  formData.appendPartWithFileData
     
     - parameter urlString:                 请求的url
     - parameter parameters:                请求的参数
     - parameter constructingBodyWithBlock: 文件data
     - parameter uploadProgress:            上传进度
     - parameter success:                   请求成功回调
     - parameter failure:                   请求失败回调
     */
    class func upload(_ urlString: String, parameters: NSDictionary?, constructingBodyWithBlock:((_ formData:AFMultipartFormData) -> Void)?, uploadProgress: ((_ progress:Progress) -> Void)?, success: ((_ responseObject:Bool?) -> Void)?, failure: ((_ error: NSError) -> Void)?) -> Void {
        
        
        AFNHelper.shareManager.post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            
            constructingBodyWithBlock!(formData)
            
            }, progress: { (progress) in
                
                uploadProgress!(progress)
                
            }, success: { (task, objc) in
                
                if objc != nil {
                    
                    success!(true)
                    
                }
        }) { (task, error) in
            
            failure!(error as NSError)
            //            failure!(error)
        }
        
        
    }
    
    /**
     下载文件
     
     - parameter request:               请求的request
     - parameter downloadProgressBlock: 下载的进度
     - parameter savePath:              存储路径
     - parameter completionHandler:     完成后回调
     */
    class func downloadTaskWithRequest(_ request: URLRequest, downloadProgressBlock: ((_ downloadProgress :Progress) -> Void)?, savePath: String,completionHandler:((_ response:URLResponse, _ error:NSError?) -> Void)?) -> Void{
        
        //创建下载任务
        let task  =  AFNHelper.shareManager.downloadTask(with: request, progress: { (progress) in
            
            downloadProgressBlock!(progress)
            
            }, destination: { (url, response) -> URL in
                
                
                return URL(fileURLWithPath: savePath)
        }) { (response, url, error) in
            
            if (error == nil) {
                
                completionHandler!(response ,error as NSError?)
                
            }
            
            
        }
        
        //开启下载
        task.resume()
    }
    
}
