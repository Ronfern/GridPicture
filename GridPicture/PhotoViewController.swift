//
//  ViewController.swift
//  GridPicture
//
//  Created by Роман Чугай on 26.08.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import UIKit
import Nuke

protocol PhotoFetchedLogic: class {
    func displayUser(viewModel: ListPhotos.FetchPhotos.ViewModel)
}

class PhotoViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionGrid: UICollectionView! {
        didSet {
            collectionGrid.delegate = self
            collectionGrid.dataSource = self
            collectionGrid.register(UINib(nibName: String(describing: PhotoProductCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PhotoProductCell.self))
        }
    }
    
    private var model: [ListPhotos.FetchPhotos.ViewModel.DisplayedPhotos] = []
    private var pageCount = 0
    private var load = false
    private var type: TypeCollection = .listPhotos {
        didSet {
            cleanRows()
        }
    }
    var interactor: ViewModelType?
    
    enum TypeCollection {
        case listPhotos
        case findPhotos
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        pagination()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
        
    private func setup() {
      let interactor = PhotoInteractor()
      let presenter = PhotoViewPresenter()
      interactor.presenter = presenter
      presenter.viewController = self
      self.interactor = interactor
    }

    
    fileprivate func pagination() {
        load = false
        pageCount += 1
        if type == .listPhotos {
            interactor?.loadData(pageNumber: pageCount)
        } else {
            interactor?.findData(pageNumber: pageCount, text: searchBar.text!)
        }
    }

}

extension PhotoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            type = .listPhotos
        }
        
        if searchBar.text!.count > 3, model.count <= 300, load  == true {
            type = .findPhotos
        }
        cleanRows()
        pagination()
    }
    
    private func cleanRows() {
        interactor?.cleanRows()
        pageCount = 0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() 
    }
}
    

    
extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {

 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.count
 }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoProductCell.self), for: indexPath) as! PhotoProductCell
        if let pictureModel = model.getElement(at: indexPath.row) {
            let url = type == .listPhotos ? pictureModel.small : pictureModel.regular
            cell.setPictureToCell(pictureToCell: url)
            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let pictureModel = model.getElement(at: indexPath.row) {
          if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            viewController.photoModel = pictureModel.full
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }

    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == model.count - 1, model.count < 300 , load  || searchBar.text!.count > 2  {
            if  type == .listPhotos {
                self.pagination()
            }
        }
    }
}


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

extension PhotoViewController: PhotoFetchedLogic {
    func displayUser(viewModel: ListPhotos.FetchPhotos.ViewModel) {
        model = viewModel.displayedPhotos
        load = true
        DispatchQueue.main.async {
            self.collectionGrid.reloadData()
        }
    }
    
}
    

