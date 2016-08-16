//
//  PswVC.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/6/12.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit
class PswVC: UIViewController {
    
    var Count = 0 //计时变量
    var Timer = NSTimer() //
    var Playing = false  //计时状态＝否
    
    @IBOutlet weak var warringText: UILabel!
    @IBOutlet weak var PSWVIEW: SetPassWordView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let coreDataDB = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var psdItems      = [Recent]()   //数据库中读取的内容
        psdItems = Recent.fetchAll(coreDataDB)
        
        var psdNum = "087396"
        if  psdItems.count>0{
            psdNum = psdItems[0].name!
            print("psdItems: \(psdNum)")
        }  
        PSWVIEW.doneAction = {(text) -> () in
            if text == psdNum {
                print(text)
                let myStoryBoard = self.storyboard
                let anotherView = (myStoryBoard?.instantiateViewControllerWithIdentifier("ViewController1"))! as UIViewController
                self.presentViewController(anotherView, animated: true, completion: nil)
            }
            else{
                self.warringText.text = "您输入的密码有误！"
                self.warringText.textColor = UIColor.redColor()
                self.PlayBP()
            }

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func ResetBP() { //按下RESET按钮
        Timer.invalidate() //停止计时器
        Playing = false  //计时状态 变为 否
        Count = 0 //计时变量归零
        
    }
    
    func PlayBP() {  //按下开始按钮
        
        if (Playing) {
            return
        }//如果 还在计时，return

        
        Timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector:"UpdateTimer", userInfo: nil, repeats: true)
        //0.01是最小时间间隔，"UpdateTimer"是自己写的时间函数（在后面）
        
        Playing = true  //计时状态 变为 是
    }
    
    func PauseBP() {//按下暂停按钮
        Timer.invalidate()  //计时器停止
        Playing = false     //计时状态 变为 否
    }
    
    func UpdateTimer() {    //计时函数
        Count = Count + 1    //每个间隔，Count＋0.01
      //  print(Count)
        if  Int(self.Count) > 300 {
            self.ResetBP()
            self.warringText.text = "请输入密码"
            self.warringText.textColor = UIColor.blackColor()
        }
     //   TimeLabel.text = String(format:"%.2f",Count)    //数字显示屏上显示小数点后两位的时间
    }

}

