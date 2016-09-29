//
//  SwiftExtension.swift
//  CityParty
//
//  Created by hcy on 16/4/4.
//  Copyright © 2015年 hcy. All rights reserved.
//

import Foundation
import UIKit


private var _percentage:Float = 0
typealias Callback_CameraPhotoValue=(_ value:UIImage)->Void//相机回调 声明一个闭包
var  CallbackCameraPhotoValue:Callback_CameraPhotoValue?//声明一个闭包
extension UIViewController:SKStoreProductViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    //自定义导航navigationController 进度条值
    fileprivate var percentage:Float {
        
        get{
            let result = objc_getAssociatedObject(self, &_percentage) as? Float
            if result == nil {
                return 0
            }
            
            return result!
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &_percentage, newValue, objc_AssociationPolicy(rawValue: 3)!)
        }
    }
    
    //自定义导航进度条(数据加载) 虚拟的进度条不是实时的请求数据
    func CustomNavProgress(){
        //注册KVO
        NotificationCenter.default.addObserver(self, selector: #selector(self.SetPercentage), name: NSNotification.Name(rawValue: "CustomNavProgress"), object: nil)
        
        while (percentage <= 200 )
        {
            if(percentage >= 85 && percentage<=100){    //大概数据在85%-99%之间就开始每秒自增一点点
                
                Thread.sleep(forTimeInterval: 0.05)
                DispatchQueue.main.async(execute: {
                    self.percentage += 0.01
                    self.navigationController?.setSGProgressPercentage(self.percentage, andTintColor: UIColor.white   )
                })
                continue
            }
            Thread.sleep(forTimeInterval: 0.01)
            DispatchQueue.main.async(execute: {
                self.navigationController?.setSGProgressPercentage(self.percentage, andTintColor: UIColor.white   )
            })
            
            if(percentage >= 100.0)
            {   //数据接收完毕
                NotificationCenter.default.removeObserver(self)//删除KVO
                self.percentage=0   //进度条值为0
                return
            }
            
            percentage += Float(arc4random() % 50)  //随机数据
        }
        
    }
    //利用KVO来改变该属性的值
    internal func  SetPercentage(){
        self.percentage=101
    }
    
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        //应用跳转到AppStore进来的
        viewController.dismiss(animated: true, completion: nil)
    }
    /**
     相机相册选择
     
     - parameter call: 回调图片
     */
    func ShowCameraPhotoSheet(_ call:@escaping Callback_CameraPhotoValue){
        CallbackCameraPhotoValue=call
        var Method:UIAlertControllerStyle
        Method=UIAlertControllerStyle.actionSheet
        
        let alertController = UIAlertController(title: "选择图片", message: "", preferredStyle: Method)
        
        //相机
        let CameraAction = UIAlertAction(title: "相机", style: UIAlertActionStyle.default) { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()//创建图片控制器
                picker.delegate = self//设置代理
                picker.sourceType = UIImagePickerControllerSourceType.camera//设置来源
                picker.allowsEditing = true //允许编辑
                self.present(picker, animated: true, completion: nil)//打开相机
            }else{
                CommonFunction.HUD("该设备不支持摄像", type: MsgType.error)
            }
        }
        alertController.addAction(CameraAction)
        
        //相册
        let PhotoAction = UIAlertAction(title: "相册", style: UIAlertActionStyle.default) { (UIAlertAction) in
            let PictrueVc = PictrueSelectedViewController(IsSelecetdMultiple: false, Callback_SelectedValue: { (value) in
                if(CallbackCameraPhotoValue != nil){
                    CallbackCameraPhotoValue!(value[0])
                    CallbackCameraPhotoValue=nil
                }
            })
            self.navigationController?.pushViewController(PictrueVc, animated: true)
        }
        alertController.addAction(PhotoAction)
        
        //取消
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel){ (UIAlertAction) in
            
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        

    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if(picker.allowsEditing==true){
            //剪切图片
            if(CallbackCameraPhotoValue != nil){
                CallbackCameraPhotoValue!((info[UIImagePickerControllerEditedImage] as? UIImage)!)
                CallbackCameraPhotoValue=nil
            }
            picker.dismiss(animated: true, completion: nil)
        }else{
            //未剪切
            if(CallbackCameraPhotoValue != nil){
                CallbackCameraPhotoValue!((info[UIImagePickerControllerOriginalImage] as? UIImage)!)
                CallbackCameraPhotoValue=nil
            }
            picker.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        CallbackCameraPhotoValue=nil
    }

    
}

extension UIColor {
    
    ///UIColor 转换 uiimage
    func ImageWithColor(_ color: UIColor) -> UIImage {
        // 描述矩形
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size)
        // 获取位图上下文
        let context: CGContext = UIGraphicsGetCurrentContext()!
        // 使用color演示填充上下文
        context.setFillColor(color.cgColor)
        // 渲染上下文
        context.fill(rect)
        // 从上下文中获取图片
        let theImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        // 结束上下文
        UIGraphicsEndImageContext()
        return theImage
    }
    
    
}

extension UIImage{
    ///设置图片透明度
    func ImageByApplyingAlpha(_ alpha: CGFloat, image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        let area: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        ctx.scaleBy(x: 1, y: -1)
        ctx.translateBy(x: 0, y: -area.size.height)
        ctx.setBlendMode(.multiply)
        ctx.setAlpha(alpha)
        ctx.draw(image.cgImage!, in: area)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    ///改变图片大小
    func ImageCompressForWidth(_ sourceImage: UIImage, targetWidth defineWidth: CGFloat) -> UIImage {
        let imageSize: CGSize = sourceImage.size
        let width: CGFloat = imageSize.width
        let height: CGFloat = imageSize.height
        let targetWidth: CGFloat = defineWidth
        let targetHeight: CGFloat = (targetWidth / width) * height
        UIGraphicsBeginImageContext(CGSize(width: targetWidth, height: targetHeight))
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
}

private var SUIBUTTONPERSON_ID_NUMBER_PROPERTY = ""
//拓展UIButton 1个属性   ExpTagString->String
extension UIButton {
    
    var ExpTagString:String{
        
        get{
            let result = objc_getAssociatedObject(self, &SUIBUTTONPERSON_ID_NUMBER_PROPERTY) as? String
            if result == nil {
                return ""
            }
            
            return result!
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &SUIBUTTONPERSON_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy(rawValue: 3)!)
        }
    }
    
}



//字符串拓展属性
extension  String {
    /**
     获取当前字符串的高度
     
     - parameter font:    字体
     - parameter maxSize: CGSize
     
     - returns: 高度CGSize
     */
    func ContentSize(font:UIFont,maxSize:CGSize) -> CGSize {
        return self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size
    }
    
    ///字符串时间转换（返回 x分钟前/x小时前/昨天/x天前/x个月前/x年前
    ///注意，格式必须正确 只接受 yyyy-MM-dd HH:mm:ss 类型字符 否则转换出错
    func CompareCurretTime()->String{
        //把字符串转为NSdate
        let dateFormatter =   DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let date:Date=dateFormatter.date(from: self)!
        
        let curDate = Date()
        let  time:TimeInterval  = -date.timeIntervalSince(curDate)
        
        let year:Int = (Int)(curDate.currentYear - date.currentYear);
        let month:Int = (Int)( curDate.currentMonth - date.currentMonth);
        let day:Int = (Int)(curDate.currentDay - date.currentDay);
        
        var  retTime:TimeInterval = 1.0;
        
        // 小于一小时
        if (time < 3600) {
            retTime = time / 60
            retTime = retTime <= 0.0 ? 1.0 : retTime
            if(retTime.format(".0")=="0"){
                return "刚刚"
            }
            else{
                return retTime.format(".0")+"分钟前"
            }
        }
            // 小于一天，也就是今天
        else if (time < 3600 * 24) {
            retTime = time / 3600
            retTime = retTime <= 0.0 ? 1.0 : retTime
            return retTime.format(".0")+"小时前"
        }
            // 昨天
        else if (time < 3600 * 24 * 2) {
            return "昨天"
        }
            
            // 第一个条件是同年，且相隔时间在一个月内
            // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
        else if ((abs(year) == 0 && abs(month) <= 1)
            || (abs(year) == 1 &&  curDate.currentMonth == 1 && date.currentMonth == 12)) {
            var   retDay:Int = 0;
            // 同年
            if (year == 0) {
                // 同月
                if (month == 0) {
                    retDay = day;
                }
            }
            
            if (retDay <= 0) {
                // 这里按月最大值来计算
                // 获取发布日期中，该月总共有多少天
                let totalDays:Int = date.TotaldaysInThisMonth()
                
                // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
                retDay = curDate.currentDay + (totalDays - date.currentDay)
                
                if (retDay >= totalDays) {
                    let value = abs(max(retDay / date.TotaldaysInThisMonth(), 1))
                    return  value.description + "个月前"
                }
            }
            return abs(retDay).description + "天前"
        }
        else  {
            if (abs(year) <= 1) {
                if (year == 0) { // 同年
                    return abs(month).description+"个月前"
                }
                
                // 相差一年
                let month:Int =  curDate.currentMonth
                let preMonth:Int = date.currentMonth
                
                // 隔年，但同月，就作为满一年来计算
                if (month == 12 && preMonth == 12) {
                    return  "1年前"
                }
                // 也不看，但非同月
                return abs(12 - preMonth + month).description + "个月前"
                
            }
            return abs(year).description + "年前"
        }
        
    }
    
    ///base64string 字符转换UIImage  返回UIImage
    func ToImage()->UIImage?{
        let base64String = self  //base64转换图片
        let data =  Data(base64Encoded: base64String, options:   NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        if( data != nil){
            let img = UIImage(data: data!)
            if(img != nil){
                return img!
            }
        }
        return nil
    }
    
    
}

extension Dictionary {
    
    /**
     字典转换字符串
     
     - parameter dict: 字典类型<String,AnyObject>
     
     - returns: 返回字符串
     */
    static func ToDictionaryString(_ dict:Dictionary<String,AnyObject>)->String{
        
        var strJson:String=""
        do {
            
            let data =  try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            strJson=NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            
        }
        
        return strJson
        
    }
}


extension Double {
    ///用法 let myDouble = 1.234567  println(myDouble.format(".2") .2代表留2位小数点
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}

extension CGFloat{
    
    func ToFloat() -> Float {
        return Float(self)
    }
}

//日期拓展属性
extension Date {
    /**
     这个月有几天
     
     - parameter date: nsdate
     
     - returns: 天数
     */
    func TotaldaysInThisMonth(_ date : Date   ) -> Int {
        let totaldaysInMonth: NSRange = (Calendar.current as NSCalendar).range(of: .day, in: .month, for: date)
        return totaldaysInMonth.length
    }
    /**
     这个月有几天
     
     - parameter date: nsdate
     
     - returns: 天数
     */
    func TotaldaysInThisMonth() -> Int {
        let totaldaysInMonth: NSRange = (Calendar.current as NSCalendar).range(of: .day, in: .month, for: self)
        return totaldaysInMonth.length
    }
    
    /**
     得到本月的第一天的是第几周
     
     - parameter date: nsdate
     
     - returns: 第几周
     */
    func toMonthOneDayWeek (_ date:Date) ->Int {
        let Week: NSInteger = (Calendar.current as NSCalendar).ordinality(of: .day, in: NSCalendar.Unit.weekOfMonth, for: date)
        return Week-1
    }
    
    
    /// 返回当前日期 年份
    var currentYear:Int{
        
        get{
            
            return GetFormatDate("yyyy")
        }
        
    }
    /// 返回当前日期 月份
    var currentMonth:Int{
        
        get{
            
            return GetFormatDate("MM")
        }
        
    }
    /// 返回当前日期 天
    var currentDay:Int{
        
        get{
            
            return GetFormatDate("dd")
        }
        
    }
    /// 返回当前日期 小时
    var currentHour:Int{
        
        get{
            
            return GetFormatDate("HH")
        }
        
    }
    /// 返回当前日期 分钟
    var currentMinute:Int{
        
        get{
            
            return GetFormatDate("mm")
        }
        
    }
    /// 返回当前日期 秒数
    var currentSecond:Int{
        
        get{
            
            return GetFormatDate("ss")
        }
        
    }
    
    /**
     获取yyyy  MM  dd  HH mm ss
     
     - parameter format: 比如 GetFormatDate(yyyy) 返回当前日期年份
     
     - returns: 返回值
     */
    func GetFormatDate(_ format:String)->Int{
        let dateFormatter:DateFormatter = DateFormatter();
        dateFormatter.dateFormat = format;
        let dateString:String = dateFormatter.string(from: self);
        var dates:[String] = dateString.components(separatedBy: "")
        let Value  = dates[0]
        if(Value==""){
            return 0
        }
        return Int(Value)!
    }
}

extension UITableViewCell {
    func InitConfig(_ cell:Any){
        
    }
     
}

private var UITapGestureRecognizer_TagString = ""
extension UITapGestureRecognizer {
    var ExpTagString:String{
        
        get{
            let result = objc_getAssociatedObject(self, &UITapGestureRecognizer_TagString) as? String
            if result == nil {
                return ""
            }
            
            return result!
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &UITapGestureRecognizer_TagString, newValue, objc_AssociationPolicy(rawValue: 3)!)
        }
    }
    
}

import FMDB
extension FMDatabase {
    
    fileprivate func valueForQuery<T>(_ sql: String, values: [AnyObject]?, completionHandler:(FMResultSet)->(T!)) -> T! {
        var result: T!
        
        if let rs = executeQuery(sql, withArgumentsIn: values) {
            if rs.next() {
                let obj: AnyObject! = rs.object(forColumnIndex: 0) as AnyObject!
                if !(obj is NSNull) {
                    result = completionHandler(rs)
                }
            }
            rs.close()
        }
        
        return result
    }
    
    
    func stringForQuery(_ sql: String, _ values: AnyObject...) -> String! {
        return valueForQuery(sql, values: values) { $0.string(forColumnIndex: 0) }
    }
    
    
    func intForQuery(_ sql: String, _ values: AnyObject...) -> Int32! {
        return valueForQuery(sql, values: values) { $0.int(forColumnIndex: 0) }
    }
    
    func longForQuery(_ sql: String, _ values: AnyObject...) -> Int! {
        return valueForQuery(sql, values: values) { $0.long(forColumnIndex: 0) }
    }
    
    func boolForQuery(_ sql: String, _ values: AnyObject...) -> Bool! {
        return valueForQuery(sql, values: values) { $0.bool(forColumnIndex: 0) }
    }
    
    func doubleForQuery(_ sql: String, _ values: AnyObject...) -> Double! {
        return valueForQuery(sql, values: values) { $0.double(forColumnIndex: 0) }
    }
    
    func dateForQuery(_ sql: String, _ values: AnyObject...) -> Date! {
        return valueForQuery(sql, values: values) { $0.date(forColumnIndex: 0) }
    }
    
    func dataForQuery(_ sql: String, _ values: AnyObject...) -> Data! {
        return valueForQuery(sql, values: values) { $0.data(forColumnIndex: 0) }
    }
    
    func executeQuery(_ sql:String, _ values: [AnyObject]?) -> FMResultSet? {
        return executeQuery(sql, withArgumentsIn: values as [AnyObject]?);
    }
    
    func executeUpdate(_ sql:String, _ values: [AnyObject]?) -> Bool {
        return executeUpdate(sql, withArgumentsIn: values as [AnyObject]?);
    }
    
}


                                            
