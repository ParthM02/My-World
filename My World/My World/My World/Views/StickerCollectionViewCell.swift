//
//  StickerCollectionViewCell.swift
//  My World
//
//  Created by Parth Mehta on 1/30/24.
//

//Import for UI
import UIKit

//Obect file for Sticker

//Contructor
class StickerCollectionViewCell: UICollectionViewCell {
    
    //Variable for label in sticker cell
    @IBOutlet weak var mStickLabel: UILabel!
    
    //Initializes the sticker
    func initializeCell(stickText: String) {
        mStickLabel.text = stickText
    }
}
