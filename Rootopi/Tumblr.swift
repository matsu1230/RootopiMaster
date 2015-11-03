//
//  Tumblr.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/28.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import Foundation
import UIKit

class Tumblr {
    
    var url: String!
    var title: String!
    var photourl: String!
    var body: String!
    
    init(title: String, url: String, photourl: String, body: String){
        self.url = url
        self.photourl = photourl
        self.body = body
        self.title = title
    }
    
}