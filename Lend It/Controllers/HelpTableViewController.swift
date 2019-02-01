//
//  HelpTableViewController.swift
//  Lend It
//
//  Created by Grecia Escárcega on 1/31/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit

class HelpTableViewController: UITableViewController {
    
    var helpTitle = ""
    var helpText = ""
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        helpText = helpItems[indexPath.row].text
        helpTitle = helpItems[indexPath.row].title
        performSegue(withIdentifier: "helpSegue", sender: self)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "helpItemCell", for: indexPath)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = self.helpItems[indexPath.row].title
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "helpSegue" {
            let vc = segue.destination as! HelpViewController
            vc.helpTitle = helpTitle
            vc.helpText = helpText
        }

    }
    
}

