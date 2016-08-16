//
//  ViewControllerExtension.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/3/5.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit
extension ExcutePlanConfigVC:UIPickerViewDataSource{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return excutePlanRoads.count
    }
}
extension ExcutePlanConfigVC:UIPickerViewDelegate{
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return   excutePlanRoads[row]["road"]

    }
    
}



