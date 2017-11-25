//
//  MainTableViewController.swift
//  CRM_P5
//
//  Created by Juan Carlos Díaz Torres on 25/11/2017.
//  Copyright © 2017 Juan Carlos Díaz Torres. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var beginDate: Date = Date()
    var endDate: Date = Date()
    var existsBeginDate = false
    var existsEndDate = false
    
    private let defaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        checkUsersDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    //2 secciones distinas
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    //Dependiendo de la seccion que sea, escojo 1 o 2 filas
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else if section == 1 {
            return 2
        } else {
            return 0
        }
    }
    
    //Elijo el titulo de cada una de las secciones (total y usuario)
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Total"
        } else {
            return "Usuario"
        }
    }
    
    
    //Modifico los textLabel de cada seccion/row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath)

        if indexPath.section == 0 {
            cell.textLabel?.text = "Todas las visitas"
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Todas mis visitas"
            }
            if indexPath.row == 1{
                cell.textLabel?.text = "Mis favoritas"
            }
        }

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
    
    //Compruebo persistencia. Si hay fechas ya puestas, las pongo y true.
    private func checkUsersDefaults () {
        if let bDate = defaults.object(forKey: "beginDate") as? Date {
            beginDate = bDate
            existsBeginDate = true
        }
        
        if let eDate = defaults.object(forKey: "endDate") as? Date {
            endDate = eDate
            existsEndDate = true
	        }
    }
    
    //Metodo de vuelta desde fechas. Compruebo si hay fechas
    @IBAction func goBackMain(_ segue: UIStoryboardSegue) {
        checkUsersDefaults()
    }
    
    //Comprobamos que existen ambas fechas, sino, no continuo y saco error.
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToVisitsTVC" {
            if existsEndDate && existsBeginDate {
                return true
            } else {
                let alert = UIAlertController(title: "ERROR", message: "No has establecido las fechas. Seleccionalas antes de continuar.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Entendido", style: .default))
                present(alert,animated: true)
                return false
            }
        }
        return true
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Token de acceso y urls a desplegar:
        let token = "6bac0f89326e4c92d000"
        let allVisitsURL = "https://dcrmt.herokuapp.com/api/visits/flattened?token="
        let myVisitsURL = "https://dcrmt.herokuapp.com/api/users/tokenOwner/visits/flattened?token="
        let myFavVisitsURL = "&favourites=1"
        
        //Variable de decision, de ella depende el recurso a descargar (segun lo que clickemos en la tabla main)
        let indexPath = tableView.indexPathForSelectedRow
        
        if segue.identifier == "goToVisitsTVC" {
            guard let vtvc = segue.destination as? VisitsTableViewController else {
                //UIAlert!
                return
            }
            
            if indexPath?.section == 0 {
                vtvc.stringURL = "\(allVisitsURL)\(token)"
                vtvc.headerText = "Todas las visitas"
                vtvc.kindOfRequest = .AllVisits
                return
            }
            
            if indexPath?.section == 1 {
                if indexPath?.row == 0 {
                    vtvc.stringURL = "\(myVisitsURL)\(token)"
                    vtvc.headerText = "Mis visitas"
                    vtvc.kindOfRequest = .MyVisits
                    return
                }
                if indexPath?.row == 1 {
                    vtvc.stringURL = "\(myVisitsURL)\(token)\(myFavVisitsURL)"
                    vtvc.headerText = "Mis visitas favoritas"
                    vtvc.kindOfRequest = .MyFavVisits
                    return
                }
                
            }
        
        
        
        
        
        
    }

    
    
    
    
    
    
    
    
    }
    
    
    
}
