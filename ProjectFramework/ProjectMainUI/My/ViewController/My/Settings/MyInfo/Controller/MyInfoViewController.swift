//
//  MyInfoViewController.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/16.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

class MyInfoViewController: UITableViewController {
    
    @IBOutlet weak var pic: UIImageView!    //图片
    @IBOutlet weak var name: UILabel!       //姓名
    @IBOutlet weak var sex: UILabel!        //性别
    @IBOutlet weak var area: UILabel!       //区域
    @IBOutlet weak var address: UILabel!    //地址
    @IBOutlet weak var phone: UILabel!      //电话

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="个人信息"
        self.tableView.tableFooterView=UIView() //去除多余底部线条
        
        //添加保存按钮
        let item = UIBarButtonItem(title: "保存 ", style: .plain, target: self, action: #selector(MyInfoViewController.Save))
        self.navigationItem.rightBarButtonItem=item
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //选择时
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch((indexPath as NSIndexPath).row){
        case 0 :    //头像
            CommonFunction.CameraPhotoAlertController(self, Camera_Callback: { (img) in
                self.pic.image=img
            })
            break
        case 1 :    //姓名
            ShowModifyValue(name.text!, Callback_Value: { (value) in
                self.name.text=value
            })
            break
        case 2 :    //性别
            SexSelected(sex)
            break
        case 3 :    //所在区域 
            Area(area)
            break
        case 4 :    //所在地址
            ShowModifyValue(address.text!, Callback_Value: { (value) in
                self.address.text=value
            })
            break
        case 5 :    //联系号码
            ShowModifyValue(phone.text!, Callback_Value: { (value) in
                self.phone.text=value
            })
            break
        default:break
        }
        
    }

    
    fileprivate func ShowModifyValue(_ DataSource:String, Callback_Value: ((_ value:String)->Void)?){
       
        //封装好的修改界面
        let vc = ModifyViewController(DataSource: DataSource) { (value) in
            Callback_Value!(value)
        }
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
    //性别选择
    fileprivate func SexSelected(_ sex:UILabel){
        let alertController = UIAlertController(title: "性别选择", message: "", preferredStyle: .actionSheet) 
        let CameraAction = UIAlertAction(title: "男", style: .default) { (UIAlertAction) in
           sex.text="男"
        }
        alertController.addAction(CameraAction)
        let PhotoAction = UIAlertAction(title: "女", style: .destructive) { (UIAlertAction) in
           sex.text="女"
        }
        alertController.addAction(PhotoAction)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel){ (UIAlertAction) in
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //区域
    fileprivate func Area(_ area:UILabel){
        
    }
    
    //保存
     func Save(){
    
    }

}
