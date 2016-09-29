//
//  MyItemTableViewCell.swift
//  ProjectFramework
//
//  Created by 猪朋狗友 on 16/6/20.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

class MyItemTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!   //logo图标
    @IBOutlet weak var name: UILabel!       //名称
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func InitConfig(_ cell: Any) {
        let  value=cell as! [String]
        self.logo.image=UIImage(named: value[0])
        self.name.text=value[1]
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
