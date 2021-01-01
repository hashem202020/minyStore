//
//  ItemTableViewCell.swift
//  storeApp
//
//  Created by hashem on 27/12/2020.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblDateAdd: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    
    func setMyCell(item : Items) {
        lblItemName.text = item.item_name
        itemImage.image = item.image as? UIImage
        lblStoreName.text = item.toStore?.name
        
        //convert date to string
        let dateString = DateFormatter()
        dateString.dateFormat = "dd/MM/yy h:mm a"
        
        lblDateAdd.text = dateString.string(from: item.date_add! )
        
        
    }
}
