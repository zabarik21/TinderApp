//
//  InterestsCollectionViewController.swift
//  TinderApp
//
//  Created by Timofey on 3/7/22.
//

import UIKit

class InterestsCollectionViewController: UICollectionViewController {

  private let cellIdentifier: String = "interestCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCell()
    
  }
  
  private func registerCell() {
    self.collectionView.register(UINib(nibName: "InterestCell", bundle: nil), forCellWithReuseIdentifier: "interestCell")
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCell", for: indexPath) as? InterestCell else { return UICollectionViewCell() }
    return cell
  }
}
