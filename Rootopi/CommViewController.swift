//
//  CommViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/16.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class CommViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var commentTable: UITableView!
    @IBOutlet weak var mapPin: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var favoButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var cRelease: UILabel!
    @IBOutlet weak var cKcal: UILabel!
    @IBOutlet weak var cPrice: UILabel!
    @IBOutlet weak var commImageView: UIImageView!
    @IBOutlet weak var cMaker: UILabel!
    @IBOutlet weak var cName: UILabel!
    let formatter = NSDateFormatter()
    let commentInstance = CommentManager.commentInstance
    var favoriteImage : UIImage?
    var id : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTable.registerNib(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        viewAdd()
        commentTable.delegate = self
        commentTable.dataSource = self
        updateFavorite()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let callback = { () -> Void in
            self.commentTable.reloadData()
        }
        commentInstance.fechComment(callback)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentInstance.comments.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell", forIndexPath: indexPath) as! CommentTableViewCell
        let comment = commentInstance.comments
        //let com = CommodityManager.sheradInstance.commoditys[indexPath.row]
        cell.commentLabel.text = comment[indexPath.row].comment
        //print(comment)
        return cell
    }
    
    func updateFavorite(){
        if Favorite.inFavorites(CommodityManager.sheradInstance.commoditys[Int(id!)].cName) {
            // お気に入りに入っている
            self.favoriteImage = UIImage(named: "star-on")!
            favoButton.setBackgroundImage(favoriteImage, forState: .Normal)
        } else {
            // お気に入りに入っていない
            self.favoriteImage = UIImage(named: "star-off")
            favoButton.setBackgroundImage(favoriteImage, forState: .Normal)
        }
        
    }


    
    func viewAdd(){
        //print(self.id)
        let i = Int(id!)
        formatter.dateFormat = "yyyy年MM月dd日"
        let com = CommodityManager.sheradInstance.commoditys[i]
        commImageView.image = com.photo
        cName.text = com.cName
        cPrice.text = "\(com.price)円"
        cKcal.text = "\(com.calorie)Kcal"
        //print(formatter.stringFromDate(com.day))
        let relese = formatter.stringFromDate(com.day)
        cRelease.text = relese
        cMaker.text = com.maker
        //cRelease.text = formatter.stringFromDate(com.day)

    }

    @IBAction func tapComment(sender: UIButton) {
        if (commentTextField.text?.isEmpty == nil) {
            print("", terminator: "")
        }else{
            let i = Int(id!)
            let content = commentTextField.text
            let pname = CommodityManager.sheradInstance.commoditys[i].cName
            let comment = Comment(comment: content!, pname: pname)
            comment.save()
            print("save", terminator: "")
            commentTextField.text = ""
        }
    }
    
    @IBAction func favoButtonTap(sender: UIButton) {
        //let favo: UIImage = UIImage(named: "star-on")!
        //favoButton.setBackgroundImage(favo, forState: .Normal)
        //print("favotapp")
        Favorite.toggle(CommodityManager.sheradInstance.commoditys[Int(id!)].cName)
        updateFavorite()
    }

}
