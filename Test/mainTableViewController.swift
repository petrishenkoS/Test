//
//  mainTableViewController.swift
//  Test
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Serhii Petrishenko. All rights reserved.
//

import UIKit
import CoreData

class mainTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    //начальные данные
    let name1 = "Mackdonald"
    let location1 = "Ukraine, Kiev"
    let image = UIImage(named: "icon")
    let name2 = "SoloPizza"
    let location2 = "Ukraine, Lviv"
    
    var restaurants = [Restaurant]()
    var restaurant1: Restaurant!
    var restaurant2: Restaurant!
    
    var fetchResultController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //запрос на получение данных
        let fetchRequest = NSFetchRequest(entityName: "Restaurant")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self

            do {
                try fetchResultController.performFetch()
                restaurants = fetchResultController.fetchedObjects as! [Restaurant]
                
            } catch {
                print(error)
            }
            
            //заполняем данными
            if restaurants.isEmpty {
            restaurant1 = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: managedObjectContext) as! Restaurant
            restaurant2 = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: managedObjectContext) as! Restaurant
            
            restaurant1.name = name1
            restaurant1.location = location1
            restaurant1.image = UIImagePNGRepresentation(image!)!
            
            restaurant2.name = name2
            restaurant2.location = location2
            restaurant2.image = UIImagePNGRepresentation(image!)!
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
            }
        }
        
        tableView.registerNibNames([mainTableViewCell.description()])
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    //заполняем ячейку
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(mainTableViewCell.description(), forIndexPath: indexPath) as! mainTableViewCell
        
        cell.nameLabel.text = restaurants[indexPath.row].name
        cell.mainImageView.image = UIImage(data: restaurants[indexPath.row].image)
        cell.locationLabel.text = restaurants[indexPath.row].location

        return cell
    }
    
    //при свайпе по ячейке удаляем или копируем ячейку
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //копирование
        let copyAction = UITableViewRowAction(style: .Default, title: "Copy", handler: { (action, indexPath) in
            
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                let restaurantToCopy = self.fetchResultController.objectAtIndexPath(indexPath) as! Restaurant
                
                var copyObject: Restaurant!
                
                copyObject = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: managedObjectContext) as! Restaurant
                copyObject.name = restaurantToCopy.name
                copyObject.location = restaurantToCopy.location
                copyObject.image = restaurantToCopy.image
                
                print(copyObject.name)
                managedObjectContext.insertObject(copyObject)
                self.restaurants.insert(copyObject, atIndex: indexPath.row)
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        })
        
        //удаление
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {(action, indexPath) in
            
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                let restaurantToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! Restaurant
                self.restaurants.removeAtIndex(indexPath.row)
                managedObjectContext.deleteObject(restaurantToDelete)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        })
        
        copyAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction, copyAction]
    }
    
    //создаем кнопку Log Out для возвращения на экран авторизации
    override func viewWillAppear(animated: Bool) {
        
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: "back")
        self.navigationItem.rightBarButtonItem = backButton;
        super.viewWillAppear(animated);
        navigationController?.hidesBarsOnSwipe = true
        prefersStatusBarHidden()
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
}
