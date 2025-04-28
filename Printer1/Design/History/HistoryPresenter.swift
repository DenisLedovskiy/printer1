import UIKit

protocol HistoryPresenterInterface {
    func viewDidLoad(withView view: HistoryPresenterOutputInterface)
    func willAppear()
    func selectView(_ index: Int)
    func selectDelete(_ index: Int)
    func selectShare(_ index: Int)
    func selectFile(_ index: Int)
}

final class HistoryPresenter: NSObject {

    private weak var view: HistoryPresenterOutputInterface?
    private var router: HistoryRouterInterface

    private let printerDS: PrinterCDDataSource = Store.viewContext.printeDS

    private var allFiles = [FileModel]()

    init(router: HistoryRouterInterface) {
        self.router = router
    }
}

private extension HistoryPresenter {
    func fetchFiles(_ completion: (() -> Void)? = nil) {
        printerDS.fetch { result in
            switch result {
            case .fail(let error): print("Error: ", error)
            case .success:
                print("Success fetch Files. Count = \(self.printerDS.count)")
                if self.printerDS.count > 0 {
                    let files = self.printerDS.getAllFileModel()
                    self.allFiles = files
                    self.view?.setFiles(self.makeCellModels(files))
                } else {
                    self.allFiles = [FileModel]()
                    self.view?.setFiles([HistoryCellModel]())
                }
                completion?()
            }
        }
    }

    func makeCellModels(_ data: [FileModel]) -> [HistoryCellModel] {
        return data.map({
            HistoryCellModel(date: makeDateString($0.date),
                             title: $0.title,
                             type: $0.type)
        })
    }

    func makeDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy HH:mm"
        return dateFormatter.string(from: date)
    }

    func deleteFromFolder(index: Int) {
        let file = allFiles[index]
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found!")
            return
        }

        let fileURL = documentsDirectory.appendingPathComponent("\(file.title).\(file.type)")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("Файл удален успешно!")
            } catch {
                print("Ошибка удаления файла: \(error)")
            }
        } else {
            print("Файл не найден!")
        }
    }
}

// MARK: - HistoryPresenterInterface

extension HistoryPresenter: HistoryPresenterInterface {
    func selectFile(_ index: Int) {
        view?.getSelectFile(allFiles[index])
    }
    
    func selectView(_ index: Int) {
        let file = allFiles[index]
        if file.type == "" {
            router.routeBroweser(file.title)
        } else {
            router.routeDocPreview(file: file)
        }
    }
    
    func selectDelete(_ index: Int) {
        let file = allFiles[index]
        if file.type != "" {
            deleteFromFolder(index: index)
        }
        fetchFiles() {
            let files = self.printerDS.getFilesList()
            if let indexCD = files.firstIndex(where: {$0.id == file.id}) {
                Store.viewContext.deleteFromCD(object: files[indexCD]) { result in
                    switch result {
                    case .fail(let error): print("Error: ", error)
                    case .success: print("Succes delete from CoreData")
                        self.fetchFiles()
                    }
                }
            }
        }
    }
    
    func selectShare(_ index: Int) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let file = allFiles[index]
        if file.type == "" {
            guard let url = URL(string: file.title) else {return}
            router.routeShare(url)
        } else {
            let name = "\(file.title).\(file.type)"
            guard let fileURL = documentsDirectory?.appendingPathComponent(name) else {return}
            router.routeShare(fileURL)
        }
    }
    
    func willAppear() {
        fetchFiles()
    }
    
    func viewDidLoad(withView view: HistoryPresenterOutputInterface) {
        self.view = view
    }
}
