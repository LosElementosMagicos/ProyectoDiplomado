//
//  HelpTableViewController.swift
//  Lend It
//
//  Created by Grecia Escárcega on 1/31/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit

class HelpTableViewController: UITableViewController {
    
    var helpItems = [HelpModel]()

    
    @IBAction func exitButtonPressed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.helpItems = getHelpItems()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.helpItems.count
    }

    func getHelpItems() -> [HelpModel] {
        debugPrint(HelpDataSource().helpItems)
        let decoder = JSONDecoder()
        if let result = try? decoder.decode([HelpModel].self, from: HelpDataSource().helpItems){
            return result
        }
        else {
            debugPrint("error")
        }
        return []
    }
    
    
//    func getHelpItems() {
//
//        if let path = Bundle.main.path(forResource: "HelpDataSource", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                debugPrint(data)
//
//                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                debugPrint(jsonResult)
//                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let helpItems = jsonResult["help"] as? [Any] {
//                    debugPrint(helpItems)
//                }
//                else {
//                    debugPrint("error!!!")
//                }
//
//            } catch {
//                debugPrint("error")
//            }
//        }
//        else {debugPrint("not found")}
//    }
//
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "helpItemCell", for: indexPath) as! HelpTableViewCell

        cell.helpItemLabel.text = self.helpItems[indexPath.row].title

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    //}


}
