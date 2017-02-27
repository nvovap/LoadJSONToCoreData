//
//  MakeTableViewController.swift
//  LoadCars
//
//  Created by Vladimir Nevinniy on 2/27/17.
//  Copyright © 2017 Vladimir Nevinniy. All rights reserved.
//

import UIKit
import CoreData

class MakeTableViewController: UITableViewController {
    
   
    
    var managerContext: NSManagedObjectContext!
    
    var makes: [Makes]?
    var currentModels: [Models]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let app = UIApplication.shared.delegate as? AppDelegate
        
        managerContext = app!.persistentContainer.viewContext
        
        let request = NSFetchRequest<Makes>(entityName: "Makes")
        
      //  request.predicate = NSPredicate(format: "login == %@", textLogin.text!)
        
        do {
            makes = try managerContext.fetch(request) as [Makes]
            
            tableView.reloadData()
            
        } catch let error {
            print(error)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let count = makes?.count ?? 0
        
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMake", for: indexPath)


        cell.textLabel?.text = makes![indexPath.row].make

        return cell
    }
 
    
    @IBAction func onLoadData(_ sender: Any) {
        
        do {
            
            let dataCars = Bundle.main.path(forResource: "carsNotNormal", ofType: "json")!
            
        
            
            let data = try Data.init(contentsOf: URL(fileURLWithPath: dataCars))
            
            
            do {
                
                
                if let arrayRes = try JSONSerialization.jsonObject(with: data, options:[]) as? [[String: Any]] {
                    
                    
                    
                    for res in arrayRes {
                        print(res)
                        
                        let make  = Makes(context: managerContext)
                        make.make = res["make"] as? String
                        
                        if let models = res["models"] as? [[String: String]] {
                            for model in models {
                                
                                let objModel = Models(context: managerContext)
                                
                                objModel.model = model["model"]
                                objModel.engine = model["engine"]
                                objModel.year = model["year"]
                                
                                make.models?.adding(objModel)
                           
                            }
                        }
                        
                    }
                    
                    
                }
                
                
                
                
                
                //                let make = Makes(context: managerContext)
                
                
                
                do {
                    try managerContext.save()
                    
                    self.tableView.reloadData()
                    
                }catch let error {
                    print("Colud not save: \(error)")
                }
                
            }
                
            catch let error {
                print("Don't file: \(error)")
            }
        } catch let error {
            print("Colud not read JSON: \(error)")
        }
        
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let models = makes?[indexPath.row].models {
            
            print(models)
            
            currentModels = models.allObjects as? [Models]
            
            
            print(currentModels)
            
            performSegue(withIdentifier: "segueDetail", sender: self)
        }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail" {
            let vc = segue.destination as! ModelsTableViewController
            vc.models = currentModels
            
        }
    }
 

}
