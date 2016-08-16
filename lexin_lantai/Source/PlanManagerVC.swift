//
//  PlanManagerVC.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/2/29.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit
import CoreData

class PlanManagerVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    /// CoreData connection variable
    let coreDataDB = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var items = [Plans]()   //数据库中读取的内容
    var selectRowAtIndexPath : Int = -1 // 列表选择的行标
    var excutePlanDetails:Array<Dictionary<String, String>> = []  //选中的列表的路口详情
    var swapRow = 0

 //   var recentRoadArray:[Recent] = []
    @IBOutlet weak var roadListView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        items = Plans.fetchAll(coreDataDB)
//        for index in items{
//            print("db:\(index.planNum)")
//            print("db:\(index.planName)")
//            print("db:\(index.roadNum)")
//            print("db:\(index.planDetails)")
//            
//        }
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OneRoadCell
        
        // Configure the cell...
        cell.planNumLabel.text = items[indexPath.row].planNum
        cell.planNameLabel.text = items[indexPath.row].planName
        cell.roadNumLabel.text = items[indexPath.row].roadNum

        return cell
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteSwipteButton = UITableViewRowAction(style: .Normal, title: "Delete") { (action, indexPath) in
            // Find item
            let itemDelete = self.items[indexPath.row]
            
            // Delete item in CoreData
            itemDelete.destroy(self.coreDataDB)
            
            // Save item
            itemDelete.save(self.coreDataDB)
            
            // Tableview always load data from "items" array.
            // If you delete a item from CoreData you need reload array data.
            self.items = Plans.fetchAll(self.coreDataDB)
            
            // Remove item from TableView
            self.roadListView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        let edit = UITableViewRowAction(style: .Normal, title: "edit") { (action, indexPath) in
            // Find item
//            let itemDelete = self.items[indexPath.row]
//            
//            // Delete item in CoreData
//            itemDelete.destroy(self.coreDataDB)
//            
//            // Save item
//            itemDelete.save(self.coreDataDB)
//            
//            // Tableview always load data from "items" array.
//            // If you delete a item from CoreData you need reload array data.
//            self.items = Plans.fetchAll(self.coreDataDB)
//            
//            // Remove item from TableView
//            self.roadListView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      /*
            let myStoryBoard = self.storyboard
            let anotherView = (myStoryBoard?.instantiateViewControllerWithIdentifier("editroadSD"))! as UIViewController
            self.navigationController!.pushViewController(anotherView, animated:true)
--*/
            
            self.swapRow = indexPath.row
            self.performSegueWithIdentifier("editroadvc", sender: self)

//            self.presentViewController(anotherView, animated: true, completion: nil)
            
        }
        edit.backgroundColor = UIColor.grayColor()
        deleteSwipteButton.backgroundColor = UIColor.redColor()
        
        return [deleteSwipteButton,edit]
    }
    // Allow edit cell in TableView
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectRowAtIndexPath = indexPath.row
    }
    @IBAction func unwindToPlanManagerVC(segue: UIStoryboardSegue) {
        if let RoadMapVC = segue.sourceViewController as? RoadMapVC {
            //获取当前时间
            let now = NSDate()
            let dateFormatter2 = NSDateFormatter()
            dateFormatter2.dateFormat = "yyMMddmmss"
            // Date 转 String
            RoadMapVC.newPlanNum = dateFormatter2.stringFromDate(now)
            RoadMapVC.newPlanDetails = toJSONString(RoadMapVC.addedRoadDetails)
//            RoadMapVC.newPlanDetails =  RoadMapVC.newPlanDetails.stringByReplacingOccurrencesOfString(" ", withString: "")
//            RoadMapVC.newPlanDetails =  RoadMapVC.newPlanDetails.stringByReplacingOccurrencesOfString("\r", withString: "")
//            RoadMapVC.newPlanDetails =  RoadMapVC.newPlanDetails.stringByReplacingOccurrencesOfString("\n", withString: "")
//            RoadMapVC.newPlanDetails =  RoadMapVC.newPlanDetails.stringByReplacingOccurrencesOfString("\t", withString: "")
            
//            print("newPlanDetails:\( RoadMapVC.newPlanDetails)")
           
            // Use class "Item" to create a new CoreData object
            // plannum : String,planname:String,plandetails:String,roadnum :String
            
            let newItem = Plans(plannum: RoadMapVC.newPlanNum, planname: RoadMapVC.newPlanName, plandetails: RoadMapVC.newPlanDetails, roadnum: String(RoadMapVC.addedRoadDetails.count), inManagedObjectContext: self.coreDataDB)
            
            self.items.append(newItem)// Add item to array
            newItem.save(self.coreDataDB)// CoreData save
            self.items = Plans.fetchAll(self.coreDataDB)// Reload Coredata data
            self.roadListView.reloadData() // Reload TableView
        }else if let editroad = segue.sourceViewController as? EditRoad{
           
            
            let itemDelete = self.items[swapRow]
            
            // Delete item in CoreData
            itemDelete.destroy(self.coreDataDB)
            
            // Save item
            itemDelete.save(self.coreDataDB)
            
            // Tableview always load data from "items" array.
            // If you delete a item from CoreData you need reload array data.
            self.items = Plans.fetchAll(self.coreDataDB)
            
            // Remove item from TableView
//            self.roadListView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            //获取当前时间
            let now = NSDate()
            let dateFormatter2 = NSDateFormatter()
            dateFormatter2.dateFormat = "yyMMddmmss"
            // Date 转 String
            let newPlanNum:String = dateFormatter2.stringFromDate(now)
            let newPlanDetails = toJSONString(editroad.excutePlanRoads)
            
            let newItem = Plans(plannum: newPlanNum, planname: editroad.newPlanName, plandetails: newPlanDetails, roadnum: String(editroad.excutePlanRoads.count), inManagedObjectContext: self.coreDataDB)
            
            self.items.append(newItem)// Add item to array
            newItem.save(self.coreDataDB)// CoreData save
            self.items = Plans.fetchAll(self.coreDataDB)// Reload Coredata data
            self.roadListView.reloadData() // Reload TableView
            
            
            
        }
    }
    /**
     ＊  新建方案  设置为添加路口模式
     */
    @IBAction func addPlanBtn(sender: UIButton) {
        RoadMapFlag = 0   //添加路口模式
        edit_add_road_flag = 0
    }
    /**
     ＊  执行方案
     */
    @IBAction func excutePlan(sender: UIButton) {
        if selectRowAtIndexPath == -1{
            showWarningAlert()
        }
        else{
            self.performSegueWithIdentifier("excuteplanconfigvc", sender: self)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  //      print("标签：\(segue.identifier)")
        if segue.identifier! == "excuteplanconfigvc"{
            let destinationController = segue.destinationViewController as! ExcutePlanConfigVC
            let excutePlanDetails : String = items[selectRowAtIndexPath].planDetails!
//            if recentRoadArray.count > 0{
//                for index in 0..<recentRoadArray.count{
//                    if items[selectRowAtIndexPath].planName == recentRoadArray[index].name{
//                       notadd = 1
//                    }
//                }
//                if notadd != 1{
//                    if recentRoadArray.count > 2 {
//                        recentRoadArray[0].destroy(self.coreDataDB)
//                    }
//                    let new  = Recent(name:items[selectRowAtIndexPath].planName!, inManagedObjectContext: self.coreDataDB)
//                    self.recentRoadArray.append(new)
//                    new.save(self.coreDataDB)// CoreData save
//                }
//            }
//            else{
//                let new  = Recent(name:items[selectRowAtIndexPath].planName!, inManagedObjectContext: self.coreDataDB)
//                self.recentRoadArray.append(new)
//                new.save(self.coreDataDB)// CoreData save
//
//            }
            destinationController.excutePlanRoads =  jsonstringToArray(excutePlanDetails)  //传递值
        }
        else if segue.identifier! == "addplan"{
        
        }else if segue.identifier! == "editroadvc"{
    
            let destinationController = segue.destinationViewController as! EditRoad
            let excutePlanDetails : String = items[swapRow].planDetails!
            destinationController.excutePlanRoads =  jsonstringToArray(excutePlanDetails)  //传递值
            destinationController.newPlanName = items[swapRow].planName!

        }
//            destinationController.tempCaipin = self.showArray //传值
        
    }
    func jsonstringToArray(jsonstring:String)-> Array<Dictionary<String, String>>{
        let data = jsonstring.dataUsingEncoding(NSUTF8StringEncoding)
        
        let jsonArr = try! NSJSONSerialization.JSONObjectWithData(data!,
            options: NSJSONReadingOptions.MutableContainers) as!  Array<Dictionary<String, String>>
//        print("记录数：\(jsonArr)")
//        for json in jsonArr {
//            print("orientation：", json.objectForKey("orientation")!, "    road：", json.objectForKey("road")!)
//        }
        return jsonArr
    }
    func toJSONString(dict:Array<Dictionary<String, String>>!)->String{
        
        let data = try? NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
        
        let strJson = NSString(data: data!, encoding: NSUTF8StringEncoding)
        print("strJson--->\(strJson)")
        return strJson! as String
    }
    func showWarningAlert(){
        let alertcontroller = UIAlertController(title: "请选择要执行的线路", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "好的", style: .Default,
            handler: {
                action in
//                print("点击了确定")
        })
        alertcontroller.addAction(okAction)
        self.presentViewController(alertcontroller, animated: true, completion: { () -> Void in
            
        })
    }

}
