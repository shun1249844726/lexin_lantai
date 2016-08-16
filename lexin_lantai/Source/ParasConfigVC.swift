//
//  ParasConfigVC.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/2/29.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit

class ParasConfigVC: UIViewController {
//    var FleetLength = 5     // 车队长度
//    var FleetSpacing = 15   //车队间距
//    var SendDistance = 400  //命令发送距离
    
    
    @IBOutlet weak var fleetLengthLable: UILabel!
    @IBOutlet weak var fleetSpacingLable: UILabel!
    @IBOutlet weak var sendDistanceLable: UILabel!
    @IBAction func fleetLengthSlider(sender: UISlider) {
        FleetLength = Int(sender.value)
        fleetLengthLable.text = String(FleetLength)
    }
    @IBAction func senddistanceSlider(sender: UISlider) {
        SendDistance = Int(sender.value)
        sendDistanceLable.text = String(SendDistance)

    }
    @IBAction func fleetSpacingSlider(sender: UISlider) {
        FleetSpacing = Int(sender.value)
        fleetSpacingLable.text = String(FleetSpacing)

    }
    @IBAction func offlineMapManager(sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
