//
//  ProductListVC.swift
//  FurnitureAR
//
//  Created by Apple on 21/03/18.
//  Copyright © 2018 hustle. All rights reserved.
//

import UIKit

class FurnitureTVC: UICollectionViewCell{
    @IBOutlet weak var furnitureImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var arBtn: UIButton!
}

protocol TypeDelegate
{
    func objectType(desc : String)
}

class ModalViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var delegate : TypeDelegate?
    @IBOutlet weak var product: UICollectionView!
    
    let desc = ["Sofa", "Sofa Chair", "Table", "Chair"]
    let price = ["₹50000", "₹8000", "₹2000", "₹4500"]
    let img = ["blacksofa.jpg", "chair2.jpg", "table.jpg", "chair.jpg"]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return desc.count
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "furniture", for: indexPath) as! FurnitureTVC
        cell.descriptionLabel.text = desc[indexPath.row]
        cell.priceLabel.text = price[indexPath.row]
        cell.furnitureImage.image = UIImage(named: img[indexPath.row])
        
        cell.arBtn.tag = indexPath.row
        cell.arBtn.addTarget(self, action:#selector(arBtnPressed(sender:)), for: .touchUpInside)
        return cell
    }
    
    func arBtnPressed(sender : UIButton) {
        delegate?.objectType(desc: desc[sender.tag])
        self.removeAnimate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        product.delegate = self
        product.dataSource = self
        self.showAnimate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController{
            if let PassedData = sender as? String{
                destination.object = PassedData
            }
        }
    }
    
}
