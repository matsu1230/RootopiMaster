//
//  CommViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/16.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit
import Parse
import Social

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
    @IBOutlet weak var stampButton: UIButton!
    //@IBOutlet weak var stampImage: UIImageView!
    @IBOutlet weak var commScrollView: UIScrollView!

    /*@IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var commentCount: UILabel!*/
    
    var myComposeView : SLComposeViewController!
    var tweetImage: UIImage?
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
    var favoriteImage : UIImage?
    var id : Int?
    var toolBar:UIToolbar!
    
    var i = 0
    var favoCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.title = "商品情報"
        self.commScrollView.showsVerticalScrollIndicator = false;

        //self.commentTextField.delegate  = self
        UIGraphicsBeginImageContext(self.size)
        let photo = UIImage(named: "twitter")
        photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //tweetButton.setBackgroundImage(resizeImage, forState: .Normal)
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
        
        view1.frame = CGRectMake(0, 200, 300, 300)
        
        view1.backgroundColor = UIColor.whiteColor()
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
            if count == 3 || count == 8 {
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
        var height : CGFloat?
        manager.fechComment(cName.text!, callBack: { comments in
            self.commentArry.append(comments)
            //self.commentTable.reloadData()
            //self.commentCount.text = "コメント(\(self.commentArry.count))件"
            height = CGFloat(self.commentArry.count * 80)
            print(height)
            //print(self.commScrollView.contentSize.height)
            }
        )
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.commentArry.count == 0 {
            return 10
        } else if (self.commentArry.count > 0 && commentArry.count < 5) {
            return commentArry.count + (5 - commentArry.count)
        } else {
            return commentArry.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell", forIndexPath: indexPath) as! CommentTableViewCell
        
        if commentArry.count != 0 && (indexPath.row < commentArry.count){
            print(indexPath.row)
            cell.commentLabel.text = commentArry[indexPath.row].comment
            UIGraphicsBeginImageContext(self.size)
            let photo = UIImage(named: imageArray[commentArry[indexPath.row].stamp])
            photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            cell.commentStamp.image = resizeImage
        }
        
        return cell
    }
    
    func updateFavorite(){
        
        if favoCount == 0 {
        let query = PFQuery(className:"P_Table")
        query.whereKey("pName", containsString: self.cName.text)
        query.getFirstObjectInBackgroundWithBlock {
            (objects: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let objects = objects {
                objects.incrementKey("rank")
                objects.saveInBackground()
            }
            
        }
            favoCount = 1
        }
        if Favorite.inFavorites(CommodityManager.sheradInstance.commoditys[Int(id!)].cName) {
            // お気に入りに入っている
            self.favoriteImage = UIImage(named: "star-on")!
            favoButton.setBackgroundImage(favoriteImage, forState: .Normal)
        } else {
            // お気に入りに入っていない
            let query = PFQuery(className:"P_Table")
            query.whereKey("pName", containsString: self.cName.text)
            query.getFirstObjectInBackgroundWithBlock {
                (objects: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let objects = objects {
                    objects.incrementKey("rank", byAmount: -1)
                    objects.saveInBackground()
                }
                
            }
            self.favoriteImage = UIImage(named: "star-off")
            favoButton.setBackgroundImage(favoriteImage, forState: .Normal)
            favoCount = 0
        }
        
    }
    
    
    
    func viewAdd(){
        let i = Int(id!)
        formatter.dateFormat = "yyyy年MM月dd日"
        let com = CommodityManager.sheradInstance.commoditys[i]
        print(com.cName)
        commImageView.image = com.photo
        //self.tweetImage = com.photo
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
            //textField(self.commentTextField, shouldChangeCharactersInRange: nil, replacementString: nil)
            comment.save()
            self.commentArry.removeAll()
            manager.fechComment(cName.text!, callBack: { comments in
                self.commentArry.append(comments)
                self.commentTable.reloadData()
                }
            )
            print(cName.text!)
            print("save", terminator: "")
            commentTextField.text = ""
            self.stampIndex = 0
            //stampImage.image = nil
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
        stampButton.setBackgroundImage(buttonImage, forState: .Normal)
        //stampImage.image = buttonImage
        self.view.endEditing(true)
        commentTextField.inputView = nil
        commentTextField.reloadInputViews()
        
    }
    
    func sortArray() {
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
    
    @IBAction func tweetButton(sender: UIButton) {
        // SLComposeViewControllerのインスタンス化.
        // ServiceTypeをTwitterに指定.
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        // 投稿するテキストを指定.
        myComposeView.setInitialText("\(self.cName.text!)\nメーカー　\(self.cMaker.text!)\nカロリー　\(self.cKcal.text!)")
        let i = Int(id!)
        // 投稿する画像を指定.
        myComposeView.addImage(CommodityManager.sheradInstance.commoditys[i].tweetImage)
        
        // myComposeViewの画面遷移.
        self.presentViewController(myComposeView, animated: true, completion: nil)
    }
    /*
    //テキスト制限
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // 文字数最大を決める.
        let maxLength: Int = 20
        
        // 入力済みの文字と入力された文字を合わせて取得.
        var tmpStr  = self.commentTextField.text! as NSString
        tmpStr = tmpStr.stringByReplacingCharactersInRange(range, withString: string)
        if tmpStr.length < maxLength {
            return true
        }
        print("文字を超えています")
        return false
    }
*/
    //戻るイベント
    override func viewWillDisappear(animated: Bool) {
        if let viewControllers = self.navigationController?.viewControllers {
            var existsSelfInViewControllers = true
            for viewController in viewControllers {
                // viewWillDisappearが呼ばれる時に、
                // 戻る処理を行っていれば、NavigationControllerのviewControllersの中にselfは存在していない
                if viewController == self {
                    existsSelfInViewControllers = false
                    // selfが存在した時点で処理を終える
                    break
                }
            }
            
            if existsSelfInViewControllers {
                print("前の画面に戻る処理が行われました")
                let subViews = self.view.subviews
                for subView in subViews {
                    subView.removeFromSuperview()
                }
                self.commentArry.removeAll()
            }
        }
        super.viewWillDisappear(animated)
    }
}
