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
    var helpTitle = ""
    var helpText = ""
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.helpTitle = self.helpItems[indexPath.row].title
        self.helpText = self.helpItems[indexPath.row].text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "helpSegue" {
                    let vc = segue.destination as! HelpViewController
                    vc.text = self.helpText
                    vc.titleHelp = self.helpTitle
                }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "helpItemCell", for: indexPath) as! HelpTableViewCell

        cell.helpItemLabel.text = self.helpItems[indexPath.row].title

        return cell
    }

}
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "helpSegue" {
//            let vc = segue.destination as! HelpViewController
//            vc.titleLabel?.text = self.titleSegue
//            vc.helpTextLabel?.text = self.textSegue
//        }
//
//    }


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

