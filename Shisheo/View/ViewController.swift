//
//  ViewController.swift
//  Shisheo
//
//  Created by Arina Nefedova on 26.07.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
        
    private let cellId = "cell"
    
    private var cellNib : UINib {
        let cellNibName = "CollectionViewCell"
        let nib = UINib(nibName: cellNibName, bundle: nil)
        return nib
    }
    
    private var placesViewModel = PlaceViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var places = PublishSubject<[Place]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesViewModel.requestData()
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Shisheo"
    }
    
    private func commonInit(){
        initCollectionView()
        hideKeyboard()
        observeViewModel()
    }
}

extension ViewController {
    func initCollectionView() {
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellId)
        if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    func observeViewModel() {
        
        placesViewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    print("internetError ", message)
                case .serverMessage(let message):
                    print("serverMessage ", message)
                }
            })
            .disposed(by: disposeBag)
        
        placesViewModel
            .places
            .observe(on: MainScheduler.instance)
            .bind(to: places)
            .disposed(by: disposeBag)
        
        
        places.bind(to: collectionView.rx.items(cellIdentifier: cellId, cellType: CollectionViewCell.self)) {  (row, place, cell) in
                cell.place = place
                cell.starsStackView.isHidden = true
            }
        .disposed(by: disposeBag)
        

        collectionView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)
    }
}
