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
    
    let manager = CommodityManager()
    var rankArray : Array<Commodity> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rankTable.registerNib(UINib(nibName: "RankTableViewCell", bundle: nil), forCellReuseIdentifier: "RankTableViewCell")
        self.rankTable.delegate = self
        self.rankTable.dataSource = self
        rankSegment.addTarget(self, action: "segconChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        manager.serchRanl((callBack: { ranks in
            print(ranks)
            self.rankArray = ranks
            self.rankArray.sortInPlace { (a, b) -> Bool in
                return a.rank > b.rank
            }
            self.rankTable.reloadData()
    
            }
        ))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segconChanged(segcon: UISegmentedControl){
        self.rankArray.removeAll()
        switch segcon.selectedSegmentIndex {
        case 0:

            print("お気に入り")
            manager.serchRanl((callBack: { ranks in
                print(ranks)
                self.rankArray = ranks
                self.rankArray.sortInPlace { (a, b) -> Bool in
                    return a.rank > b.rank
                }
                self.rankTable.reloadData()

                }
            ))
        case 1:

            print("閲覧数")
            manager.serchView((callBack: { ranks in
                print(ranks)
                self.rankArray = ranks
                self.rankArray.sortInPlace { (a, b) -> Bool in
                    return a.rank > b.rank
                }
                self.rankTable.reloadData()
                
                }
            ))
        default:
            print("Error")
        }
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
        cell.rankImage.image = rankArray[indexPath.row].photo
        cell.rankName.text = rankArray[indexPath.row].cName
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
