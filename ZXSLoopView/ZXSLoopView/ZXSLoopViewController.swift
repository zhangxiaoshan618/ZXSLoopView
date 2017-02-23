//
//  ZXSLoopViewController.swift
//  ZXSLoopView
//
//  Created by 张晓珊 on 16/4/22.
//  Copyright © 2016年 张晓珊. All rights reserved.
//

import UIKit

let kTavleViewCellID = "TavleViewCellID"

class ZXSLoopViewController: UITableViewController {
    
    var loopView: ZXSLoopView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kTavleViewCellID)
        
        var urls = [URL]()
        for i in 0...4 {
            let imageName = String(format: "%02d.jpg", i)
            urls.append(Bundle.main.url(forResource: imageName, withExtension: nil)!)
        }
        
        loopView = ZXSLoopView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200), urls: urls, selectedBlock: { (index) -> () in
            print("选中了第\(index)张图片。")
        })
        
        tableView.tableHeaderView = loopView
        
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 20;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTavleViewCellID, for: indexPath)
        cell.textLabel?.text = "第\((indexPath as NSIndexPath).row)条内容"
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
