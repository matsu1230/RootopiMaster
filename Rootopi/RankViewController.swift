//
//  RankViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/12/11.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class RankViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var rankSegment: UISegmentedControl!
    @IBOutlet weak var rankTable: UITableView!
    
    let commodity = CommodityManager.sheradInstance
    let manager = CommodityManager()
    var segmentImage = UIImage(named: "fav")
    var rankArray : Array<Commodity> = []
    var rankingArray : [Int] = []
    var segmentId = 0
    var rank = 1
    var rankCount: Int!
    var count = 0
    var id : Int!
    var selectedRow : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        rankTable.registerNib(UINib(nibName: "RankTableViewCell", bundle: nil), forCellReuseIdentifier: "RankTableViewCell")
        self.rankTable.delegate = self
        self.rankTable.dataSource = self
        rankSegment.addTarget(self, action: "segconChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        if segmentId == 0 {
        manager.serchRanl((callBack: { ranks in
            self.rankArray = ranks
            if self.rankArray.count == 10 {
                self.sortRank()
                self.rank = 1
            }
            }
        ))
        } else {
            //self.rankingArray.removeAll()
            manager.serchView((callBack: { ranks in
                self.rankArray = ranks
                if self.rankArray.count == 10 {
                    self.sortRank()
                    self.rank = 1
                }
                }
            ))
        }
    }
    
    func segconChanged(segcon: UISegmentedControl){
        //self.rankArray.removeAll()
        switch segcon.selectedSegmentIndex {
        case 0:
            self.rankingArray.removeAll()
            print("お気に入り")
            self.segmentImage = UIImage(named: "fav")
            manager.serchRanl((callBack: { ranks in
                //print(ranks)
                self.rankArray = ranks
                if self.rankArray.count == 10 {
                    self.sortRank()
                    self.rank = 1
                }
                }
            ))
            segmentId = 0
        case 1:
            self.rankingArray.removeAll()
            self.segmentImage = UIImage(named: "eye")
            manager.serchView((callBack: { ranks in
                self.rankArray = ranks
                if self.rankArray.count == 10 {
                    self.sortRank()
                    self.rank = 1
                }
                }
            ))
            segmentId = 1
        default:
            print("Error")
        }
    }
    
    func sortRank(){
        self.rankArray.sortInPlace { (a, b) -> Bool in
            return a.rank > b.rank
        }

        for var i = 0; i < self.rankArray.count; i++ {
                    print(self.rankArray[i].rank)
            for var j = 0; j < self.rankArray.count; j++ {
            if self.rankArray[i].rank < self.rankArray[j].rank{
                rank += 1
                }
            }
            self.rankingArray.append(rank)
            rank = 1
        }
        self.rankTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rankArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RankTableViewCell", forIndexPath: indexPath) as! RankTableViewCell
        cell.rankCount.text = "\(rankArray[indexPath.row].rank)"
        cell.rankSegumentImage.image = self.segmentImage
        cell.rankNumber.text = "\(rankingArray[indexPath.row])"
        cell.rankImage.image = rankArray[indexPath.row].photo
        cell.rankName.text = rankArray[indexPath.row].cName
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        print(rankArray[self.selectedRow!].cName)
        for var i = 0; i < commodity.commoditys.count; i++ {
            print(commodity.commoditys[i].cName)
            if (rankArray[self.selectedRow!].cName == commodity.commoditys[i].cName) {
                self.id = i
                print(self.id)
            }
        }
        performSegueWithIdentifier("fromRank", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromRank" {
            let comVC : CommViewController = segue.destinationViewController as! CommViewController
            print(self.id)
            comVC.id = self.id
        }
    }

    
}
