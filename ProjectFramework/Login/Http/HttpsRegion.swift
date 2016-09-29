//
//  HtppsRegion.swift
//  ProjectFramework
//
//  Created by hcy on 16/5/29.
//  Copyright © 2016年 HCY. All rights reserved.
//

import UIKit

///获取区域编码类
class HttpsRegion: NSObject {
    
    func GetRegionCode()->[Region]{
        var regionList=[Region]()
        let region=Region()
        region.RegionCode=86
        region.RegionName="大陆"
 
        regionList.append(region)
        return regionList
    }
}
