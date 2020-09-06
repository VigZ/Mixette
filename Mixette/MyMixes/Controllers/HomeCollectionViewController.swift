//
//  HomeCollectionViewController.swift
//  Mixette
//
//  Created by Kyle on 9/5/20.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit
import CoreData


class HomeCollectionViewController: UICollectionViewController {
    
    var mixes = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mixes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MixCell", for: indexPath) as! MixCell
    
        let mix = mixes[indexPath.row]
        cell.titleLabel.text =
          mix.value(forKeyPath: "title") as? String
        
        return cell
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      fetchMixes()
     
    }
    
    func fetchMixes(){
         guard let appDelegate =
           UIApplication.shared.delegate as? AppDelegate else {
             return
         }
         
         let managedContext =
           appDelegate.persistentContainer.viewContext
         
         let fetchRequest =
           NSFetchRequest<NSManagedObject>(entityName: "Mixtape")
         
         do {
           mixes = try managedContext.fetch(fetchRequest)
         } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
         }
    }
    
   override func collectionView(_ collectionView: UICollectionView,
                                didSelectItemAt indexPath: IndexPath){
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailTable") as! DetailTableViewController
        vc.mixtape = mixes[indexPath.item] as! Mixtape
        navigationController?.pushViewController(vc, animated: true)
    
    }


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    func saveMix(title: String) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      let entity =
        NSEntityDescription.entity(forEntityName: "Mixtape",
                                   in: managedContext)!
      
      let mix = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      mix.setValue(title, forKeyPath: "title")
      
      do {
        try managedContext.save()
        mixes.append(mix)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }

}
