//
//  AddItem.swift
//  storeApp
//
//  Created by hashem on 27/12/2020.
//

import UIKit
import CoreData

class AddItem: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var pickerStoreType: UIPickerView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var txtItemName: UITextField!
    
    var listStoreType = [StoreType]()
    
    var imagePicker : UIImagePickerController!
    
    var EditOrDeleteItem: Items?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerStoreType.dataSource = self
        pickerStoreType.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        loadStores()
        
        if EditOrDeleteItem != nil{
            loadForEdit()
        }
        
        //var reloadDelegate: ReloadDataProtocol?

    }
    
    
    //MARK: - pickerview
    
    //implement for store picker
    func loadStores() {
        let fetchRequest: NSFetchRequest<StoreType> =
            StoreType.fetchRequest()
        do{
            listStoreType = try context.fetch(fetchRequest)
        }catch{
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listStoreType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = listStoreType[row]
        return store.name
    }
    
        
    //MARK: - ACTIONS
        
    func fetch(item : Items) {
        item.item_name = txtItemName.text
        item.date_add = NSDate() as Date
        item.image = itemImageView.image
        item.toStore = listStoreType[pickerStoreType.selectedRow(inComponent: 0)]
    }
    
    @IBAction func buSave(_ sender: Any) {
        let newItem : Items!
        if EditOrDeleteItem == nil{
            newItem = Items(context: context)
            fetch(item: newItem)
            do{
                ad.saveContext()
                txtItemName.text = ""
                itemImageView.image = #imageLiteral(resourceName: "loadingimg")
            }catch{
                print("error")
            }
        }else{
            newItem = EditOrDeleteItem
            fetch(item: newItem)
            do{
                ad.saveContext()
                dismiss(animated: true, completion: nil)
                
            }catch{
                print("error")
            }
        }
    }
    
    @IBAction func buBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func buDelete(_ sender: Any) {
        if EditOrDeleteItem != nil{
            context.delete(EditOrDeleteItem!)
            ad.saveContext()
            //navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func buNewStore(_ sender: Any) {
       
        if let storesVC = storyboard?.instantiateViewController(identifier: "AddStore") as? AddStore{
            present(storesVC, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - Image Picker
    //implement image picker
    
    @IBAction func buSelectImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            itemImageView.image = image
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- Load data for edit
    func loadForEdit()  {
        if let item = EditOrDeleteItem{
        txtItemName.text = item.item_name
        itemImageView.image = item.image as? UIImage
    
            //to handle make picker view choose the specified store
            if let store = item.toStore {
                var index = 0
                while index < listStoreType.count {
                    let row = listStoreType[index]
                    if row.name == store.name{
                        pickerStoreType.selectRow(index, inComponent: 0, animated: false)
                    }
                    index+=1
                }
            }
        }
    }
}
