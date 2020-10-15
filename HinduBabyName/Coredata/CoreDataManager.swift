//
//  CoreDataManager.swift
//  HinduBabyName
//
//  Created by POORAN SUTHAR on 03/06/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoredataManager {
    
    static func saveData(dictionary : [String : String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContent = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "FavoriteList", in: manageContent)!
        let users = NSManagedObject(entity: userEntity, insertInto: manageContent)
        for (key,value) in dictionary {
            users.setValue(value, forKey: key)
        }
        do {
            try manageContent.save()
        } catch let error as NSError {
            print("could not save . \(error), \(error.userInfo)")
        }
    }
    
    static func deleteData(baby: BabiesName) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteList")
        request.predicate = NSPredicate(format: "name == %@  AND meaning == %@", baby.name, baby.meaning)
        
        do {
            if let result = try? context.fetch(request) {
                for object in result {
                    context.delete(object as! NSManagedObject)
                }
                try context.save()
            }
        } catch {
            print(error)
        }
    }
    
    static func fetchdata(predicate: NSPredicate? = nil) -> [Any]? {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteList")
        request.predicate = predicate
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print("error")
        }
        return nil
    }
}
