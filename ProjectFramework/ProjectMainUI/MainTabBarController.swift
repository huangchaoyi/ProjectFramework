//
//  MainTabBarController.swift
//  ProjectFramework
//
//  Created by hcy on 16/6/13.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import CYLTabBarController


class  CYLBaseNavigationController:UINavigationController  {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0) {
            //如果当前的viewcontroller.count大于0 表示不再这个页面内 则 隐藏掉TabbarController
            viewController.hidesBottomBarWhenPushed = true
            
        }
        
        //修改导航栏的返回样式  title为 “” 表示只有箭头了
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        viewController.navigationItem.backBarButtonItem = item;
        
        super.pushViewController(viewController, animated: animated)
    }
 
}


class MainTabBarController : CYLTabBarController {
    
    var   StartPageImage = UIImageView()   //第一次进入点击进来的图片(用来做动画)
    
    fileprivate let Title = ["首页","我的"]      //标题
    fileprivate let StoryName = ["Home","My"]   //sb名称（UI)
    fileprivate let SelectedImage = ["contact","contact"]        //选择的图片
    fileprivate let NoSelectedImage = ["add-circular","add-circular"]      //未选择图片
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //第一次启动进来就添加最后一张图片，必须在这里先添加StartPageImage在添加其他vc 不然会出现一闪的白边
            StartPageImage.frame=CGRect(x: 0, y: 0, width: CommonFunction.kScreenWidth, height: CommonFunction.kScreenHeight)
            StartPageImage.contentMode = .scaleToFill
            //获取启动视图
            self.view.addSubview(StartPageImage)    //添加进来，动画完后在移除
        
        //tabbaritem
        var _tabBarItemsAttributes: [AnyObject] = []
        var _viewControllers:[AnyObject] = []
        
        for i in 0 ... Title.count - 1 {
            let dict: [AnyHashable: Any] = [
                CYLTabBarItemTitle: Title[i],   //标题
                CYLTabBarItemImage: NoSelectedImage[i], //未选择图片
                CYLTabBarItemSelectedImage: SelectedImage[i]    //选择图片
            ]
            let vc = UIStoryboard(name: StoryName[i], bundle: nil).instantiateViewController(withIdentifier: StoryName[i])
            
            let rootNavigationController = CYLBaseNavigationController(rootViewController: vc)   //添加自定义导航控制器   如果是append  vc 则不会出现navigationcontrooler
            
            //设置导航的颜色
            rootNavigationController.navigationBar.barTintColor=CommonFunction.RGBA(23, g: 170, b: 255)
            
            //修改导航栏title文字颜色  默认黑色
            vc.navigationController?.navigationBar.titleTextAttributes =
                [NSForegroundColorAttributeName: UIColor.white]
            
            //修改导航栏按钮颜色
            vc.navigationController?.navigationBar.tintColor = UIColor.white
            
            vc.title=Title[i]   //标题
            
            
            _tabBarItemsAttributes.append(dict as AnyObject)
            
            _viewControllers.append(rootNavigationController)
        }
        self.tabBarItemsAttributes = _tabBarItemsAttributes as! [[AnyHashable: Any]]
        self.viewControllers = _viewControllers as! [ UIViewController]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //播放启动画面动画
            launchAnimation()
    }
    
    //播放启动画面动画
    fileprivate func launchAnimation() {
        
        //播放动画效果，完毕后将其移除
        UIView.animate(withDuration: 5, delay: 0.5, options: .beginFromCurrentState,
                                   animations: {
                                    self.StartPageImage.alpha = 0.0
                                    self.StartPageImage.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0)
        }) { (finished) in
          self.StartPageImage.removeFromSuperview()
        }
    }
    
    
    
}
