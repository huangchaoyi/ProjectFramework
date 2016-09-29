//
//  AppDelegate.swift
//  ProjectFramework
//
//  Created by hcy on 16/4/4.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import FMDB
import IQKeyboardManager

let placeholderImage="loadimg" 
let UMAPPKey="5764a0dc67e58e90c20aasaaa02665"    //友盟Appkey
var NetWordStatus=false //网络状态  true连接网络，false未连接

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    
    let ImageList:[String] = [
        "tutorial_background_00",
        "tutorial_background_01",
        "tutorial_background_02",
        "tutorial_background_03"]       //第一次启动引导页图片
    
    var conn:Reachability?  //苹果提供的网络检测类
     
    
    // MARK: - 初始化
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        InitUI()    //初始化UI   (第一次启动的导航页，需要在里面设置)
        InitUMStatistics()    //友盟统计
        InitUMshare()         //友盟分享
        InitNetworkCheck()    //网络检测
        InitDB()              //初始化sqlite数据库
        return true
    }
     // MARK: - 析构方法
    //析构方法
    deinit{
        self.conn?.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 初始化UI
    func InitUI(){
        //状态栏的颜色 Default 表示黑色的 LightContent 白色
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true);
        self.window=UIWindow()
        self.window!.backgroundColor=UIColor.white   //设置windows是白色的 不然自定义push的时候右上角会有黑角快
        self.window!.frame=UIScreen.main.bounds
        IQKeyboardManager.shared().isEnabled = true
        //判断是否第一次启动：
        if((UserDefaults.standard.bool(forKey: "IsFirstLaunch") as Bool!) == false || (UserDefaults.standard.bool(forKey: "IsFirstLaunch") as Bool!)==nil ){
            //第一次启动，播放引导页面
            let vc = ScrollViewPageViewController(Enabletimer: false,   //是否启动滚动
                timerInterval: 3,     //如果启用滚动，滚动秒数
                ImageList:ImageList  ,//图片
                frame: CGRect(x: 0, y: CommonFunction.NavigationControllerHeight, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight),Callback_SelectedValue: { (value,isLast) -> Void in
                    if(isLast==true){   //最后一张图 点击进入
                        let mainvc = MainTabBarController()
                        mainvc.StartPageImage.image=UIImage(named: self.ImageList[value])
                        self.window!.rootViewController = mainvc
                        //设置为非第一次启动
                        UserDefaults.standard.set(true, forKey: "IsFirstLaunch")
                    }
            } , isJumpBtn: true, Callback_JumpValue: { (selectedImage)->Void in
                //点击跳转 isJumpBtn是否显示跳转按钮
                let mainvc = MainTabBarController()
                mainvc.StartPageImage.image=selectedImage
                self.window!.rootViewController = mainvc
                //设置为非第一次启动
                UserDefaults.standard.set(true, forKey: "IsFirstLaunch")
            })
            
            self.window!.rootViewController =  vc
            
        }
        else{
            //不是第一次进入，进入主页面
            self.window!.rootViewController =  MainTabBarController()
        }
        
        self.window!.makeKeyAndVisible()
    }
    
    
    // MARK: - 友盟统计
    func InitUMStatistics(){
        #if DEBUG
            MobClick.setLogEnabled(true)
        #else
            MobClick.setLogEnabled(false)
        #endif
        MobClick.setAppVersion(CommonFunction.GetVersion(0))
        let configure=UMAnalyticsConfig()
        configure.appKey=UMAPPKey
        MobClick.start(withConfigure: configure)
    }
    
    // MARK: - 友盟分享
    func InitUMshare(){
        
        //打开调试log的开关
        #if DEBUG
            UMSocialData.openLog(true)
        #else
            UMSocialData.openLog(false)
        #endif
        
        //设置友盟社会化组件appkey
        UMSocialData.setAppKey(UMAPPKey)
        //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
        UMSocialConfig.setSupportedInterfaceOrientations(.all)
        
        
        //设置微信AppId，设置分享url，默认使用友盟的网址
        UMSocialWechatHandler.setWXAppId("wx5fbe5d9041adea65287", appSecret: "6c321e211dc77f7360c858375daa2ace7d", url: "")
        
        // 打开新浪微博的SSO开关
        // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
        UMSocialSinaSSOHandler.openNewSinaSSO(withAppKey: "2674aaas681605", secret: "0dfa37ed4b0f76b238b1sda2c1adsb9f77e0a", redirectURL: "")
        
        //设置分享到QQ空间的应用Id，和分享url 链接
        UMSocialQQHandler.setQQWithAppId("1104696ds241", appKey: "w8pazfaA1hdNid85Ft", url: "")
        
    }
    
    //分享成功入口(需要设置 否则 didFinishGetUMSocialDataInViewController 无法进入该函数)
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return UMSocialSnsService.handleOpen(url)
    }
    
    
    // MARK: - 网络检测
    //网络检测
    func InitNetworkCheck(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckNetwork), name: NSNotification.Name.reachabilityChanged, object: nil)
        self.conn=Reachability.forInternetConnection()
        self.conn?.startNotifier()
        let status =    self.conn!.currentReachabilityStatus() as NetworkStatus
         
        switch status {
        case NotReachable:  //网络未连接
            CommonFunction.MessageNotification("网络未连接", interval: 3, msgtype: .error)
            break
        default:
            NetWordStatus=true
            break
        }
    }
    
    func CheckNetwork (){
        CheckNetworkStatus()
    }
    //检测网络连接状态
    func CheckNetworkStatus(){
        switch self.conn!.currentReachabilityStatus() {
        case NotReachable:  //未连接
            CommonFunction.MessageNotification("网络未连接", interval: 3, msgtype: .error)
            NetWordStatus=false
            break
        case ReachableViaWiFi:  //wifi
            CommonFunction.MessageNotification("当前使用WIFI", interval: 2, msgtype: .none)
            NetWordStatus=true
            break
        case ReachableViaWWAN:  //移动网络 2g 3g 4g
            CommonFunction.MessageNotification("当前使用移动网络2g3g4g", interval: 2, msgtype: .none)
            NetWordStatus=true
            break
        default:
            break
        }
        
    }
    
    // MARK: - 创建数据库
    func InitDB(){
        CreatedbBase().CreateDB()   //创建已封装好的数据库
    }
    
    
    // MARK:
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

