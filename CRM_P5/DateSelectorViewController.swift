//
//  DateSelectorViewController.swift
//  CRM_P5
//
//  Created by Juan Carlos Díaz Torres on 25/11/2017.
//  Copyright © 2017 Juan Carlos Díaz Torres. All rights reserved.
//

import UIKit

class DateSelectorViewController: UIViewController {
    
    
    @IBOutlet weak var beginDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
  
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Persistencia
        if let bDate = defaults.object(forKey: "beginDate") as? Date {
            beginDatePicker.date = bDate
        }
        
        if let eDate = defaults.object(forKey: "endDate") as? Date {
            endDatePicker.date = eDate
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Compruebo antes de volver al main (Guardar), si he cogido las fechas y si estas son correctas
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goBackMain" {
            if endDatePicker.date > beginDatePicker.date {
                return true
            } else {
                let alert = UIAlertController(title: "ERROR", message: "La fecha final es previa a la inicial. Selecciona otra fecha para continuar", preferredStyle: .alert)
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
        if segue.identifier == "goBackMain" {
            defaults.set(beginDatePicker.date, forKey:"beginDate")
            defaults.set(endDatePicker.date, forKey:"endDate")
            defaults.synchronize()
        }
    }
 

}
