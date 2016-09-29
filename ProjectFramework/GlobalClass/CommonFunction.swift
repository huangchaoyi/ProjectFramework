//
//  CommonFunction.swift
//  ProjectFramework
//
//  Created by hcy on 16/4/5.
//  Copyright © 2016年 HCY. All rights reserved.
//

import Foundation
import CWStatusBarNotification  
import FMDB
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


//CWStatusBarNotification 该库的枚举类型 （自定义）
enum MsgType{
    ///成功
    case success
    ///错误
    case error
    ///加载
    case load
    ///无
    case none
}
enum CommonMethod: String {
    case   GET,   POST
}
enum CommonParameterEncoding {
    case url
    case urlEncodedInURL
    case json
}
enum CommonUIAlertControllerStyle : Int {
    
    case alert
}
//获取手机型号 5s 6 6p 6ps等
enum CommonPhoneDeviceModel : String {
    case iPodTouch5; case iPodTouch6
    case iPhone4;case iPhone4s
    case iPhone5;case iPhone5c; case iPhone5s ;case iPhone5se
    case iPhone6 ;case iPhone6Plus
    case iPhone6s ;case iPhone6sPlus
    case iPad2 ;case iPad3; case iPad4
    case iPadAir ;case iPadAir2
    case iPadMini ;case iPadMini2;case iPadMini3;case iPadMini4
    case iPadPro;case AppleTV;case Simulator;case  processor
}

//验证 邮箱网址手机号码等正则判断 使用方法如下
//Validate.email("Dousnail@@153.com").isRight //false
//Validate.URL("https://www.baidu.com").isRight //true
//Validate.IP("11.11.11.11").isRight //true

enum Validate {
    case email(_: String)
    case phoneNum(_: String)
    case carNum(_: String)
    case username(_: String)
    case password(_: String)
    case nickname(_: String)
    
    case url(_: String)
    case ip(_: String)
    
    
    var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
        case let .phoneNum(str):
            predicateStr = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
            currObject = str
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .password(str):
            predicateStr = "^[a-zA-Z0-9]{6,20}+$"
            currObject = str
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
        case let .url(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
        case let .ip(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
        }
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: currObject)
    }
}

final class   CommonFunction {
 
    //单例
    static var  Instance : CommonFunction {
        struct Static {
            static let instance : CommonFunction = CommonFunction()
        }
        return Static.instance
    }
    
    
    // MARK:第三方库定义方法
    //第三方 CWStatusBarNotification
    static let notification = CWStatusBarNotification()
    // MARK:导航栏高度和屏幕宽高度
    ///导航栏的高度
    static let NavigationControllerHeight:CGFloat=64
    /// 屏幕的宽度
    static let kScreenWidth = UIScreen.main.bounds.size.width
    /// 屏幕的高度
    static let kScreenHeight = UIScreen.main.bounds.size.height
    
    // MARK:系统版本
    /// 系统版本
    static let IOS6 = (UIDevice.current.systemVersion as NSString).doubleValue >= 6.0
    static let IOS7 = (UIDevice.current.systemVersion as NSString).doubleValue >= 7.0
    static let IOS8 = (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0
    static let IOS9 = (UIDevice.current.systemVersion as NSString).doubleValue >= 9.0
    
    // MARK:获取手机设备型号  4s 5 5s 6 6p
    /// 获取手机设备型号
    static func GetPhoneDeviceModel ()->CommonPhoneDeviceModel{
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return  CommonPhoneDeviceModel.iPodTouch5
        case "iPod7,1":                                 return CommonPhoneDeviceModel.iPodTouch6
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return CommonPhoneDeviceModel.iPhone4
        case "iPhone4,1":                               return CommonPhoneDeviceModel.iPhone4s
        case "iPhone5,1", "iPhone5,2":                  return CommonPhoneDeviceModel.iPhone5
        case "iPhone5,3", "iPhone5,4":                  return CommonPhoneDeviceModel.iPhone5c
        case "iPhone6,1", "iPhone6,2":                  return CommonPhoneDeviceModel.iPhone5s
        case "iPhone6,3", "iPhone6,4":                  return CommonPhoneDeviceModel.iPhone5se
        case "iPhone7,2":                               return CommonPhoneDeviceModel.iPhone6
        case "iPhone7,1":                               return CommonPhoneDeviceModel.iPhone6Plus
        case "iPhone8,1":                               return CommonPhoneDeviceModel.iPhone6s
        case "iPhone8,2":                               return CommonPhoneDeviceModel.iPhone6sPlus
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return CommonPhoneDeviceModel.iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3":           return CommonPhoneDeviceModel.iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6":           return CommonPhoneDeviceModel.iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3":           return CommonPhoneDeviceModel.iPadAir
        case "iPad5,3", "iPad5,4":                      return CommonPhoneDeviceModel.iPadAir2
        case "iPad2,5", "iPad2,6", "iPad2,7":           return CommonPhoneDeviceModel.iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6":           return CommonPhoneDeviceModel.iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9":           return CommonPhoneDeviceModel.iPadMini3
        case "iPad5,1", "iPad5,2":                      return CommonPhoneDeviceModel.iPadMini4
        case "iPad6,7", "iPad6,8":                      return CommonPhoneDeviceModel.iPadPro
        case "AppleTV5,3":                              return CommonPhoneDeviceModel.AppleTV
        case "i386", "x86_64":                          return CommonPhoneDeviceModel.Simulator
        default:                                        return CommonPhoneDeviceModel.processor
        }
        
    }
    
    // MARK:应用跳转
    /// 跳转到相应的应用，记得将 http:// 替换为 itms:// 或者 itms-apps://：  需要真机调试
    static func OpenAppStore(_ vc:UIViewController,url: String){
        //在url内查找appid
        if let number = url.range(of: "[0-9]{9}", options: NSString.CompareOptions.regularExpression) {
            let appId = url.substring(with: number)
            let productView = SKStoreProductViewController()
            productView.delegate = vc
            productView.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : appId], completionBlock: {  (result, error) -> Void in
                if !result {
                    //点击取消
                    productView.dismiss(animated: true, completion: nil)
                }
            })
            vc.present(productView, animated: true, completion: nil)
        } else {
            HUD("打开失败,请查看url是否正确", type: .error)
        }
    }
    
    /// 拨打电话 ,里面会判断是否需要拨打号码 外部不需要调用判断 需要真机调试
    static func CallPhone(_ vc:UIViewController,number:String){
        
        AlertController(vc, title: "拨打号码", message: "确认是否拨通此号码", ok_name: "确定", cancel_name: "取消", style: .alert, OK_Callback: {
            //确定
            let telUrl="tel:"+number
            let url  = URL(string: telUrl)
            UIApplication.shared.openURL(url!)
            
        }) {
            //取消
        }
        
    }
    
    /// 打开浏览器    需要真机调试
    static func OpenBlogForBrowser(_ url:String){
        UIApplication.shared.openURL(URL(string: url)!)
    }
    
    
    // MARK:获取版本和本机信息（设备、型号)
    ///类型 0 =   CFBundleShortVersionString    1 = CFBundleVersion 默认获取0
    static func GetVersion(_ type:Int=0)->String{
        let infoDictionary = Bundle.main.infoDictionary
        var  Version:String = ""
        if(type==0){
            
            let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"] as AnyObject?
            Version=majorVersion as! String
        }
        if(type==1){
            let minorVersion : AnyObject? = infoDictionary! ["CFBundleVersion"] as AnyObject?
            Version=minorVersion as! String
        }
        return Version
    }
    ///ios 版本
    static  let Iosversion : NSString = UIDevice.current.systemVersion as NSString
    ///设备 udid
    static  let IdentifierNumber = UIDevice.current.identifierForVendor
    /// 设备名称
    static  let SystemName = UIDevice.current.systemName
    /// 设备型号
    static let Model = UIDevice.current.model
    /// 设备区域化型号 如 A1533
    static let LocalizedModel = UIDevice.current.localizedModel
    // MARK:颜色块
    /// 颜色
    static func RGBA(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: (a))}
    /// 颜色
    static func RGBA(_ r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: (1))}
    // MARK:Plist用例
    ///创建plist 用法  let myDic=NSMutableDictionary() myDic.setValue("value", forKey: "key1")  CommonFunction.CreatePlistFile("test").SetPlistFileValue("test", Key: "key", Dictionary: myDic )
    class   func  CreatePlistFile(_ plistname:String )->CommonFunction{
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + (plistname+".plist") //获取到plist文件路径
        //不存在plist文件就创建
        if FileManager.default.fileExists(atPath: path) == false {
            let fileManager: FileManager = FileManager.default
            //创建plist
            fileManager.createFile(atPath: path, contents: nil, attributes: nil)
            let Dictionary = NSMutableDictionary()
            Dictionary.write(toFile: path, atomically: true)  //写入
        }
        return Instance //返回当前单例的对象
        
    }
    ///写入plist值 ：注：Key不可重复 重复不添加
    func SetPlistFileValue(_ plistname:String,Key:String,Dictionary:NSMutableDictionary) {
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + (plistname+".plist") //获取到plist文件路径
        //读取plist文件的内容
        let  dataDictionary = NSMutableDictionary(contentsOfFile: path)
        
        if(dataDictionary?.object(forKey: Key) != nil){
            return
        }else{
            //添加数据
            dataDictionary?.setValue(Dictionary, forKey: Key)
        }
        //重新写入到plist
        dataDictionary?.write(toFile: path, atomically: true)
    }
    ///获取plist所有对象 返回 NSMutableDictionary
    func GetAllPlistFileValue(_ plistname:String)->NSMutableDictionary {
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + (plistname+".plist") //获取到plist文件路径
        
        //读取plist文件的内容
        let  dataDictionary = NSMutableDictionary(contentsOfFile: path)
        
        return dataDictionary!
    }
    ///获取plist的Key对象 返回 NSDictionary
    func GetKeyPlistFileValue(_ plistname:String,Key:String)->NSDictionary {
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + (plistname+".plist") //获取到plist文件路径
        
        var dic:NSDictionary?
        
        //读取plist文件的内容
        let  dataDictionary = NSMutableDictionary(contentsOfFile: path)
        if(dataDictionary?.allKeys.count>0){
            dic=(dataDictionary?.object(forKey: Key))! as? NSDictionary
            
        }
        return dic!
    }
    ///删除plist的所有对象
    func DelAllPlistValue(_ plistname:String)->NSMutableDictionary{
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + (plistname+".plist") //获取到plist文件路径
        
        //读取plist文件的内容
        let  dataDictionary = NSMutableDictionary(contentsOfFile: path)
        if(dataDictionary?.allKeys.count>0){
            dataDictionary?.removeAllObjects()  //全部删除
            //重新写入到plist
            dataDictionary?.write(toFile: path, atomically: true)
        }
        return dataDictionary!
    }
    ///删除plist的Key对象
    func DelKeyPlistValue(_ plistname:String,Key:String)->NSMutableDictionary{
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + (plistname+".plist") //获取到plist文件路径
        
        //读取plist文件的内容
        let  dataDictionary = NSMutableDictionary(contentsOfFile: path)
        if(dataDictionary?.allKeys.count>0){
            dataDictionary?.removeObject(forKey: Key) //删除
            //重新写入到plist
            dataDictionary?.write(toFile: path, atomically: true)
        }
        return dataDictionary!
        
    }
    
    // MARK:调用stroryboar函数
    ///用法 let vc = CommonFunction.viewControllerWithStoryboardName("Main",  Identifier: "Identifier")
    static  func ViewControllerWithStoryboardName(_ stroryboardName: String,  Identifier: String) -> UIViewController {
        let sb = UIStoryboard(name: stroryboardName, bundle: Bundle.main)
        return sb.instantiateViewController(withIdentifier: Identifier)
    }
    // MARK:给任意个view 添加虚线
    ///创建一个虚线的边框 用法 CommonFunction.addBorderToLayer(self)  不可先使用self.layer
    static  func AddBorderToLayer(_ view:UIView,strokeColor:UIColor=UIColor.black,fillColor:UIColor=UIColor.clear,linewidth:CGFloat=0.2)
    {
        // 创建一个shapeLayer
        let  border =  CAShapeLayer()
        border.strokeColor =  strokeColor.cgColor;     // 边缘线的颜色
        border.fillColor = fillColor.cgColor  // 闭环填充的颜色
        // 贝塞尔曲线(创建一个跟当前view一样的路径)
        border.path = UIBezierPath(rect: view.bounds).cgPath
        border.frame = view.bounds    // 与showView的frame一致
        border.lineWidth = linewidth;    // 线条宽度
        border.lineCap = kCALineCapButt
        //线型模板
        //这是一个NSNumber的数组，索引从1开始记，奇数位数值表示实线长度，偶数位数值表示空白长度
        border.lineDashPattern = [1,2]
        // 将layer添加进图层
        view.layer.addSublayer(border)
        //http://blog.csdn.net/iunion/article/details/26221213 CAShapeLayer画线说明
    }
    
    
    // MARK:Notification通知
    ///消息通知，有多种类型，用法 CommonFunction.MessageNotification("test", interval: 5, msgtype: MsgType.Success);    CommonFunction.notification.notificationIsDismissing=true 不可点击通知条 false表示可点击通知条
    static func MessageNotification(_ msg:String,interval:TimeInterval,msgtype:MsgType,font:UIFont=UIFont(name: "Helvetica-Bold", size: 16)!){
        
        self.notification.notificationAnimationInStyle = CWNotificationAnimationStyle.top //样式1
        self.notification.notificationAnimationOutStyle =  CWNotificationAnimationStyle.top //样式2
        self.notification.notificationStyle=CWNotificationStyle.navigationBarNotification   //只显示nav 有2种类型  1.nav  2.Status
        
        let NavHeight:CGFloat=CommonFunction.NavigationControllerHeight    //导航高度
        let ImgWidth:CGFloat=30 //图片宽度
        let view = UIView()
        //图片
        let img = UIImageView(frame: CGRect(x: 10, y: 0, width: ImgWidth, height: NavHeight))
        switch (msgtype) {
        case .success: //成功
            img.image=UIImage(named: "GlobalClassSettings.bundle/NotificationBackgroundSuccessIcon.png")
            view.backgroundColor=RGBA(00,g: 205,b: 9)
            break
        case .error:   //失败
            img.image=UIImage(named: "GlobalClassSettings.bundle/NotificationBackgroundErrorIcon.png")
            view.backgroundColor=RGBA(255,g: 69,b: 0)
            break
        case .load:    //加载
            view.backgroundColor=RGBA(23, g: 170, b: 255)
            let act = UIActivityIndicatorView(frame: img.frame)
            act.activityIndicatorViewStyle = .gray
            act.color=UIColor.white
            act.hidesWhenStopped=false
            act.startAnimating()
            img.addSubview(act)
            break
        case .none:    //无
            view.backgroundColor=RGBA(23, g: 170, b: 255)
            break
        }
        
        img.contentMode=UIViewContentMode.center
        view.addSubview(img)
        
        //消息
        let lbmsg = UILabel(frame: CGRect(x: ImgWidth-10, y: 0, width: kScreenWidth-ImgWidth, height: NavHeight))
        lbmsg.textAlignment=NSTextAlignment.center
        lbmsg.text=msg
        lbmsg.textColor=UIColor.white
        lbmsg.font=font
        view.addSubview(lbmsg)
        self.notification.display(with: view, forDuration: interval)
        
    }
   
    // MARK:友盟分享单利
    //分享单例
    static var  ShareInstance : ShareView {
        struct Static {
            static let instance : ShareView = ShareView()
        }
        return Static.instance
    }
    // MARK:HUD (菊花等待加载进度...)
    /**
     HUD显示 msg:  消息   type: 类型  ismask 蒙版（黑色背景) 默认false 用处在.Load
     
     - parameter msg:  消息
     - parameter type: 类型
     - parameter ismask 蒙版（黑色背景) 默认false 用处在.Load
     */
    static func HUD(_ msg:String,type:MsgType,ismask:Bool=false){
        switch type {
        case .success:  MBProgressHUD.showSuccess(msg); break
        case .error: MBProgressHUD.showError(msg); break
        case .none:  MBProgressHUD.showSuccess(msg); break
        case .load:  MBProgressHUD.showloading(msg,ismask: ismask) ;break
        }
    }
    /**
     隐藏HUD
     */
    static func HUDHide(){
        MBProgressHUD.hide()
    }
   
    // MARK:alert 弹窗模态
    /**
     弹出 是\否   如果ok_name \ cancel_name = nil 则只弹出一个 UIAlertAction
     
     - parameter vc:              self
     - parameter title:           标题
     - parameter message:         消息
     - parameter ok_name:         确定名称
     - parameter cancel_name:     取消名称
     - parameter style:           样式---0底部弹出  1Show弹出
     - parameter OK_Callback:     确定必包回调
     - parameter Cancel_Callback: 取消必包回调
     */
    static func  AlertController(_ vc:UIViewController,title:String,message:String,ok_name:String?,cancel_name:String?,style:CommonUIAlertControllerStyle,OK_Callback: (()->Void)?,Cancel_Callback: (()->Void)?){
        
        var Method:UIAlertControllerStyle
        switch (style) {
        case .alert: Method=UIAlertControllerStyle.alert; break
            
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: Method)
        
        if(ok_name != nil){
            let okAction = UIAlertAction(title: ok_name, style: UIAlertActionStyle.default) { (UIAlertAction) in
                OK_Callback!()
            }
            alertController.addAction(okAction)
        }
        if(cancel_name != nil){
            let cancelAction = UIAlertAction(title: cancel_name, style: UIAlertActionStyle.cancel){ (UIAlertAction) in
                Cancel_Callback!()
            }
            alertController.addAction(cancelAction)
        }
        vc.present(alertController, animated: true, completion: nil) 
    }
    
    
    // MARK:ActionSheet 选择照相机还是相册图片
    static func CameraPhotoAlertController(_ vc:UIViewController,Camera_Callback: ((_ img:UIImage)->Void)?){
        vc.ShowCameraPhotoSheet { (value) in
            Camera_Callback!(value) 
        }
    }
    
 
    // MARK: >> DB单例化 数据库操作
    //FMDatabaseQueue这么设计的目的是让我们避免发生并发访问数据库的问题，因为对数据库的访问可能是随机的（在任何时候）、不同线程间（不同的网络回调等）的请求。内置一个Serial队列后，FMDatabaseQueue就变成线程安全了，所有的数据库访问都是同步执行，而且这比使用@synchronized或NSLock要高效得多。
    
    
    class func DBInstance()->FMDatabaseQueue{
        struct DB{
            static var onceToken:Int = 0;
            static var instance:FMDatabaseQueue? = nil
        }
        //保证单例只创建一次
        var dbPath:String = ""
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = (documentsFolder as NSString).appendingPathComponent("data.sqlite")
        dbPath = path
        //创建数据库
        let dbBase =  FMDatabaseQueue(path:  dbPath )
        DB.instance = dbBase
        return DB.instance!
    }
    
    /**
     DB Update\Add
     
     - parameter sql:      sql
     - parameter values:   值
     - parameter callback: true\false
     */
    static func  ExecuteUpdate(_ sql:String, _ values: [AnyObject]?,callback: ((_ isOk:Bool)->Void)?){
        
        DBInstance().inDatabase { (db ) -> Void  in
            
            db!.open()
            if(db!.executeUpdate(sql, values)){
                debugPrint("executeUpdate 成功 ",db!.lastErrorCode() )
                db!.close()
                callback?(true)
            }
            else{
                debugPrint(" executeUpdate 失败",db!.lastErrorMessage(),db!.lastErrorCode())
                db!.close()
                callback?(false)
            }
        }
    }
    
    /**
     DB查询
     
     - parameter sql:      sql
     - parameter values:   值
     - parameter callback: 查询返回值 返回对象 FMResultSet
     */
    static func ExecuteQuery(_ sql:String, _ values: [AnyObject]?,callback: ((_ Result:FMResultSet)->Void)?) {
        DBInstance().inDatabase { (db) -> Void in
            db!.open()
            let Result = db!.executeQuery(sql,  values)
            if(Result==nil){
                debugPrint("查询失败 ",db!.lastErrorMessage(),db!.lastErrorCode())
            }
            else{
                callback?(Result! )
            }
            db!.close()
        }
    }
    
    // MARK: >> 生成二维码
    /**
     生成二维码
     
     - parameter qrString:    字符串
     - parameter qrImageName: 图片
     
     - returns: uiiamge
     */
    static func CreateQRCode(_ qrString: String?, qrImageName: String?) -> UIImage?{
        if let sureQRString = qrString {
            let stringData = sureQRString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            // 创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter!.setValue(stringData, forKey: "inputMessage")
            qrFilter!.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter!.outputImage
            // 创建一个颜色滤镜,黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")
            colorFilter!.setDefaults()
            colorFilter!.setValue(qrCIImage, forKey: "inputImage")
            colorFilter!.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter!.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            // 返回二维码image
            let codeImage = UIImage(ciImage: colorFilter!.outputImage!.applying(CGAffineTransform(scaleX: 5, y: 5)))
            // 通常,二维码都是定制的,中间都会放想要表达意思的图片
            if let iconImage = UIImage(named: qrImageName!) {
                let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width: rect.size.width * 0.25, height: rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }

    
    
}
