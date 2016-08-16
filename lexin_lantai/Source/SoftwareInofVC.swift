//
//  SoftwareInofVC.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/6/12.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit

class SoftwareInofVC: UIViewController {
    @IBOutlet weak var softVersonLable: UILabel!
    var versonCode = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        versionCheck()
        softVersonLable.text = "版本号 \(versonCode)"
    }
    func versionCheck(){
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let appDisplayName: AnyObject? = infoDictionary!["CFBundleDisplayName"] as! String
        let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"] as! String
        let minorVersion : AnyObject? = infoDictionary! ["CFBundleVersion"]as! String
        let iosversion : NSString = UIDevice.currentDevice().systemVersion;
        let appversion = majorVersion as! String
        
        versonCode = appversion
    //    print("appversion:\(appversion)")
    }
}
