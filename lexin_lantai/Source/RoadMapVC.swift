//
//  RoadMapVC.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/2/15.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit

class RoadMapVC: UIViewController , BMKMapViewDelegate , BMKLocationServiceDelegate, UIAlertViewDelegate{
    @IBOutlet weak var _mapView: BMKMapView!
    var pointAnnotation: BMKPointAnnotation?
    var locationService: BMKLocationService!
    var count = 0

    @IBOutlet weak var planname: UITextField!
    
    @IBOutlet weak var savePlanButton: UIBarButtonItem!
    @IBOutlet weak var slectedRoadTV: UITextView!

    @IBOutlet weak var chexiaobtn: UIButton!
    
    var newPlanName:String = ""
    var newPlanDetails:String = ""
    var newPlanNum:String = ""
    
    var addedRoadDetails:Array<Dictionary<String, String>> = []
    
    var clickedRoadName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(Double(RoadsArray![0]["Latitude"]!)!,Double(RoadsArray![0]["Longitude"]!)!)

        locationService = BMKLocationService()
        locationService.allowsBackgroundLocationUpdates = false
//        print("罗盘定位状态");
        locationService.startUserLocationService()
        _mapView!.showsUserLocation = false//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollow//设置定位的状态
        _mapView!.showsUserLocation = true//显示定位图层
        _mapView.zoomLevel = 13
    }
    
    /**
     *撤销一步
     *
     **/
    @IBAction func chexiao(sender: UIButton) {
        print("addedRoadDetails长度:\(addedRoadDetails.count)")
        if addedRoadDetails.count >= 1{
            addedRoadDetails.removeAtIndex(addedRoadDetails.count-1)
            slectedRoadTV.text=""
            print("addedRoadDetails:\(addedRoadDetails)")
            for index in addedRoadDetails{
                slectedRoadTV.text = slectedRoadTV.text+index["road"]!+"  "+index["orientation"]!+"\n"
            }
        }
    }
    /**
    *保存所选方案
    *
    **/
    @IBAction func savePlan(sender: UIBarButtonItem) {
        print("click")
        if planname.text != ""{
            if edit_add_road_flag == 1{  //编辑模式添加
                performSegueWithIdentifier("unwindToEditRoad", sender: self)
            }else {
                performSegueWithIdentifier("unwindtoPlanManager", sender: self)
            }
        }
        else {
            showMessage()
        }
    }    
    @IBAction func finishEdit(sender: UITextField) {
        savePlanButton.enabled = true
        newPlanName = planname.text!
        print("输入完毕")

        self.planname.resignFirstResponder()
        
    }

    func showMessage(){
        let alertController = UIAlertController(title: "提示", message: "请输入方案名称！", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true) { () -> Void in
            
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationService.delegate = self
        _mapView?.delegate = self
        _mapView?.viewWillAppear()
        viewsShowOrHidden()
        slectedRoadTV.text = ""
        slectedRoadTV.hidden = true
        chexiaobtn.hidden = true
        
    }
    /**
     *地图上面的控件的显示与否，
     *
     */
    func viewsShowOrHidden(){
        //查看路口地图：1    添加方案 ：0
        var hiddenOrNot:Bool = false
        if RoadMapFlag == 0{
            hiddenOrNot = false  //
        }
        else if RoadMapFlag == 1{
            hiddenOrNot = true
        }
        slectedRoadTV.hidden = hiddenOrNot
        planname.hidden = hiddenOrNot
        savePlanButton.enabled = false
        chexiaobtn.hidden = hiddenOrNot

    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locationService.delegate = self
        _mapView?.delegate = nil
        _mapView?.viewWillDisappear()
        RoadMapFlag = -1
    }
    
    // MARK: - BMKMapViewDelegate
    
    /**
    *地图初始化完毕时会调用此接口
    *@param mapview 地图View
    */
    func mapViewDidFinishLoading(mapView: BMKMapView!) {
        addPointAnnotation()
    }
    
    // MARK: - 添加自定义手势 （若不自定义手势，不需要下面的代码）
    func addCustomGesture() {
        /*
        *注意：
        *添加自定义手势时，必须设置UIGestureRecognizer的cancelsTouchesInView 和 delaysTouchesEnded 属性设置为false，否则影响地图内部的手势处理
        */
        let tapGesturee = UITapGestureRecognizer(target: self, action: Selector("handleSingleTap:"))
        tapGesturee.cancelsTouchesInView = false
        tapGesturee.delaysTouchesEnded = false
        self.view.addGestureRecognizer(tapGesturee)
    }
    
    func handleSingleTap(tap: UITapGestureRecognizer) {
        NSLog("custom single tap handle")
    }
    
    // MARK: - BMKMapViewDelegate
    
    
    // MARK: - BMKLocationServiceDelegate
    
    /**
    *在地图View将要启动定位时，会调用此函数
    *@param mapView 地图View
    */
    func willStartLocatingUser() {
        print("willStartLocatingUser");
    }
    
    /**
     *用户方向更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
      //  print("heading is \(userLocation.heading)")
        _mapView!.updateLocationData(userLocation)
    }
    
    /**
     *用户位置更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
//        print("didUpdateUserLocation lat:\(userLocation.location.coordinate.latitude) lon:\(userLocation.location.coordinate.longitude)")
        _mapView!.updateLocationData(userLocation)
    }

    /**
     *在地图View停止定位后，会调用此函数
     *@param mapView 地图View
     */
    func didStopLocatingUser() {
        print("didStopLocatingUser")
    }
    /**
     *添加标注
     *    markerTitle:珠江路-金桥路,longitudt:121.08115,latitude:32.056603
     */
    func addPointAnnotation(){
        var longitudt:Double = 0
        var latitude:Double = 0
        var markerTitle:String = ""
        
        
        if pointAnnotation == nil{
            for oneRoad in RoadsArray!{
                count++
                if oneRoad["Longitude"] != nil{
                    longitudt = Double(oneRoad["Longitude"]!)!
                    latitude = Double(oneRoad["Latitude"]!)!
                    markerTitle = oneRoad["RoadName"]!

                    let coor = CLLocationCoordinate2DMake(latitude, longitudt)
                    //坐标转换，GPS坐标转百度地图坐标
                    let testdic = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS)
                    
                    pointAnnotation = BMKPointAnnotation()
                    pointAnnotation?.coordinate = BMKCoorDictionaryDecode(testdic)
                    pointAnnotation?.title = markerTitle
                    
                    _mapView.addAnnotation(pointAnnotation)
                }
            }
        }
    }
    
    /**
     *当mapView新添加annotation views时，调用此接口
     *@param mapView 地图View
     *@param views 新添加的annotation views
     */
    func mapView(mapView: BMKMapView!, didAddAnnotationViews views: [AnyObject]!) {
      //  NSLog("didAddAnnotationViews")
    }
    
    /**
     *当选中一个annotation views时，调用此接口
     *@param mapView 地图View
     *@param views 选中的annotation views
     */
    func mapView(mapView: BMKMapView!, didSelectAnnotationView view: BMKAnnotationView!) {
        

        clickedRoadName = RoadsArray![view.tag-1]["RoadName"]!
        NSLog("选中了标注:\(view.tag);clickedRoadName:\(clickedRoadName)")
    }
    /**
     *当取消选中一个annotation views时，调用此接口
     *@param mapView 地图View
     *@param views 取消选中的annotation views
     */
    func mapView(mapView: BMKMapView!, didDeselectAnnotationView view: BMKAnnotationView!) {
        NSLog("取消选中标注")
    }
    
    /**
     *拖动annotation view时，若view的状态发生变化，会调用此函数。ios3.2以后支持
     *@param mapView 地图View
     *@param view annotation view
     *@param newState 新状态
     *@param oldState 旧状态
     */
    func mapView(mapView: BMKMapView!, annotationView view: BMKAnnotationView!, didChangeDragState newState: UInt, fromOldState oldState: UInt) {
        NSLog("annotation view state change : \(oldState) : \(newState)")
    }
    
    /**
     *当点击annotation view弹出的泡泡时，调用此接口
     *@param mapView 地图View
     *@param view 泡泡所属的annotation view
     */
    func mapView(mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        var roadOrientation:String = "1"
        var tempRoadDictionary = [String: String]()
        if RoadMapFlag == 0{  //添加方案
        //  NSLog("点击了泡泡:\(title)")
            self.slectedRoadTV.hidden = false
            self.chexiaobtn.hidden = false

            let actionSheet = UIAlertController(title: "选择进入方向", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let alertAction1 = UIAlertAction(title: "东", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
                roadOrientation = "东"
                tempRoadDictionary["orientation"] = roadOrientation
                tempRoadDictionary["road"] = self.clickedRoadName
                self.addedRoadDetails.append(tempRoadDictionary)
                
                self.slectedRoadTV.text =  self.slectedRoadTV.text + self.clickedRoadName + "  东\n"
              //  print(self.addedRoadDetails)

            }
            let alertAction2 = UIAlertAction(title: "南", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
                roadOrientation = "南"
                tempRoadDictionary["orientation"] = roadOrientation
                tempRoadDictionary["road"] = self.clickedRoadName
                self.addedRoadDetails.append(tempRoadDictionary)
	
                self.slectedRoadTV.text = self.slectedRoadTV.text + self.clickedRoadName + "  南\n"
            //    print(self.addedRoadDetails)
            }
            let alertAction3 = UIAlertAction(title: "西", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
                roadOrientation = "西"
                tempRoadDictionary["orientation"] = roadOrientation
                tempRoadDictionary["road"] = self.clickedRoadName
                self.addedRoadDetails.append(tempRoadDictionary)

                self.slectedRoadTV.text = self.slectedRoadTV.text + self.clickedRoadName + "  西\n"
             //   print(self.addedRoadDetails)
            }
            let alertAction4 = UIAlertAction(title: "北", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
                roadOrientation = "北"
                tempRoadDictionary["orientation"] = roadOrientation
                tempRoadDictionary["road"] = self.clickedRoadName
                self.addedRoadDetails.append(tempRoadDictionary)
                
                self.slectedRoadTV.text = self.slectedRoadTV.text + self.clickedRoadName + "  北\n"
   
              //  print(self.addedRoadDetails)
            }
            let alertAction5 = UIAlertAction(title: "东南", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
                roadOrientation = "东南"
                tempRoadDictionary["orientation"] = roadOrientation
                tempRoadDictionary["road"] = self.clickedRoadName
                self.addedRoadDetails.append(tempRoadDictionary)
                self.slectedRoadTV.text = self.slectedRoadTV.text + self.clickedRoadName + "  东南\n"

            //    print(self.addedRoadDetails)
            }
            let alertAction6 = UIAlertAction(title: "西南", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
                roadOrientation = "西南"
                tempRoadDictionary["orientation"] = roadOrientation
                tempRoadDictionary["road"] = self.clickedRoadName
                self.addedRoadDetails.append(tempRoadDictionary)
                self.slectedRoadTV.text = self.slectedRoadTV.text + self.clickedRoadName + "  西南\n"

            //    print(self.addedRoadDetails)
            }
            let alertAction7 = UIAlertAction(title: "东北", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
                roadOrientation = "东北"
                tempRoadDictionary["orientation"] = roadOrientation
                tempRoadDictionary["road"] = self.clickedRoadName
                self.addedRoadDetails.append(tempRoadDictionary)
  
                self.slectedRoadTV.text = self.slectedRoadTV.text +  self.clickedRoadName + "  东北\n"
            //    print(self.addedRoadDetails)
            }
            let alertAction8 = UIAlertAction(title: "西北", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
                roadOrientation = "西北"
                tempRoadDictionary["orientation"] = roadOrientation
                tempRoadDictionary["road"] = self.clickedRoadName
                self.addedRoadDetails.append(tempRoadDictionary)
                
                self.slectedRoadTV.text = self.slectedRoadTV.text + self.clickedRoadName + "  西北\n"

            //    print(self.addedRoadDetails)
            }
            let cancleAction = UIAlertAction(title: "cancle", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
            }
            actionSheet.addAction(alertAction1)
            actionSheet.addAction(alertAction2)
            actionSheet.addAction(alertAction3)
            actionSheet.addAction(alertAction4)
            actionSheet.addAction(alertAction5)
            actionSheet.addAction(alertAction6)
            actionSheet.addAction(alertAction7)
            actionSheet.addAction(alertAction8)
            actionSheet.addAction(cancleAction)
            self.presentViewController(actionSheet, animated: true) { () -> Void in

            }

        }
                // 5
    }
    /**
     *根据anntation生成对应的View
     *@param mapView 地图View
     *@param annotation 指定的标注
     *@return 生成的标注View
     */
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        
        let AnnotationViewID = "renameMark"+String(count)
     //   print("计数：\(AnnotationViewID)")
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(AnnotationViewID) as! BMKPinAnnotationView?
        if annotationView == nil {
            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
            annotationView?.tag = count
            // 设置颜色
   //         annotationView!.pinColor = UInt(BMKPinAnnotationColorGreen)
            annotationView?.image = UIImage(named: "trafficlight")
            // 从天上掉下的动画
            annotationView!.animatesDrop = true
            // 设置是否可以拖拽
            annotationView!.draggable = false
        }
        annotationView?.annotation = annotation
        return annotationView
    }
    
}
