//
//  Comment.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/20.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import Foundation
import Parse


class Comment {
    var comment: String?
    var pName: String?
    var stamp: Int
    init(comment: String, pname: String, stamp: Int){
        self.comment = comment
        self.pName = pname
        self.stamp = stamp
    }
    
    func save(){
        let commentObject = PFObject(className: "C_Table")
        commentObject["comment"] = self.comment
        commentObject["cName"] = self.pName
        commentObject["stamp"] = self.stamp
        commentObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                print("保存完了")
            }
        }
    }
}