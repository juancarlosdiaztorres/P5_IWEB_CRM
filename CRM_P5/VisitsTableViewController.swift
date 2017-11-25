//
//  VisitsTableViewController.swift
//  CRM
//
//  Created by g707 DIT UPM on 24/11/17.
//  Copyright © 2017 g707 DIT UPM. All rights reserved.
//

import UIKit

//Tipo definido para diccionario de strings.
//typealias Visit = [String:Any]

class VisitsTableViewController: UITableViewController {
    
    //Variables que cojo del segue: url, texto y el tipo de que me piden
    var stringURL = ""
    var headerText = ""
    var kindOfRequest: KindOfRequest = .AllVisits

    //ARRAY DE STRUCTS: Variable de visitas, cojo visits, del tipo del Struct, en forma de array
    var visits: [Visits] = []
    
    //Me creo un diccionario de imagenes a partir de enteros
    var salesmanImg = [Int:UIImage]()
    
    //Creo esta variable para poner el header
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.title = headerText
        
        getDataFromJSON() //Obtengo el visits que necesito
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visits.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitsCell", for: indexPath)
        
        //En textoLabel SIEMPRE nombre cliente
        cell.textLabel?.text = visits[indexPath.row].Customer.name
        
        //Elijo que muestro dependiendo del url (nombre o fecha)
        if kindOfRequest == .AllVisits {
            cell.detailTextLabel?.text = visits[indexPath.row].Salesman.fullname
        } else {
            cell.detailTextLabel?.text = visits[indexPath.row].plannedFor
        }
        
        let salesmanId = visits[indexPath.row].Salesman.id
        
        //Si no hay URL de la foto, por defecto.
        guard let salesmanUrlStg = visits[indexPath.row].Salesman.Photo?.url else {
            cell.imageView?.image = UIImage(named: "noface")
            return cell
        }
        
        //Si no existe foto, descargo
        guard let img = salesmanImg[salesmanId] else{
            getSalesmanImg(id: salesmanId, URLString: salesmanUrlStg, for: indexPath)
            return cell
        }
        
        //Asigno foto
        cell.imageView?.image = img
        
        return cell
    }
    
    
    
    //Descarga del JSON
    private func getDataFromJSON() {
        
        //Creamos cola global
        let queue = DispatchQueue.global()
        
        //Activamos el indicador de red
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        defer {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        queue.async {
            //Creamos la URL
            guard let url = URL(string: self.stringURL) else {
                print("Error en la URL")
                return
            }
            
            //Usamos Data para la descarga
            guard let data = try? Data(contentsOf: url) else {
                print("Error en la descarga del JSON")
                return
            }
            
            //Creamos el decodificador de JSON
            let decoder = JSONDecoder()
            
            //Decodificamos de JSON
            guard let decodedVisits = try? decoder.decode([Visits].self, from: data) else {
                print("JSON no decodificado")
                return
            }
            
            print("JSON Ok")
            //print(decodedVisits)
            
            //Añadimos al array
            DispatchQueue.main.async {
                print("Vuelta main")
                self.visits = decodedVisits
                self.tableView.reloadData()
            }
            
        }
        
    }

    
    

    //Funcion que descarga la imagen del salesman
    private func getSalesmanImg(id: Int, URLString stgUrl: String, for indexPath: IndexPath) {
        let queue = DispatchQueue.global()
        
        queue.async {
            //Creamos la URL
            guard let url = URL(string: stgUrl) else {
                print("Error en la URL")
                return
            }
            
            //Usamos Data para la descarga
            guard let data = try? Data(contentsOf: url) else {
                print("Error en la descarga de la imagen")
                return
            }
            
            //Añadimos la imagen al diccionario
            if let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.salesmanImg[id] = img
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
            
        }
    
    
    }
    
    
    
    
    
    
    
    
    
}

