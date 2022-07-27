//
//  InterestsCollectionViewController.swift
//  TinderApp
//
//  Created by Timofey on 3/7/22.
//

import UIKit
import RxSwift
import RxRelay

class InterestsCollectionViewController: UICollectionViewController {
  
  typealias InterestPair = (interest: Interest, match: Bool)
  
  private var isChoosable = false
  var oneItemReload = false
  
  private var bag = DisposeBag()
  
  var interests: [InterestPair] = [] {
    didSet {
      if !oneItemReload {
        DispatchQueue.main.async {
          print("reload")
          self.collectionView.reloadData()
        }
      }
    }
  }
  
  var interestsRelay = BehaviorRelay<[InterestPair]>(value: [])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCell()
    setupObserver()
    self.collectionView.backgroundColor = .peopleViewControllerBackground
    self.collectionView.showsHorizontalScrollIndicator = false
    self.collectionView.showsVerticalScrollIndicator = false
  }
  
  func setupObserver() {
    interestsRelay
      .distinctUntilChanged({ fst, snd in
        return (!fst.isEmpty && !snd.isEmpty)
      })
      .subscribe(on: MainScheduler.instance)
      .subscribe { [weak self] pairs in
        self?.interests = pairs.element ?? []
      }
      .disposed(by: bag)
  }
  
  func changeStyleToChoosable() {
    isChoosable = true
    collectionView.backgroundColor = .white.withAlphaComponent(0.8)
    collectionView.layer.cornerRadius = 10
    collectionView.layer.masksToBounds = true
  }
  
  
  private func registerCell() {
    self.collectionView.register(
      UINib(
        nibName: String(describing: InterestCell.self),
        bundle: nil),
      forCellWithReuseIdentifier: InterestCell.cellIdentifier)
  }
  
}

// MARK: - Delegate
extension InterestsCollectionViewController {
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard isChoosable == true else { return }
    oneItemReload = true
    interests[indexPath.row].match.toggle()
    collectionView.reloadItems(at: [indexPath])
    oneItemReload = false
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
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "interestCell",
      for: indexPath) as? InterestCell else { return UICollectionViewCell() }
    let interest = interests[indexPath.row].interest
    let match = interests[indexPath.row].match
    cell.configure(with: interest, matching: match, interactionEnabled: self.isChoosable)
    return cell
  }
  
}
