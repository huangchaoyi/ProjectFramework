//
//  SettingsTableViewCell.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/15.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit
import SDWebImage

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var Clear: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func InitConfig(_ cell: Any) {
        
        let  value = cell as! [String]
        self.logo.image=UIImage(named: value[0] )
        self.name.text=value[1]
        Clear.isHidden=true //如果不是清除缓存  则显示这个label 不显示出来
        if(value[2] == "1"){ //如果是清除缓存
            Clear.isHidden=false
           //显示缓存大小
            let intg: Int = Int(SDImageCache.shared().getSize())
            let currentVolum: String = "\(self.fileSizeWithInterge(intg))"
            Clear.text=currentVolum
            
           
        }
    }
    
    //获取缓存大小
    func fileSizeWithInterge(_ size: Int) -> String {
        // 1k = 1024, 1m = 1024k
        if size < 1024 {
            // 小于1k
            return "\(Int(size))B"
        }
        else if size < 1024 * 1024 {
            // 小于1m
            let aFloat: CGFloat = CGFloat(size) / 1024
            return String(format: "%.0fK", aFloat)
        }
        else if size < 1024 * 1024 * 1024 {
            // 小于1G
            let aFloat: CGFloat = CGFloat(size) / (1024 * 1024)
            return String(format: "%.1fM", aFloat)
        }
        else {
            let aFloat: CGFloat = CGFloat(size) / (1024 * 1024 * 1024)
            return String(format: "%.1fG", aFloat)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
