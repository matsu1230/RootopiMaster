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
    

    func fechComment(callBack: () -> Void) {
        let query = PFQuery(className: "C_Table")
        query.orderByDescending("createdAt")
        //let queryKeyname : String = CommentManager.pName as String
        //print(queryKeyname)
        //query.whereKey("pName", containsString: queryKeyname)
        query.findObjectsInBackgroundWithBlock{ (comments, error) -> Void in
            if error == nil{
                self.comments = []
                for comment in comments! {
                    let content = comment["comment"] as! String
                    //print(content)
                    let pname = comment["pname"]as! String
                    let come = Comment(comment: content, pname: pname)
                    self.comments.append(come)
                    callBack()
                }
            }
            
        }
    }
    
}
