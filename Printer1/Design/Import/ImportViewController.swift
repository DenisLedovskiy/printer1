import UIKit
import VisionKit
import PhotosUI
import Photos

protocol ImportPresenterOutputInterface: AnyObject {

}

final class ImportViewController: GeneralViewController {

    var printers = [String]()

    private var presenter: ImportPresenterInterface?
    private var router: ImportRouterInterface?

    private var sections: [ImportSection] = ImportSection.makeSection()
    private lazy var dataSource = makeDataSource()

    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<ImportSection, ImportCellModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ImportSection, ImportCellModel>

    //MARK: - UI Propery

    //MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = perevod("Air Printer")
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .prBlack
        label.font = .dmSans(.black, size: 30)
        return label
    }()

    private lazy var top: ImportTop = {
        let view = ImportTop()
        view.didSelect = {
            self.select()
        }
        return view
    }()

    private let importLabel: UILabel = {
        let label = UILabel()
        label.text = perevod("Import Files")
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .prBlack
        label.font = .dmSans(.heavy, size: 20)
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        ImportCell.register(collectionView)
        return collectionView
    }()

    //MARK: - Init
    init(presenter: ImportPresenterInterface, router: ImportRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: - Lifecicle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(false)
        hideNavBar(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
        applySnapshot()
        UserInfoManager.isNotFirstEnter = true
    }
}

// MARK: - ImportPresenterOutputInterface

extension ImportViewController: ImportPresenterOutputInterface {

}

// MARK: - Action

private extension ImportViewController {

    func select() {
        let pickerController = UIPrinterPickerController(initiallySelectedPrinter: nil)

        pickerController.present(animated: true) { (controller, completed, error) in
            if completed {
                var printer: UIPrinter? { return controller.selectedPrinter }
                self.selectedPrinter = printer
                self.top.setPrinterTitle(title: printer?.displayName ?? "")
            } else {
                print("Did not work")
            }
        }
    }
}

//MARK: - Printer search
extension ImportViewController: UIPrintInteractionControllerDelegate {

    func startSearchPrinters() {
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = .general

        let printController = UIPrintInteractionController.shared
        printController.delegate = self
        printController.printInfo = printInfo
        printController.present(animated: true, completionHandler: nil)
    }

    func printInteractionControllerChoosePaper(_ controller: UIPrintInteractionController) -> UIPrintPaper? {
        return nil
    }

    func printInteractionControllerWillStartJob(_ printInteractionController: UIPrintInteractionController) {
    }

    func printInteractionControllerDidFinishJob(_ printInteractionController: UIPrintInteractionController) {
    }

    func printInteractionControllerParentViewController(_ printInteractionController: UIPrintInteractionController) -> UIViewController? {
        return self
    }
}

//MARK: - Collection

private extension ImportViewController {

    // MARK: - makeDataSource
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                let cell = ImportCell.getCell(collectionView, for: indexPath)
                cell.setCell(item)
                return cell
            })
        return dataSource
    }

    // MARK: - makeLayout
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        return UICollectionViewCompositionalLayout(sectionProvider: { [self] section, _ in
            setGrid(ImportCell.size)
        }, configuration: configuration)
    }

    func setGrid(_ size: CGSize) -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(size.width),
                                              heightDimension: .absolute(size.height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(size.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(16)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = isSmallPhone ? 10 : 20
        section.contentInsets = .init(top: 0,
                                      leading: 22,
                                      bottom: 0,
                                      trailing: 22)
        return section
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - UICollectionViewDelegate

extension ImportViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        switch indexPath.row {
        case 0: scanCamera()
        case 1: checkPhotoLibraryPermission()
        case 2: openFiles()
        case 3: presenter?.selectBroweser()
        default: return
        }
    }
}

// MARK: - UISetup

private extension ImportViewController {
    func customInit() {
        view.addSubview(titleLabel)
        view.addSubview(top)
        view.addSubview(importLabel)
        view.addSubview(collectionView)

        titleLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(isSmallPhone ? 16 : 36)
            $0.leading.trailing.equalToSuperview().inset(22)
        })

        top.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(isSmallPhone ? 10 : 15)
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(147)
        })

        importLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.top.equalTo(top.snp.bottom).offset(isSmallPhone ? 12 : 22)
        })

        collectionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(importLabel.snp.bottom).offset(isSmallPhone ? 6 : 12)
            $0.bottom.equalToSuperview()
        })
    }
}

//MARK: - All pickers
private extension ImportViewController {

    func convertImagesToPDF(_ images: [UIImage]) {
        presenter?.doPdfFromImg(images)
    }

    func scanCamera() {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }

    func checkPhotoLibraryPermission() {
           switch PHPhotoLibrary.authorizationStatus() {
           case .authorized:
               presentPhotoPicker()
           case .notDetermined:
               PHPhotoLibrary.requestAuthorization { status in
                   DispatchQueue.main.async {
                       if status == .authorized {
                           self.presentPhotoPicker()
                       } else {
                           self.showErrorSettingAlert(title: perevod("Sorry"),
                                                      message: perevod("For this feature to work, please allow access to the gallery."))
                       }
                   }
               }
           default:
               self.showErrorSettingAlert(title: perevod("Sorry"),
                                          message: perevod("For this feature to work, please allow access to the gallery."))
           }
       }

    func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selection = .ordered
        config.filter = .images
        config.selectionLimit = 0

        let phpPicker = PHPickerViewController(configuration: config)
        phpPicker.delegate = self
        present(phpPicker, animated: true)
    }

    func openFiles() {
        let allowedUTTypes: [String] = [
            "com.microsoft.word.doc",
            "org.openxmlformats.wordprocessingml.document",
            "com.microsoft.excel.xls",
            "org.openxmlformats.spreadsheetml.sheet",
            "com.microsoft.powerpoint.ppt",
            "org.openxmlformats.presentationml.presentation",
            "com.adobe.pdf"
        ]

        let picker = UIDocumentPickerViewController(forOpeningContentTypes: allowedUTTypes.map { UTType($0)! })
        picker.delegate = self
        picker.modalPresentationStyle = .formSheet
        present(picker, animated: true, completion: nil)
    }

}

//MARK: - VNDocumentCameraViewControllerDelegate

extension ImportViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {

        var images: [UIImage] = []
        for pageIndex in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageIndex)
            images.append(image)
        }
        convertImagesToPDF(images)
        dismiss(animated: true)
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        dismiss(animated: true)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        dismiss(animated: true)
    }
}

//MARK: - PHPickerViewControllerDelegate
extension ImportViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        var selectedImages: [UIImage] = []

        let itemProviders = results.map { $0.itemProvider }
        let group = DispatchGroup()

        for item in itemProviders {
            group.enter()
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        selectedImages.append(image)
                    }
                    group.leave()
                }
            } else {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.convertImagesToPDF(selectedImages)
        }
    }
}

//MARK: - UIDocumentPickerDelegate
extension ImportViewController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let sourceUrl = urls.first,
              sourceUrl.startAccessingSecurityScopedResource(),
              let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        defer { sourceUrl.stopAccessingSecurityScopedResource() }

        let originalFileName = sourceUrl.lastPathComponent
        let uniqueFileName = setTitleForFile(originalFileName, in: documentsUrl)
        let destinationUrl = documentsUrl.appendingPathComponent(uniqueFileName)

        do {
            try FileManager.default.copyItem(at: sourceUrl, to: destinationUrl)
            print("Файл успешно сохранен по пути: \(destinationUrl.path)")

            let fileNameWithoutExtension = uniqueFileName.components(separatedBy: ".").first ?? ""
            let extensionString = uniqueFileName.components(separatedBy: ".").last ?? ""
            let file = FileModel(id: UUID(),
                                 title: fileNameWithoutExtension,
                                 type: extensionString.lowercased(),
                                 date: Date())
            presenter?.needShowPreview(file)
        } catch {
            print("Ошибка при сохранении файла: \(error.localizedDescription)")
        }
    }

    func setTitleForFile(_ fileTitle: String, in folder: URL) -> String {
        var currentFileName = fileTitle
        var index = 1

        while fileExists(at: folder.appendingPathComponent(currentFileName)) {
            currentFileName = appendIndexToFileName(fileTitle, index: index)
            index += 1
        }
        return currentFileName
    }

    private func appendIndexToFileName(_ fileName: String, index: Int) -> String {
        let components = fileName.components(separatedBy: ".")
        let baseName = components.first
        let extensionName = components.count > 1 ? "." + components.dropFirst().joined(separator: ".") : ""
        return "\(baseName ?? "docName")(\(index))\(extensionName)"
    }

    private func fileExists(at url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
}
