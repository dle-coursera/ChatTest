//
//  MasterViewController.swift
//  ChatTest
//
//  Created by David Le on 9/12/16.
//  Copyright © 2016 Coursera. All rights reserved.
//

import UIKit
import ZDCChat

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [NSDate()]

    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel!.text = "Tap to Chat"
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let group = dispatch_group_create()
        
        dispatch_group_enter(group)
        ZDCChat.updateVisitor { visitor in
            dispatch_group_leave(group)
            visitor.name = "David Le"
            visitor.email =  "dle@coursera.org"
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { [weak self] in
            if let navigationController = self?.navigationController {
                ZDCChat.startChatIn(navigationController, withConfig: { (config) in
                    config.preChatDataRequirements.department = .Required
                    config.preChatDataRequirements.message = .Required
                    
                    let shortVersion = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                    
                    config.tags = ["ios", "v\(shortVersion)"]
                })
            } else {
                print("error")
            }
        }
    }
}

