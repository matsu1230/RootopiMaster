//
//  CommViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/16.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class CommViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{

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
    @IBOutlet weak var stampImage: UIImageView!
    
    let view1 = UIView()
    let contentView = UIView()
    let buttonImageView = UIImageView()
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    var buttonImage : UIImage!
    var width : CGFloat = 60
    var hight : CGFloat = 60
    var imageArray = ["nikori", "oisii", "bad", "bikkuri", "bimyou", "gakkari", "hutuu", "ikari", "like", "mazui", "megane", "umm", "tehe"]
    
    let formatter = NSDateFormatter()
    let commentInstance = CommentManager.commentInstance
    var favoriteImage : UIImage?
    var id : Int?
    var toolBar:UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTable.registerNib(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        viewAdd()
        
        //キーボーど用
        let myKeyboard = UIView(frame: CGRectMake(0, 0, 320, 40))
        myKeyboard.backgroundColor = UIColor.darkGrayColor()
        
        
        // Doneボタン作成
        let myButton = UIButton(frame: CGRectMake(250, 5, 80, 30))
        let stampButton = UIButton(frame: CGRectMake(5,5, 90, 30))
        let keyButton = UIButton(frame: CGRectMake(100,5, 100, 30))
        myButton.backgroundColor = UIColor.lightGrayColor()
        stampButton.backgroundColor = UIColor.lightGrayColor()
        keyButton.backgroundColor = UIColor.lightGrayColor()
        myButton.setTitle("閉じる", forState: UIControlState.Normal)
        stampButton.setTitle("スタンプ", forState: UIControlState.Normal)
        keyButton.setTitle("キーボード", forState: UIControlState.Normal)
        myButton.addTarget(self, action: "onMyButton", forControlEvents: UIControlEvents.TouchUpInside)
        stampButton.addTarget(self, action: "stampAdd", forControlEvents: UIControlEvents.TouchUpInside)
        keyButton.addTarget(self, action: "keyBoardTap", forControlEvents: UIControlEvents.TouchUpInside)
        myKeyboard.addSubview(stampButton)
        myKeyboard.addSubview(keyButton)
        myKeyboard.addSubview(myButton)
        
        commentTextField .inputAccessoryView = myKeyboard
        commentTextField.delegate = self
        
        //self.view.addSubview(myTextfiled)
        
        view1.frame = CGRectMake(0, 200, 400, 300)
        //contentView.frame = CGRectMake(0, 200, 400, 300)
        
        view1.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var count = 0
        for var  i = 0; i < imageArray.count; i++ {
            let button = UIButton()
            button.frame = CGRectMake(x, y,self.width, self.hight)
            button.tag = i
            self.buttonImage = UIImage(named: imageArray[i])
            button.setBackgroundImage(buttonImage, forState: .Normal)
            button.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchDown)
            view1.addSubview(button)
            if count == 4 || count == 9 {
                x = 0
                y += 80
            } else {
                x += 75
            }
            count++
        }

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
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        commentTextField.resignFirstResponder()
    }

    func onClick(sender : UIButton) {
        //let subviews = self.view.subviews
        
        buttonImage = UIImage(named: imageArray[sender.tag])
        buttonImageView.image = buttonImage
        stampImage.image = buttonImage
        self.view.endEditing(true)
        commentTextField.inputView = nil
        commentTextField.reloadInputViews()
        
    }
    
    func onMyButton () {
        self.view.endEditing(true )
    }
    
    func stampAdd() {
        commentTextField.inputView = view1
        commentTextField.reloadInputViews()
    }
    
    func keyBoardTap(){
        commentTextField.inputView = nil
        commentTextField.reloadInputViews()
    }
}
