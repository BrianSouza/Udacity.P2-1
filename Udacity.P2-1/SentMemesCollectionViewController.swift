//
//  SentMemesCollectionViewController.swift
//  Udacity.P2-1
//
//  Created by Brian Diego De Souza on 06/11/18.
//  Copyright © 2018 Array App. All rights reserved.
//

import Foundation
import UIKit


class SentMemesCollectionViewController : UICollectionViewController {
    
    var memes: [Meme]!
    
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iniciarFlowLayout(UIDevice.current.orientation.isLandscape)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        colView?.reloadData()
    }
    
    
    func iniciarFlowLayout(_ celularDeitado : Bool) {
        let space:CGFloat = 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        
        let height : CGFloat
        let width : CGFloat
        
        if celularDeitado {
            width = (view.frame.size.width - (2 * space)) / 3.0
            height = (view.frame.size.height - (2 * space)) / 3.0
        } else {
            height = (view.frame.size.width - (2 * space)) / 3.0
            width = (view.frame.size.height - (2 * space)) / 3.0
        }
        flowLayout.itemSize = CGSize(width: height, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customMemeCell", for: indexPath) as! CustomMemeCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.memeImageView?.image = meme.imgNova
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    /*
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "vcCriadorMeme") as! vcCriadorMeme
        
        //Populate view controller with data from the selected item
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
 */
        
        performSegue(withIdentifier: "colDetailSegue", sender: memes[indexPath.row])
        /*
        performSegue(withIdentifier: "editColSegue", sender: memes[indexPath.row])
        */
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "colDetailSegue" {
            let meme: Meme = sender as! Meme
            let detailVC = segue.destination as! vcVisulizar
            detailVC.meme = meme
        }
        /*
        if segue.identifier == "editColSegue"{
            let meme: Meme = sender as! Meme
            let criadorMeme = segue.destination as! vcCriadorMeme
            criadorMeme.meme = meme
        }
         */
    }
}
