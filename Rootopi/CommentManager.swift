//
//  CommentManager.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/20.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import Foundation
import Parse

class CommentManager{
    var comments: Array<Comment> = []
    //static let pName = CommentManager()
    static let commentInstance = CommentManager()
    
    
    func fechComment(pName: String, callBack: Comment -> Void)-> Void {
        let query = PFQuery(className: "C_Table")
        query.whereKey("cName", containsString: pName)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock{ (comments, error) -> Void in
            if error == nil{
                self.comments = []
                for comment in comments! {
                    let content = comment["comment"] as! String
                    let stamp = comment["stamp"] as! Int
                    let pname = comment["cName"]as! String
                    let come = Comment(comment: content, pname: pname, stamp:  stamp)
                    self.comments.append(come)
                    callBack(come)
                }
            }
            
        }
    }
    
}
