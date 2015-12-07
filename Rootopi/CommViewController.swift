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
    @IBOutlet weak var commentTableView: UIView!
    @IBOutlet weak var cRelease: UILabel!
    @IBOutlet weak var cKcal: UILabel!
    @IBOutlet weak var cPrice: UILabel!
    @IBOutlet weak var commImageView: UIImageView!
    @IBOutlet weak var cMaker: UILabel!
    @IBOutlet weak var cName: UILabel!
    @IBOutlet weak var stampImage: UIImageView!
    //@IBOutlet weak var commentScrollView: UIScrollView!
    //@IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commScrollView: UIScrollView!
    
    
    let view1 = UIView()
    let refreshControl = UIRefreshControl()
    let contentView = UIView()
    let buttonImageView = UIImageView()
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    var buttonImage : UIImage!
    var stampIndex : Int?
    var width : CGFloat = 60
    var hight : CGFloat = 60
    let size = CGSize(width: 50, height: 50)
    var imageArray = ["nikori", "oisii", "bad", "bikkuri", "bimyou", "gakkari", "hutuu", "ikari", "like", "mazui", "megane", "umm", "tehe"]
    
    var barcode : String?
    
    let formatter = NSDateFormatter()
    let manager = CommentManager()
    let commodityManager = CommodityManager()
    var commentArry : Array<Comment> = []
    var commArray: Array<Commodity>?
    //let commentInstance = CommentManager.ommentInstance
    var favoriteImage : UIImage?
    var id : Int?
    var toolBar:UIToolbar!
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.id)
        commentTable.registerNib(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        //キーボーど用
        let myKeyboard = UIView(frame: CGRectMake(0, 0, 320, 40))
        myKeyboard.backgroundColor = UIColor.darkGrayColor()
        
        viewAdd()

        // 下記を追加
        refreshControl.addTarget(self, action: Selector("sortArray"), forControlEvents: UIControlEvents.ValueChanged)
        commentTable.addSubview(refreshControl)
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
        
        view1.frame = CGRectMake(0, 200, 400, 300)
        
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
        //commentTable.refreshControl
        updateFavorite()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var height : CGFloat?
        manager.fechComment(cName.text!, callBack: { comments in
            self.commentArry.append(comments)
            self.commentTable.reloadData()
            height = CGFloat(self.commentArry.count * 80)
            print(height)
            print(self.commScrollView.contentSize.height)
            }
        )
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArry.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell", forIndexPath: indexPath) as! CommentTableViewCell
        cell.commentLabel.text = commentArry[indexPath.row].comment
        UIGraphicsBeginImageContext(self.size)
        let photo = UIImage(named: imageArray[commentArry[indexPath.row].stamp])
        photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        cell.commentStamp.image = resizeImage
        
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
            let i = Int(id!)
            formatter.dateFormat = "yyyy年MM月dd日"
            let com = CommodityManager.sheradInstance.commoditys[i]
            print(com.cName)
            commImageView.image = com.photo
            cName.text = com.cName
            cPrice.text = "\(com.price)円"
            cKcal.text = "\(com.calorie)Kcal"
            let relese = formatter.stringFromDate(com.day)
            cRelease.text = relese
            cMaker.text = com.maker
    }
    

@IBAction func tapComment(sender: UIButton) {
    if (commentTextField.text?.isEmpty == nil) {
        print("", terminator: "")
    }else{
        if id != nil {
            i = Int(id!)
        }
        var content = commentTextField.text
        if content == nil {
            content = " "
        }
        
        if stampIndex == nil {
            stampIndex = 0
        }
        let pname = CommodityManager.sheradInstance.commoditys[i].cName
        let comment = Comment(comment: content!, pname: pname, stamp: self.stampIndex!)
        comment.save()
        //sleep(1)
        //sortArray()
        manager.fechComment(cName.text!, callBack: { comments in
            self.commentArry.append(comments)
            self.commentTable.reloadData()
            }
        )
        print(cName.text!)
        print("save", terminator: "")
        commentTextField.text = ""
        stampImage.image = nil
    }
}

@IBAction func favoButtonTap(sender: UIButton) {
    Favorite.toggle(CommodityManager.sheradInstance.commoditys[Int(id!)].cName)
    updateFavorite()
}

func tappedToolBarBtn(sender: UIBarButtonItem) {
    commentTextField.resignFirstResponder()
}

func onClick(sender : UIButton) {
    buttonImage = UIImage(named: imageArray[sender.tag])
    self.stampIndex = sender.tag
    buttonImageView.image = buttonImage
    stampImage.image = buttonImage
    self.view.endEditing(true)
    commentTextField.inputView = nil
    commentTextField.reloadInputViews()
    
}

func sortArray() {
    //self.viewDidAppear(true)
    self.commentArry.removeAll()
    manager.fechComment(cName.text!, callBack: { comments in
        self.commentArry.append(comments)
        self.commentTable.reloadData()
        print(self.commentArry.count)
        print(self.commScrollView.contentSize.height)
        self.refreshControl.endRefreshing()
        }
    )
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
