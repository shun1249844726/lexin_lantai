//
//  DataModles.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/2/27.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit

var RoadNum = 0   //路口数量
var RoadsArray : Array<Dictionary<String, String>>? //各个路口的  ！！所有 ！！   详情信息,字典类型
var FleetLength = 5     // 车队长度
var FleetSpacing = 15   //车队间距
var SendDistance = 400  //命令发送距离

// MARK: //查看路口地图：1    添加方案 ：0
var RoadMapFlag:Int = -1
var edit_add_road_flag = -1

var GETGPSPACKAGE : [UInt8] = [0x7E,0x40,0x00,0x00,0x00,0x00,0x00,0x03,0x76,0x7E]   //发送请求GPS的报文
var COMMUNITEERROR : String = "7E 40 0 0 0 0 0 6 0 DA 7E "
