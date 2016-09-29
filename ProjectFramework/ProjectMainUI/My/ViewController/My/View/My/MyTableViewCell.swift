//
//  MyTableViewCell.swift
//  ProjectFramework
//
//  Created by 猪朋狗友 on 16/6/20.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import SDWebImage

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var userpic: UIImageView!    //用户头像图片
    @IBOutlet weak var username: UILabel!       //用户名称
    @IBOutlet weak var userphone: UILabel!      //手机号
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func InitConfig(_ cell: Any) {
        let my = cell as! MyModel
        
        
        //加载图片 利用SDWebImage网络图片请求
        let picurl = URL(string:my.userpic)
        self.userpic.sd_setImage(with: picurl, placeholderImage: UIImage(named: placeholderImage)!)
        self.userpic.sd_setImage(with: picurl) { (UIImage, Error, SDImageCacheType, URL) in
            
        }
         
        self.userpic.sd_setImage(with:URL(string:my.userpic), placeholderImage: UIImage(named: placeholderImage),options:  SDWebImageOptions.retryFailed){ (UIImage, Error, SDImageCacheType, URL) in
            
            if(UIImage != nil){
                self.userpic.image=UIImage
            }
        }
        self.username.text=my.name
        self.userphone.text=my.phone
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
