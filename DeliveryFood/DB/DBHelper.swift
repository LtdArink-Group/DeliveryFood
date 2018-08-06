//
//  DBHelper.swift
//  DeliveryFood
//
//  Created by B0Dim on 17.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Foundation
import SQLite
import SwiftyJSON

class DBHelper {
    
    var database: Connection!
    var first_entry = false
    
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
        
        let versions = Table("versions")
        let id = Expression<Int64>("id")
        let num = Expression<Int64>("num")
        let createTable = versions.create { (table) in
            table.column(id, primaryKey: .autoincrement)
            table.column(num)
        }
        
        if !tableExists(tableName: "versions") {
            do { try self.database.run(createTable)
                print("created table")
                self.insert_new_version(version: DB_VERSION)
                self.first_entry = true
            }
            catch {
                print(error)
            }
        }
        if first_entry
        {
            create_order_tables(drop: false)
        }
        else if !last_db_versions()
        {
            self.insert_new_version(version: DB_VERSION)
            create_order_tables(drop: true)
        }
    }
    
    func create_order_tables(drop: Bool)
    {
        self.connection()
        
        let id = Expression<Int64>("id")
        let productTable = Table("products")
        let product_id = Expression<Int64>("product_id")
        let name = Expression<String>("name")
        let count = Expression<Int64>("count")
        let main_option = Expression<String>("main_option")
        let cost = Expression<Double>("cost")
        let photo = Expression<String>("photo")
        
        var createTable = productTable.create { (table) in
            table.column(id, primaryKey: .autoincrement)
            table.column(product_id)
            table.column(name)
            table.column(count, defaultValue: 1)
            table.column(main_option)
            table.column(cost)
            table.column(photo)
        }
        if !tableExists(tableName: "products") || drop
        {
            do {
                if drop
                {
                    try self.database.run(productTable.drop())
                }
                try self.database.run(createTable)
                print("created table")
            }
            catch {
                print(error)
            }
        }
        else {
            print("table exists")
            if count_orders() == 0
            {
                New_order = true
            }
        }
        
        let ingredientsTable = Table("ingredients")
        createTable = ingredientsTable.create { (table) in
            table.column(id, primaryKey: .autoincrement)
            table.column(product_id)
            table.column(name)
            table.column(main_option)
            table.column(count)
            table.column(cost)
        }
        
        if !tableExists(tableName: "ingredients") || drop
        {
            do {
                if drop
                {
                    try self.database.run(ingredientsTable.drop())
                }
                try self.database.run(createTable)
                print("created table")
            }
            catch {
                print(error)
            }
        }
        else {
            print("table exists")
        }
        
        do {
            for prod in try database.prepare(productTable) {
                print("id: \(prod[id]), main_option: \(prod[main_option]), name: \(prod[name]), count: \(prod[count]), product_id: \(prod[product_id]), photo: \(prod[photo])")
            }
            for prod in try database.prepare(ingredientsTable) {
                print("id: \(prod[id]), main_option: \(prod[main_option]), name: \(prod[name]), count: \(prod[count]), product_id: \(prod[product_id])")
            }
        } catch {
            print(error)
        }
    }
    
    func last_db_versions() -> Bool
    {
        print("check_db_versions")
        do {
            let num:Int64 = try self.database.scalar("SELECT max(num) from versions") as! Int64
            return num == DB_VERSION
        }
        catch {
            return false
        }
    }
    
    func insert_new_version(version: Int)
    {
        self.connection()
        let num = Expression<Int>("num")
        let versions = Table("versions")
        do {
            _ = try database.run(versions.insert(num <- version))
        }
        catch {}
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
    
    func count_orders() -> Int {
        do {
            return Int(try self.database.scalar("SELECT coalesce(count(*),0) FROM products") as! Int64)
        }
        catch {
            print("error")
            return 0
        }
    }
    
    func count_prod_in_order() -> Int
    {
        self.connection()
        do {
            return Int(try self.database.scalar("SELECT coalesce(sum(count), 0) FROM products") as! Int64)
        }
        catch {
            print("error")
            return 0
        }
    }
    
    func sum_products_order() -> Int
    {
        self.connection()
        do {
            return Int(try self.database.scalar("SELECT coalesce(sum(cost * count),0.0) FROM products") as! Double)
        }
        catch {
            print("error")
            return 0
        }
    }
    
    func sum_ingredients_order() -> Int
    {
        self.connection()
        do {
            return Int(try self.database.scalar("SELECT coalesce(sum(cost * count),0.0) FROM ingredients") as! Double)
        }
        catch {
            print("error")
            return 0
        }
    }
    
    func total_order() -> [JSON]
    {
        self.connection()
        do {
            let orders = try self.database.prepare("select * from (SELECT product_id, name, main_option, cost, count, photo, 'p' as type from products union all SELECT product_id, name, main_option, cost, count, '', 'i' as type from ingredients) tbl1 order by product_id, main_option")
            var arr_ordered_prods = [JSON]()
            for order in orders
            {
                let prod_id = order[0] as! Int64
                let count_prod = order[4] as! Int64
                arr_ordered_prods.append(["product_id" : "\(Int(prod_id))", "name" : "\(order[1] as! String)", "main_option" : "\(order[2] as! String)", "cost" : "\(order[3] as! Double)", "count" : "\(Int(count_prod))", "photo" : "\(order[5] as! String)", "type" : "\(order[6] as! String)"])
            }
            return arr_ordered_prods
        }
        catch {
            return []
        }
    }
    
    func costs_ingredients(be_product_id: Int, be_main_option: String) -> Int
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let count = Expression<Int>("count")
        let main_option = Expression<String>("main_option")
        let ingredientsTable = Table("ingredients")
        let cost = Expression<Double>("cost")
        do {
            let sum_ings = try database.prepare(ingredientsTable.select(cost, count).filter(product_id == be_product_id && main_option == be_main_option))
            var cost_sum = 0
            for ing in sum_ings
            {
                print(ing)
                cost_sum = cost_sum + Int(ing[cost]) * ing[count]
            }
            return cost_sum
        }
        catch {
            return 0
        }
    }
    
    func count_product_in_order_with_main_option(be_product_id: Int, be_main_option: String) -> [JSON] {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let count = Expression<Int>("count")
        let main_option = Expression<String>("main_option")
        let productTable = Table("products")
        do {
            print(be_product_id)
            let products = try database.prepare(productTable.select(count).filter(product_id == be_product_id && main_option == be_main_option))
            var arr_ordered_prods = [JSON]()
            for prod in products
            {
                arr_ordered_prods.append(["count" : prod[count]])
            }
            return arr_ordered_prods
        }
        catch {
            print("error")
            return []
        }
    }
    
    func count_product_in_order(be_product_id: Int) -> [JSON] {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let count = Expression<Int>("count")
        let main_option = Expression<String>("main_option")
        let productTable = Table("products")
        do {
            let products = try database.prepare(productTable.select(count, main_option).filter(product_id == be_product_id))
            var arr_ordered_prods = [JSON]()
            for prod in products
            {
                arr_ordered_prods.append(["main_option" : "\(prod[main_option])", "count" : prod[count]])
            }
            return arr_ordered_prods
        }
        catch {
            print("error")
            return []
        }
    }
    
    func count_product_ingredients_in_order(be_product_id: Int, be_name: String, be_main_option: String) -> [JSON] {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let count = Expression<Int>("count")
        let main_option = Expression<String>("main_option")
        let name = Expression<String>("name")
        let ingredientsTable = Table("ingredients")
        do {
            let ingredients = try database.prepare(ingredientsTable.select(count).filter(product_id == be_product_id && name == be_name && main_option == be_main_option))
            var arr_ordered_ings = [JSON]()
            for ings in ingredients
            {
                arr_ordered_ings.append(["count" : ings[count]])
            }
            return arr_ordered_ings
        }
        catch {
            print("error")
            return []
        }
    }
    
    func delete_order()
    {
        self.connection()
        let productTable = Table("products")
        let ingredientsTable = Table("ingredients")

        do {
            try database.run(productTable.delete())
            try database.run(ingredientsTable.delete())
        }
        catch { }
    }
    
    
    
    func add_to_order(be_product_id: Int, be_name: String, be_main_option: String, be_cost: Double, be_photo: String)
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let name = Expression<String>("name")
        let main_option = Expression<String>("main_option")
        let cost = Expression<Double>("cost")
        let photo = Expression<String>("photo")
        let productTable = Table("products")
        do {
            let rowid = try database.run(productTable.insert(product_id <- be_product_id, name <- be_name, main_option <- be_main_option, cost <- Double(be_cost), photo <- be_photo))
            print("inserted id: \(rowid)")
        }
        catch {
            print("insertion failed: \(error)")
        }
    }
    
    func add_to_order_ingredients(be_product_id: Int, be_name: String, be_main_option: String, be_cost: Double)
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let name = Expression<String>("name")
        let main_option = Expression<String>("main_option")
        let cost = Expression<Double>("cost")
        let count = Expression<Int64>("count")
        let ingredientTable = Table("ingredients")
        do {
            let rowid = try database.run(ingredientTable.insert(product_id <- be_product_id, count <- 1, name <- be_name, main_option <- be_main_option, cost <- Double(be_cost)))
            print("inserted id: \(rowid)")
        }
        catch {
            print("insertion failed: \(error)")
        }
    }
    
    func update_from_order_plus(be_product_id: Int, be_main_option: String)
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let count = Expression<Int>("count")
        let main_option = Expression<String>("main_option")
        let productTable = Table("products")
        
        do {
            let product = productTable.filter(product_id == be_product_id && main_option == be_main_option)
            try database.run(product.update(count++))
            print("OK plus")
        }
        catch {
            print(error)
        }
    }
    
    func create_order_from_backend(be_product_id: Int, be_name: String, be_main_option: String, be_cost: Double, be_count: Int)
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let name = Expression<String>("name")
        let main_option = Expression<String>("main_option")
        let cost = Expression<Double>("cost")
        let count = Expression<Int>("count")
        let photo = Expression<String>("photo")
        let productTable = Table("products")
        do {
            let rowid = try database.run(productTable.insert(product_id <- be_product_id, name <- be_name, main_option <- be_main_option, cost <- Double(be_cost), count <- be_count, photo<-""))
            print("inserted id: \(rowid)")
        }
        catch {
            print("insertion failed: \(error)")
        }
    }
    
    func create_order_ings_from_backend(be_product_id: Int, be_name: String, be_main_option: String, be_cost: Double, be_count: Int)
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let name = Expression<String>("name")
        let main_option = Expression<String>("main_option")
        let cost = Expression<Double>("cost")
        let count = Expression<Int>("count")
        let ingredientTable = Table("ingredients")
        do {
            let rowid = try database.run(ingredientTable.insert(product_id <- be_product_id, name <- be_name, main_option <- be_main_option, cost <- Double(be_cost), count <- be_count))
            print("inserted id: \(rowid)")
        }
        catch {
            print("insertion failed: \(error)")
        }
    }
    
    func update_from_order_ingredients_plus(be_product_id: Int, be_main_option: String, be_name: String)
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let count = Expression<Int>("count")
        let main_option = Expression<String>("main_option")
        let name = Expression<String>("name")
        let ingredientTable = Table("ingredients")
        
        do {
            let product = ingredientTable.filter(product_id == be_product_id && main_option == be_main_option && name == be_name)
            try database.run(product.update(count++))
            print("OK plus")
        }
        catch {
            print(error)
        }
    }
    
    func update_from_order_minus(be_product_id: Int, be_main_option: String)
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let count = Expression<Int>("count")
        let main_option = Expression<String>("main_option")
        let productTable = Table("products")
        
        do {
            let product = productTable.filter(product_id == be_product_id && main_option == be_main_option)
            try database.run(product.update(count-=1))
            print("OK minus")
        }
        catch {
            print(error)
        }
    }
    
    func update_from_order_ingredients_minus(be_product_id: Int, be_main_option: String, be_name: String)
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let count = Expression<Int>("count")
        let main_option = Expression<String>("main_option")
        let name = Expression<String>("name")
        let ingredientTable = Table("ingredients")
        
        do {
            let product = ingredientTable.filter(product_id == be_product_id && main_option == be_main_option && name == be_name)
            try database.run(product.update(count-=1))
            print("OK minus")
        }
        catch {
            print(error)
        }
    }
    
    func check_exists(be_product_id: Int, be_main_option: String) -> Int
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let main_option = Expression<String>("main_option")
        let count = Expression<Int>("count")
        let productTable = Table("products")
        do {
            let product = productTable.filter(product_id == be_product_id && main_option == be_main_option)
            var count = try database.scalar(product.select(count.max))
            if count == nil
            {
                count = 0
            }
            return count!
        }
        catch {
            print(error)
            return 0
        }
    }
    
    func check_exists_ingredients(be_product_id: Int, be_main_option: String, be_name: String) -> Int
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let main_option = Expression<String>("main_option")
        let count = Expression<Int>("count")
        let name = Expression<String>("name")
        let ingredientTable = Table("ingredients")
        do {
            let ingredient = ingredientTable.filter(product_id == be_product_id && main_option == be_main_option && name == be_name)
            var count = try database.scalar(ingredient.select(count.max))
            if count == nil
            {
                count = 0
            }
            return count!
        }
        catch {
            print(error)
            return 0
        }
    }
    
    func delete_ingredients_product(be_product_id: Int, be_main_option: String, be_name: String)
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let main_option = Expression<String>("main_option")
        let name = Expression<String>("name")
        let ingredientTable = Table("ingredients")
        do {
            let product = ingredientTable.filter(product_id == be_product_id && main_option == be_main_option && name == be_name)
            try database.run(product.delete())
            print("deleted")
        }
        catch {
            print(error)
        }
    }
    
    func delete_ingredient_of_product(be_product_id: Int, be_main_option: String)
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let main_option = Expression<String>("main_option")
        let ingredientTable = Table("ingredients")
        do {
            let product = ingredientTable.filter(product_id == be_product_id && main_option == be_main_option)
            try database.run(product.delete())
            print("deleted")
        }
        catch {
            print(error)
        }
    }
    
    func delete_product(be_product_id: Int, be_main_option: String)
    {
        self.connection()
        let product_id = Expression<Int>("product_id")
        let main_option = Expression<String>("main_option")
        let productTable = Table("products")
        do {
            let product = productTable.filter(product_id == be_product_id && main_option == be_main_option)
            try database.run(product.delete())
            print("deleted")
        }
        catch {
            print(error)
        }
    }
}

extension Connection {
    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}


