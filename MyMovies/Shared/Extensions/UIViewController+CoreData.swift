//
//  UIViewController+CoreData.swift
//  MyMovies
//
//  Created by Vitor Spessoto on 17/02/21.
//

import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
}
