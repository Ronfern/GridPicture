//
//  PhotoViewPresenter.swift
//  GridPicture
//
//  Created by Роман Чугай on 29.11.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import UIKit

protocol PhotoPresentationLogic: class {
  func presentPhotos(_ response: ListPhotos.FetchPhotos.Response)
}

final class PhotoViewPresenter: PhotoPresentationLogic {
    
    weak var viewController: PhotoFetchedLogic?
    private var viewModel = ListPhotos.FetchPhotos.ViewModel(displayedPhotos: [])
    
    func presentPhotos(_ response: ListPhotos.FetchPhotos.Response) {
        
        var displayedOrders: [ListPhotos.FetchPhotos.ViewModel.DisplayedPhotos] = []
        for item in response.photos {
            let displayedOrder = ListPhotos.FetchPhotos.ViewModel.DisplayedPhotos(small: item.urls!.small!, regular: item.urls!.regular!, full: item.urls!.full!)
          displayedOrders.append(displayedOrder)
        }
        viewModel.displayedPhotos.append(contentsOf: displayedOrders)
        if response.photos.isEmpty {
            viewModel.displayedPhotos.removeAll()
        }
        viewController?.displayUser(viewModel: viewModel)
    }
}

