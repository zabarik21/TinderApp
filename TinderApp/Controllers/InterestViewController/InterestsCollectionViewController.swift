//
//  InterestsCollectionViewController.swift
//  TinderApp
//
//  Created by Timofey on 3/7/22.
//

import UIKit

class InterestsCollectionViewController: UICollectionViewController {

  typealias InterestPair = (interest: Interest, match: Bool)
  
  private let cellIdentifier: String = "interestCell"
  private var isChoosable = false
  public var interests: [InterestPair] = [] {
    didSet {
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCell()
    self.collectionView.backgroundColor = .peopleViewControllerBackground
    self.collectionView.showsHorizontalScrollIndicator = false
  }
  
  func changeStyleToChoosable() {
    isChoosable = true
    collectionView.backgroundColor = .white.withAlphaComponent(0.8)
    collectionView.layer.cornerRadius = 10
    collectionView.layer.masksToBounds = true
  }
  
  
  private func registerCell() {
    self.collectionView.register(UINib(nibName: "InterestCell", bundle: nil), forCellWithReuseIdentifier: "interestCell")
  }
  
}

extension InterestsCollectionViewController {
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard isChoosable == true else { return }
    
  }
}

// MARK: - DataSource

extension InterestsCollectionViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return interests.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCell", for: indexPath) as? InterestCell else { return UICollectionViewCell() }
    let interest = interests[indexPath.row].interest
    let match = interests[indexPath.row].match
    cell.configure(with: interest, matching: match)
    return cell
  }
  
}
// MARK: - Layout
extension InterestsCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 15
  }
  
}
