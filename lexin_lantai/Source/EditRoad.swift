//
//  editroad.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/7/23.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit

class EditRoad: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    var newPlanName :String = ""
    
    
    var excutePlanRoads :  Array<Dictionary<String, String>> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print(excutePlanRoads)
        tableView.setEditing(true, animated: true)
    }
    @IBAction func addRoadBtn(sender: UIButton) {
        RoadMapFlag = 0
        edit_add_road_flag = 1
        
    }
    @IBAction func unwindToEditRoadVC(segue: UIStoryboardSegue) {
        
        if let RoadMapVC = segue.sourceViewController as? RoadMapVC {
            excutePlanRoads += RoadMapVC.addedRoadDetails
            self.tableView.reloadData()
            newPlanName = RoadMapVC.newPlanName
        }
    }
    
    @IBAction func sureBtnClick(sender: UIButton) {

        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return excutePlanRoads.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "EditCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EditRoadCell
        
        // Configure the cell...
        cell.editroadNameTv.text = excutePlanRoads[indexPath.row]["road"]
        return cell
    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        // 从数组中读取需要移动行的数据
        let tempRowData :Dictionary<String, String> = self.excutePlanRoads[sourceIndexPath.row]
        // 在数组中先移除需要移动行的数据
        self.excutePlanRoads.removeAtIndex(sourceIndexPath.row)
        // 把需要移动的cell数据插到到想要移动的数据前面
        self.excutePlanRoads.insert(tempRowData, atIndex: destinationIndexPath.row)
        print(excutePlanRoads)
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 先移除数据源数据
        self.excutePlanRoads.removeAtIndex(indexPath.row)
        // 再动态刷新UITableView
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
    
}
