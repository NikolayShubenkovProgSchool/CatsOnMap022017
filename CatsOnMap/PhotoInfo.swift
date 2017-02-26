//
//  PhotoInfo.swift
//  CatsOnMap
//
//  Created by Nikolay Shubenkov on 26/02/2017.
//  Copyright © 2017 Nikolay Shubenkov. All rights reserved.
//

import Foundation

struct PhotoInfo {
    
    var latitude:Double
    var longitude:Double
    
    var title:String
    var iconLink:String
    var fullPhoto:String
    
    init?(json:[String:Any]){
        
        guard let lat = json["latitude"] as? String,
              let lon = json["longitude"] as? String,
              let title = json["title"] as? String,
              let icon = json["url_s"] as? String,
              let fullImage = json["url_l"] as? String
                else {
                return nil
        }
        
        self.latitude = Double(lat)!
        self.longitude = Double(lon)!
        self.title = title
        self.iconLink = icon
        self.fullPhoto = fullImage
    }
}
