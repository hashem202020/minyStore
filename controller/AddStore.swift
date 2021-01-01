//
//  AddStore.swift
//  storeApp
//
//  Created by hashem on 27/12/2020.
//

import UIKit
import CoreData


class AddStore: UIViewController {

    @IBOutlet weak var txtStoreName: UITextField!
    @IBOutlet weak var storesTableView: UITableView!
    @IBOutlet weak var lblStoreName: UILabel!
    
    var listStores = [StoreType]()
    var Edit: StoreType!
   
   
    override func viewDidLoad() {
        super.viewDidLoad()

        storesTableView.delegate = self
        storesTableView.dataSource = self
        loadStores()
        //print(listStores)
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Actions
    
    @IBAction func BuSave(_ sender: Any) {
        if Edit == nil{
        let store = StoreType(context: context)
        store.name = txtStoreName.text
        do{
            ad.saveContext()
            txtStoreName.text = ""
            loadStores()
            storesTableView.reloadData()
            //print("Saved")
        }catch{
            print("Can't Save..")
        }
        }else{
            let store = Edit
            store?.name = txtStoreName.text
            do{
                ad.saveContext()
                txtStoreName.text = ""
                loadStores()
                storesTableView.reloadData()
                //print("Saved")
            }catch{
                print("Can't Save..")
            }
        }
    }
    @IBAction func BuBack(_ sender: Any) {
        
       
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK:- TableView Implementation

extension AddStore : UITableViewDataSource
{
    func loadStores() {
        let fetchRequest: NSFetchRequest<StoreType> =
            StoreType.fetchRequest()
        do{
            listStores = try context.fetch(fetchRequest)
        }catch{
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StoresCell", for: indexPath) as? StoresTableViewCell{
            let store = listStores[indexPath.row]
            cell.lblStoreName.text = store.name
           // print(store)
            return cell
            
        }
        return UITableViewCell()
    }
    
    
  
    
}

extension AddStore : UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let store = listStores[indexPath.row]
        txtStoreName.text = listStores[indexPath.row].name
        Edit = listStores[indexPath.row]
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let store = listStores[indexPath.row]
        context.delete(store)
        ad.saveContext()
        
        //listStores.remove(at: indexPath.row)
        loadStores()
        storesTableView.reloadData()
    
    }
}


