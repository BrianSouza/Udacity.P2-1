//
//  SentMemesTableViewController.swift
//  Udacity.P2-1
//
//  Created by Brian Diego De Souza on 08/11/18.
//  Copyright © 2018 Array App. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController : UITableViewController{
    var memes : [Meme]!
    
    @IBOutlet weak var tbView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        tbView?.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! SentMemesTableViewCell
        
        tableViewCell.topoLabel?.text = "\(memes[indexPath.row].topo )"
        tableViewCell.bottomLabel?.text = "\( memes[indexPath.row].bottom )"
        tableViewCell.imgMeme?.image = memes[indexPath.row].imgOriginal
        
        return tableViewCell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tvDetailSegue", sender: memes[indexPath.row])
        /*
        performSegue(withIdentifier: "editTableSegue", sender: memes[indexPath.row])
         */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tvDetailSegue" {
            let meme: Meme = sender as! Meme
            let detailVC = segue.destination as! vcVisulizar
            detailVC.meme = meme
        }
        /*
        if segue.identifier == "editTableSegue" {
            let meme: Meme = sender as! Meme
            let criadorVC = segue.destination as! vcCriadorMeme
            criadorVC.meme = meme
        }
        */
    }
}
