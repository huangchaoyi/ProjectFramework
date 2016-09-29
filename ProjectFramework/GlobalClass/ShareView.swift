//

//  ShareViewController.swift

//  ProjectFramework

//

//  Created by 购友住朋 on 16/6/29.

//  Copyright © 2016年 HCY. All rights reserved.

//



import UIKit



// ,UMSocialControllerService

class ShareView: UIView,UMSocialUIDelegate {
    
    // MARK: - 友盟分享
    /**
     友盟分享 带图片标题 参数都是必填的 不可为空 否则个别平台无法分享
     - parameter delegate: 当前分享的uicontroller  一般就是self
     - parameter ShareText:  分享内容
     - parameter ShareImage: 分享图片    (不可为空，否则部分平台无法分享
     - parameter title:      分享标题   (不可为空，否则部分平台无法分享
     - parameter url:        分享点击图片的Url (不可为空，否则部分平台无法分享
     */
    
    func ShareUM(_ delegate:UIViewController,ShareText:String,ShareImage:UIImage,title:String,url:String){
        
        //标题分享
        UMSocialData.default().extConfig.qqData.title=title  //QQ
        UMSocialData.default().extConfig.qzoneData.title=title  //QQ空间
        UMSocialData.default().extConfig.wechatSessionData.title=title  //微信好友
        UMSocialData.default().extConfig.wechatTimelineData.title=title  //微信朋友圈
        UMSocialData.default().extConfig.wechatFavoriteData.title=title  //微信收藏
        UMSocialData.default().extConfig.sinaData.shareText=title //新浪
        //点击分享内容的url
        UMSocialData.default().extConfig.qqData.url=url  //QQ
        UMSocialData.default().extConfig.qzoneData.url=url  //QQ空间
        UMSocialData.default().extConfig.wechatSessionData.url=url  //微信好友
        UMSocialData.default().extConfig.wechatTimelineData.url=url  //微信朋友圈
        UMSocialData.default().extConfig.wechatFavoriteData.url=url  //微信收藏
        UMSocialData.default().extConfig.sinaData.urlResource.url=url //新浪
        
        //目前分享的平台有以上列出的平台
        
        UMSocialSnsService.presentSnsIconSheetView(delegate, appKey: UMAPPKey, shareText: ShareText, shareImage: ShareImage , shareToSnsNames:[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToSina], delegate: self)
    }
    
    /**
     友盟分享 （分享文字 如：我是测试的 wwww.test.com
     - parameter delegate: 当前分享的uicontroller  一般就是self
     - parameter ShareText:  分享的文字
     */
    
    func ShareUM(_ delegate:UIViewController, ShareText:String ){
        
        UMSocialSnsService.presentSnsIconSheetView(delegate, appKey: UMAPPKey, shareText: ShareText, shareImage:nil , shareToSnsNames:[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToSina], delegate: self)
    }
    
    func didSelectSocialPlatform(_ platformName: String!, with socialData: UMSocialData!) {
        if(platformName == UMShareToQzone){    //因为QQ空间有些参数是必须要的，否则无法分享
            if( socialData.extConfig.qzoneData.shareImage==nil){    //判断QQ空间是否是有图片的
                //如果没有图片,默认一张图片
                socialData.extConfig.qzoneData.shareImage=UIImage(named: "GlobalClassSettings.bundle/QQzone.png")
            }
        }
        
    }
    
    //关闭页面的时候
    
    func didCloseUIViewController(_ fromViewControllerType: UMSViewControllerType) {
        
        print(fromViewControllerType)
        
    }
    
    //分享完成的时候
    
    func didFinishGetUMSocialData(inViewController response: UMSocialResponseEntity!) {
        
        if(response.responseCode == UMSResponseCodeSuccess){    //分享成功
            let alertView=UIAlertView(title: "消息", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
            alertView.show()
        }
    }
    
}

