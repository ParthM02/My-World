//
//  NoteCollectionViewCell.swift
//  My World
//
//  Created by Parth Mehta on 1/30/24.
//

//Import for UI
import UIKit

//Note object stuff

//Constructor
class NoteCollectionViewCell: UICollectionViewCell {
    //String for label in note cell
    @IBOutlet weak var mNoteLabel: UILabel!
    
    //initializes the label
    func initializeCell(noteText: String) {
        mNoteLabel.text = noteText
    }
}
