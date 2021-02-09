import Foundation


protocol ViewModelType: class {
    func loadData(pageNumber: Int)
    func findData(pageNumber: Int, text: String)
    func cleanRows()
}

 class PhotoInteractor: ViewModelType {

    var presenter: PhotoPresentationLogic?
    var dataSource: PhotoDataWorkerProtocol = PhotoDataWorker()
    
     func loadData(pageNumber: Int) {
        dataSource.fetchPhotos(pageNumber: pageNumber) {result in
            DispatchQueue.main.async {
                self.presenter?.presentPhotos(ListPhotos.FetchPhotos.Response(photos: result))
            }
        }
    }
    
    func cleanRows() {
    //    presenter?.presentUser([])
    }
    
    func findData(pageNumber: Int, text: String) {
        dataSource.findPhotos(searchText: text, pageNumber: pageNumber) { result in
            DispatchQueue.main.async {
                self.presenter?.presentPhotos(ListPhotos.FetchPhotos.Response(photos: result))
            }
        }
    }
    
}
