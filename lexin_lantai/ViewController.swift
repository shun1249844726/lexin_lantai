//
//  ViewController.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/1/28.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var times:Int = 0
    
    @IBAction func planmanager(sender: UIButton) {
        self.performSegueWithIdentifier("planmanagervc", sender: self)

    }
    @IBAction func RecentOne(sender: UIButton) {
        self.performSegueWithIdentifier("planmanagervc", sender: self)
    }
    @IBAction func RecentTwo(sender: UIButton) {
        self.performSegueWithIdentifier("planmanagervc", sender: self)

    }
    @IBAction func RecentThree(sender: UIButton) {
        self.performSegueWithIdentifier("planmanagervc", sender: self)

    }
    @IBOutlet weak var RecentOneLable: UIButton!
    @IBOutlet weak var RecentTwoLable: UIButton!
    @IBOutlet weak var RecentThreeLable: UIButton!
    var recentLables : [UIButton] = []
    /// CoreData connection variable
    let coreDataDB = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var items      = [Plans]()   //数据库中读取的内容
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        items = Plans.fetchAll(coreDataDB)
//        let new = Recent(name: "11", inManagedObjectContext: self.coreDataDB)
//        new.save(self.coreDataDB)
//        
        recentLables.append(RecentOneLable)
        recentLables.append(RecentTwoLable)
        recentLables.append(RecentThreeLable)
        
        if items.count<3{
            for index in 0..<items.count{
                recentLables[index].setTitle(items[index].planName, forState: UIControlState.Normal)
            }
        }
        else{
            for index in 0..<3{
                recentLables[index].setTitle(items[index].planName, forState: UIControlState.Normal)
            }
        }

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func openRoadMapView(sender: UIButton) {
        RoadMapFlag = 1
    }
    @IBOutlet var testText: UILabel!
    @IBAction func exitsoftwareBtn(sender: AnyObject) {
        
        let alertVC = UIAlertController(title: "提示", message: "您确定要退出软件？", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
             exit(0)
        }
        let alertAction1 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertVC.addAction(alertAction)
        alertVC.addAction(alertAction1)
        self .presentViewController(alertVC, animated: true, completion: nil)
    }
    func getData(){//读取配置文件
      //  let jsonData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("LanTaiRoads", ofType: "geojson")!)
        let mydir1 = NSHomeDirectory() + "/Documents/"
        let url: NSURL = NSURL(fileURLWithPath: mydir1+"LanTaiRoads.geojson")
        
        let jsonData = try NSData(contentsOfFile: url.path!)
        if jsonData != nil {
            let json = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options:NSJSONReadingOptions.AllowFragments)
            if NSJSONSerialization.isValidJSONObject(json!){

                RoadsArray = json! as? Array<Dictionary<String, String>>
                RoadNum = RoadsArray!.count
            }
            else {
                showMessage("1.请先添加地图信息！")
    
            }
        }
        else{
            showMessage("2.请先添加地图信息！")

        }

    }
    func showMessage(message:String){
        let alertController = UIAlertController(title: "提示", message:message , preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){
            (action: UIAlertAction!) -> Void in
                let myStoryBoard = self.storyboard
                let anotherView = (myStoryBoard?.instantiateViewControllerWithIdentifier("inportFileSb"))! as UIViewController
                self.navigationController!.pushViewController(anotherView, animated:true)
            })
        self.presentViewController(alertController, animated: true) { () -> Void in
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "planmanagervc"{
            
            let destinationController = segue.destinationViewController as! PlanManagerVC
      //      destinationController.recentRoadArray = items
        }
    }
}

