//
//  ViewController.swift
//  GridPicture
//
//  Created by Роман Чугай on 26.08.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import UIKit
import Nuke
import RxCocoa
import RxSwift

class PhotoViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionGrid: UICollectionView! {
        didSet {
            collectionGrid.register(UINib(nibName: String(describing: PhotoProductCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PhotoProductCell.self))
        }
    }
    
    private let bag = DisposeBag()
    private var model: PhotoViewModelType! = PhotoViewModel(dataSource: PhotoDataSource())
    private var pageCount = 0
    private var load = true
    private var type: TypeCollection = .listPhotos
    
    enum TypeCollection {
        case listPhotos
        case findPhotos
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionGrid.rx.setDelegate(self).disposed(by: bag)
        bindTableView()
        pagination()
    }
    
    private func bindTableView() {
        model.rows.bind(to: collectionGrid.rx.items(cellIdentifier: String(describing: PhotoProductCell.self), cellType: PhotoProductCell.self)) { (row,item,cell) in
            let url = self.type == .listPhotos ? item.urls?.small : item.urls?.regular
            cell.setPictureToCell(pictureToCell: url)
        }.disposed(by: bag)
        
        collectionGrid.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { [self] in
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
//                    self.model.rows.subscribe { (item) in
//                        if indexPath.row == item.element!.count - 1 && item.element!.count < 300 && load {
//                            print("gg")
//                            if  type == .listPhotos {
//                                pagination()
//                            } else if searchBar.text!.count > 2 {
//                                paginationInSearch()
//                            }
//                        }
//                    }
        
    
                }, completion: nil)
            }))
            
            .disposed(by: bag)
        
        collectionGrid.rx.modelSelected(PhotoModel.self).subscribe(onNext: { item in
            if let urls =  item.urls {
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as? DetailViewController {
                    viewController.photoModel = urls.full
                    if let navigator = self.navigationController {
                        navigator.pushViewController(viewController, animated: true)
                    }
                }
            }
        }).disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
        
    fileprivate func pagination() {
        load = false
        pageCount += 1
        model.loadData(pageNumber: pageCount)
    }
    fileprivate func paginationInSearch() {
        load = false
        pageCount += 1
        model.findData(pageNumber: pageCount, text: searchBar.text!)
    }

}
extension PhotoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            type = .listPhotos
            cleanRows()
            pagination()
        }
        
        if searchBar.text!.count > 3 {
            type = .findPhotos
//            if  model.rows.count <= 300 && load  == true {
                cleanRows()
                paginationInSearch()
         //   }
        }
    }
    
    private func cleanRows() {
        model.cleanRows()
        pageCount = 0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() 
    }
}
    

    
//extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//
// func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return model.rows.count
// }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoProductCell.self), for: indexPath) as! PhotoProductCell
//        if let pictureModel = model.rows.getElement(at: indexPath.row), let urls =  pictureModel.urls {
//            let url = type == .listPhotos ? urls.small : urls.regular
//            cell.setPictureToCell(pictureToCell: url)
//            return cell
//        }
//
//        return UICollectionViewCell()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let pictureModel = model.rows.getElement(at: indexPath.row), let urls =  pictureModel.urls {
//          if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as? DetailViewController {
//            viewController.photoModel = urls.full
//                if let navigator = navigationController {
//                    navigator.pushViewController(viewController, animated: true)
//                }
//            }
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == model.rows.count - 1 && model.rows.count < 300 && load {
//            if  type == .listPhotos {
//                pagination()
//            } else if searchBar.text!.count > 2 {
//                paginationInSearch()
//            }
//        }
//    }
//}


extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets.init(top: 0, left: 10, bottom: 15, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch type {
        case .listPhotos:
            return CGSize.init(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height / 12)
        case .findPhotos:
            return CGSize.init(width: collectionView.frame.size.width / 1.1, height: collectionView.frame.size.height)
        }
        
    }
}
