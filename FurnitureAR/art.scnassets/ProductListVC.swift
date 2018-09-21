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
    
}

class ProductListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var product: UICollectionView!
    
    let desc = ["Sofa", "Couch", "Table", "Chair"]
    let price = ["100000", "40000", "30000", "5000"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return desc.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "furniture", for: indexPath) as! FurnitureTVC
        cell.descriptionLabel.text = desc[indexPath.row]
        cell.priceLabel.text = price[indexPath.row]
        cell.furnitureImage.image = UIImage(named: "OutdoorSofa1.png")
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ar", sender: desc[indexPath.row])
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        product.delegate = self
        product.dataSource = self
    }

    
}
