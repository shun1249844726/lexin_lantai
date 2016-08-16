//
//  CRC.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/3/21.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import Foundation

class CRC{
    func getCRC16(data:[UInt8],startIndex:Int,length:Int)->UInt8{
        let table : [UInt8] = [ 0, 94, UInt8(188), UInt8(226), 97, 63, UInt8(221),
            UInt8(131), UInt8(194), UInt8(156), 126, 32, UInt8(163),
            UInt8(253), 31, 65, UInt8(157), UInt8(195), 33, 127,
            UInt8(252), UInt8(162), 64, 30, 95, 1, UInt8(227), UInt8(189),
            62, 96, UInt8(130), UInt8(220), 35, 125, UInt8(159),
            UInt8(193), 66, 28, UInt8(254), UInt8(160), UInt8(225),
            UInt8(191), 93, 3, UInt8(128), UInt8(222), 60, 98, UInt8(190),
            UInt8(224), 2, 92, UInt8(223), UInt8(129), 99, 61, 124, 34,
            UInt8(192), UInt8(158), 29, 67, UInt8(161), UInt8(255), 70, 24,
            UInt8(250), UInt8(164), 39, 121, UInt8(155), UInt8(197),
            UInt8(132), UInt8(218), 56, 102, UInt8(229), UInt8(187), 89, 7,
            UInt8(219), UInt8(133), 103, 57, UInt8(186), UInt8(228), 6, 88,
            25, 71, UInt8(165), UInt8(251), 120, 38,UInt8(196),
            UInt8(154), 101, 59, UInt8(217), UInt8(135), 4, 90, UInt8(184),
            UInt8(230), UInt8(167), UInt8(249), 27, 69, UInt8(198),
            UInt8(152), 122, 36, UInt8(248), UInt8(166), 68, 26,
            UInt8(153), UInt8(199), 37, 123, 58, 100, UInt8(134),
            UInt8(216), 91, 5, UInt8(231), UInt8(185), UInt8(140),
            UInt8(210), 48, 110, UInt8(237), UInt8(179), 81, 15, 78, 16,
            UInt8(242), UInt8(172), 47, 113, UInt8(147), UInt8(205), 17,
            79, UInt8(173), UInt8(243), 112, 46, UInt8(204), UInt8(146),
            UInt8(211), UInt8(141), 111, 49, UInt8(178), UInt8(236), 14,
            80, UInt8(175), UInt8(241), 19, 77, UInt8(206), UInt8(144),
            114, 44, 109, 51, UInt8(209), UInt8(143), 12, 82, UInt8(176),
            UInt8(238), 50, 108, UInt8(142), UInt8(208), 83, 13,
            UInt8(239), UInt8(177), UInt8(240), UInt8(174), 76, 18,
            UInt8(145), UInt8(207), 45, 115, UInt8(202), UInt8(148), 118,
            40, UInt8(171), UInt8(245), 23, 73, 8, 86, UInt8(180),
            UInt8(234), 105, 55, UInt8(213), UInt8(139), 87, 9, UInt8(235),
            UInt8(181), 54, 104, UInt8(138), UInt8(212), UInt8(149),
            UInt8(203), 41, 119, UInt8(244), UInt8(170), 72, 22,
            UInt8(233), UInt8(183), 85, 11, UInt8(136), UInt8(214), 52,
            106, 43, 117, UInt8(151), UInt8(201), 74, 20, UInt8(246),
            UInt8(168), 116, 42, UInt8(200), UInt8(150), 21, 75,
            UInt8(169), UInt8(247), UInt8(182), UInt8(232), 10, 84,
            UInt8(215), UInt8(137), 107, 53 ]
        
        var ret : UInt8 = 0x33
        var index : UInt8 = 0
        for i in startIndex..<(startIndex + length){
            ret ^= ( data[i] & 0xff)
            index = ret
            ret = table[Int(index)]&0xff
      //      print(ret)
        }
        return ret
    }
}
