//
//  DBHelper.swift
//  DeliveryFood
//
//  Created by B0Dim on 17.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Foundation
import SQLite

class DBHelper {
    
    var database: Connection!
    
    func connection()
    {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("delivery_food").appendingPathExtension("sqlite3")
            let database = try Connection(fileURL.path)
            self.database = database
        } catch {
            print(error)
        }
    }
    
    func create_tables()
    {
        self.connection()
        
        let productTable = Table("products")
        let id = Expression<Int>("id")
        let product_id = Expression<Int>("product_id")
        let name = Expression<String>("name")
        let count = Expression<Int>("count")
        let main_option = Expression<String>("main_option")
        let cost = Expression<Double>("cost")
        
        var createTable = productTable.create { (table) in
            table.column(id, primaryKey: true)
            table.column(product_id)
            table.column(name)
            table.column(count)
            table.column(main_option)
            table.column(cost)
        }
        
        if !tableExists(tableName: "products") {
            do { try self.database.run(createTable)
                print("created table")
            }
            catch {
                print(error)
            }
        }
        else {
            print("table exists")
        }
        
        let ingredientsTable = Table("ingredients")
        createTable = ingredientsTable.create { (table) in
            table.column(id, primaryKey: true)
            table.column(product_id)
            table.column(name)
            table.column(count)
            table.column(cost)
        }
        
        if !tableExists(tableName: "ingredients") {
            do { try self.database.run(createTable)
                print("created table")
            }
            catch {
                print(error)
            }
        }
        else {
            print("table exists")
        }
        
    }
    
    func tableExists(tableName: String) -> Bool {
        do {
        let count:Int64 = try self.database.scalar(
            "SELECT EXISTS(SELECT name FROM sqlite_master WHERE name = ?)", tableName
            ) as! Int64
        return count > 0
        }
        catch {
            return false
        }
    }
    
}



