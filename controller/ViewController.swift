
import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Items>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        loadItems()
        
        
    }
    
    //MARK:- Fetching Data
    func configureCell(cell: ItemTableViewCell, indexPath: IndexPath) {
        let singleItem = controller.object(at: indexPath)
        cell.setMyCell(item: singleItem)
        
    }
    
    func loadItems() {
        let fetchRequest: NSFetchRequest<Items> = Items.fetchRequest()
        let sortByDate = NSSortDescriptor(key: "date_add", ascending: false)
        fetchRequest.sortDescriptors = [sortByDate]
        
        
        
        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        do{
            try controller.performFetch()
        }catch{
            print("error")
            
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //data fetch
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
                break
        
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
                break
            
        case .update:
            if let indexPath = indexPath{
                let cell = tableView.cellForRow(at: indexPath) as! ItemTableViewCell
                configureCell(cell: cell, indexPath: indexPath )
            }
                break
        
        case .move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
                break
        
        @unknown default:
            print("nothing")
        }
        
    }
    
    
    
    //MARK:- TableView Implementation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller?.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //show cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    // to Update Item Data
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //row selected
        if let objc = controller.fetchedObjects{
            let item = objc[indexPath.row]
            performSegue(withIdentifier: "EditOrDelete", sender: item)
        }
    }
    
    
    //MARK:- to Edit Page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditOrDelete"{
            if let destination = segue.destination as? AddItem{
                if let item = sender as? Items {
                    destination.EditOrDeleteItem = item
                }
            }
        }
    }
    
}

