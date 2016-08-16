//
//  ExcutePlanConfigVC.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/3/5.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit

class ExcutePlanConfigVC: UIViewController {
    @IBOutlet weak var checkbox1: SCheckBox!
    @IBOutlet weak var checkbox2: SCheckBox!
    @IBOutlet weak var checkbox3: SCheckBox!
    @IBOutlet weak var checkbox4: SCheckBox!
    
    @IBOutlet weak var checkbox5: SCheckBox!
    @IBOutlet weak var checkbox6: SCheckBox!
    @IBOutlet weak var startRoadPicker: UIPickerView!
    var excutePlanRoads :  Array<Dictionary<String, String>> = []
    var startCross = 0  //起始路口
    var fleetNum = 0
    
    var roadNamesArray :[String] = []
    var tapOrSlectedflag = -1    //触摸或者是软件选择的  0:taped   1 :softslect
    override func viewDidLoad() {
        super.viewDidLoad()
      //  print(excutePlanRoads)
        startRoadPicker.delegate = self
        startRoadPicker.dataSource = self
        
        initCheckBoxs()
        tapOrSlectedflag = 0
    }
    
    @IBAction func excutePlanButton(sender: AnyObject) {
        startCross = startRoadPicker.selectedRowInComponent(0)
        fleetNum = getFleetNum()
//        print(fleetNum)
//        print(startCross)
    }

    @IBAction func cancleExcutePlanButton(sender: AnyObject) {
        
    }
    func getFleetNum() ->Int{
        var fleetnum = 0
        let checkBoxOne:[SCheckBox] = [checkbox1,checkbox2,checkbox3,checkbox4]
        for index in 0..<checkBoxOne.count{
            if checkBoxOne[index].checked == true{
                fleetnum = index
            }
        }
        return fleetnum
    }
    func tapCheck(checkBox: SCheckBox!){
        let textlableText = checkBox.textLabel.text!
        var groupnum = 0
        if(tapOrSlectedflag == 0 ){
            if(textlableText == "保证车辆通行" || textlableText == "降低路口影响"){
                groupnum = 2
            }
            else{
                groupnum = 1
            }
            setWhichIsChecked(textlableText,checked: checkBox.checked,group: groupnum)

        }
        
    }
    
    func setWhichIsChecked(text:String,checked:Bool,group :Int){
        let checkBoxOne:[SCheckBox] = [checkbox1,checkbox2,checkbox3,checkbox4]
        let checkBoxTwo:[SCheckBox] = [checkbox5,checkbox6]
        
        var checkboxgroup:[SCheckBox] = []
        if group == 1{
            checkboxgroup = checkBoxOne
        }
        else if group == 2{
            checkboxgroup = checkBoxTwo
        }
        tapOrSlectedflag = 1
        for index in checkboxgroup{
            if index.textLabel.text! != text{
                print("yes")
                index.checked = false
            }
        }
        tapOrSlectedflag = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "excuteplanmapview"{
            let destinationController = segue.destinationViewController as! ExcutePlanVC
            destinationController.roadNameArrayList = excutePlanRoads
            destinationController.startCross = startCross
            destinationController.fleetNum = fleetNum
            //    destinationController.navigationItem.title = "摇到的菜"
            //    print("go")
        }
    }
    func initCheckBoxs(){
        self.checkbox1.color(UIColor(red: 21/255, green: 124/255, blue: 251/255, alpha: 1), forState: UIControlState.Normal)
        self.checkbox1.textLabel.text = "1-5辆"
        self.checkbox1.addTarget(self, action: "tapCheck:", forControlEvents: UIControlEvents.ValueChanged)
        self.checkbox1.checked = true
        
        self.checkbox2.color(UIColor(red: 21/255, green: 124/255, blue: 251/255, alpha: 1), forState: UIControlState.Normal)
        self.checkbox2.textLabel.text = "6-10辆"
        self.checkbox2.addTarget(self, action: "tapCheck:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.checkbox3.color(UIColor(red: 21/255, green: 124/255, blue: 251/255, alpha: 1), forState: UIControlState.Normal)
        self.checkbox3.textLabel.text = "11-15辆"
        self.checkbox3.addTarget(self, action: "tapCheck:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.checkbox4.color(UIColor(red: 21/255, green: 124/255, blue: 251/255, alpha: 1), forState: UIControlState.Normal)
        self.checkbox4.textLabel.text = "16-20辆"
        self.checkbox4.addTarget(self, action: "tapCheck:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.checkbox5.color(UIColor(red: 21/255, green: 124/255, blue: 251/255, alpha: 1), forState: UIControlState.Normal)
        self.checkbox5.textLabel.text = "保证车辆通行"
        self.checkbox5.addTarget(self, action: "tapCheck:", forControlEvents: UIControlEvents.ValueChanged)
        self.checkbox5.checked = true

        
        self.checkbox6.color(UIColor(red: 21/255, green: 124/255, blue: 251/255, alpha: 1), forState: UIControlState.Normal)
        self.checkbox6.textLabel.text = "降低路口影响"
        self.checkbox6.addTarget(self, action: "tapCheck:", forControlEvents: UIControlEvents.ValueChanged)
        
    }

}
