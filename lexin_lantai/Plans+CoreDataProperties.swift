//
//  Plans+CoreDataProperties.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/3/3.
//  Copyright © 2016年 徐顺. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Plans {

    @NSManaged var planDetails: String?
    @NSManaged var planName: String?
    @NSManaged var planNum: String?
    @NSManaged var roadNum: String?

}
