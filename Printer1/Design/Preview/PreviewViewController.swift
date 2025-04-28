import UIKit
import PhotosUI
import Photos
import VisionKit
import AVFoundation
import WebKit
import PDFKit
import QuickLook

protocol PreviewPresenterOutputInterface: AnyObject {
    func reloadPDF()
}

final class PreviewViewController: GeneralViewController {

    private var presenter: PreviewPresenterInterface?
    private var router: PreviewRouterInterface?

    private var file: FileModel
    var fileURL: URL!

    //MARK: - UI
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.interpolationQuality = .low
        pdfView.backgroundColor = .clear
        return pdfView
    }()

    private lazy var backBtn: UIButton = {
        let button = UIButton()
        button.setImage(.brBack, for: .normal)
        button.setImage(.brBack, for: .highlighted)
        button.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .dmSans(.heavy, size: 22)
        label.textColor = .prBlack
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 30
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.07).cgColor
        view.clipsToBounds = false
        return view
    }()

    private lazy var bottomView: BPMenu = {
        let view = BPMenu()
        view.didTap = { menuIndex in
            self.selectMenu(index: menuIndex)
        }
        return view
    }()

//MARK: - Init
    init(file: FileModel, presenter: PreviewPresenterInterface, router: PreviewRouterInterface) {
        self.presenter = presenter
        self.router = router
        self.file = file
        super.init(nibName: nil,bundle: nil)
        self.titleLabel.text = file.title
    }

    required init?(coder: NSCoder) {
        self.file = FileModel(id: UUID(), title: "", type: "", date: Date())
        super.init(coder: coder)
    }

    //MARK: -  Lifecicle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(true)
        hideNavBar(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
    }
}

// MARK: - PreviewPresenterOutputInterface

extension PreviewViewController: PreviewPresenterOutputInterface {
    func reloadPDF() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "\(file.title).\(file.type)"
        if let fileURL = documentsDirectory?.appendingPathComponent(fileName) {
            let newPdfDoc = PDFDocument(url: fileURL)
            pdfView.document = newPdfDoc
        }
    }
}

//MARK: - Private
private extension PreviewViewController {

    @objc func tapBack() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        close()
    }

    func close() {
        navigationController?.popViewController(animated: true)
    }

    func routeInApp() {
        let vc = InAppInit.createViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }

    func selectMenu(index: Int) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "\(file.title).\(file.type)"
        guard let fileURL = documentsDirectory?.appendingPathComponent(fileName) else {return}

        switch index {
        case 0:
            guard MoneyManager.shared.isPremium else {
                routeInApp()
                return
            }

            self.fileURL = fileURL
            let previewController = QLPreviewController()
            previewController.dataSource = self
            present(previewController, animated: true, completion: nil)
        case 1:
            guard MoneyManager.shared.isPremium else {
                routeInApp()
                return
            }
            
            let printController = UIPrintInteractionController.shared
            printController.delegate = self
            if file.type == "pdf" {
                printController.printingItem = fileURL
            } else {
                let renderer = UIPrintPageRenderer()
                renderer.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAt: 0)
                printController.printPageRenderer = renderer
            }
            printController.printInfo = UIPrintInfo(dictionary: nil)
            printController.printInfo?.outputType = .general
            printController.present(animated: true, completionHandler: nil)
        case 2:
            showAddMenu()
        default: return
        }
    }
}

//MARK: - UIDocumentInteractionControllerDelegate
extension PreviewViewController: UIDocumentInteractionControllerDelegate {

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

// MARK: - QLPreviewControllerDataSource
extension PreviewViewController: QLPreviewControllerDataSource {

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return fileURL as QLPreviewItem
    }
}


//MARK: - UIPrintInteractionControllerDelegate
extension PreviewViewController: UIPrintInteractionControllerDelegate {

}


// MARK: - UISetup

private extension PreviewViewController {
    func customInit() {
        if file.type == "pdf" {
            view.addSubview(pdfView)
        } else {
            view.addSubview(webView)
        }

        view.addSubview(topView)
        topView.addSubview(backBtn)
        topView.addSubview(titleLabel)
        view.addSubview(bottomView)

        topView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(isSmallPhone ? 110 : 140)
        })

        titleLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.bottom.equalToSuperview().offset(-18)
        })

        backBtn.snp.makeConstraints({
            $0.size.equalTo(27)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalToSuperview().offset(14)
        })

        bottomView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(110)
        })

        if file.type == "pdf" {
            pdfView.snp.makeConstraints({
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(bottomView.snp.top)
                $0.top.equalTo(topView.snp.bottom)
            })


            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileName = "\(file.title).\(file.type)"
            if let fileURL = documentsDirectory?.appendingPathComponent(fileName) {
                let newPdfDoc = PDFDocument(url: fileURL)
                pdfView.document = newPdfDoc
            }

            bottomView.isPDF = true
        } else {
            webView.snp.makeConstraints({
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(bottomView.snp.top)
                $0.top.equalTo(topView.snp.bottom)
            })

            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileName = "\(file.title).\(file.type)"
            if let fileURL = documentsDirectory?.appendingPathComponent(fileName) {
                let request = URLRequest(url: fileURL)
                webView.load(request)
            }

            bottomView.isPDF = false
        }
        bottomView.setCollection()
    }
}


// MARK: - ActionSheet
private extension PreviewViewController {
    func showAddMenu() {
        let alertStyle = UIAlertController.Style.actionSheet

        let alert = UIAlertController(title: "",
                                      message: perevod("Import from"),
                                      preferredStyle: alertStyle)

        alert.addAction(UIAlertAction(title: perevod("From your Camera"),
                                      style: .default,
                                      handler: { [self] (UIAlertAction) in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.scanCamera()
        }))
        alert.addAction(UIAlertAction(title: perevod("From your Gallery"),
                                      style: .default,
                                      handler:{ (UIAlertAction) in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.checkPhotoLibraryPermission()
        }))
        alert.addAction(UIAlertAction(title: perevod("From your Files"),
                                      style: .default,
                                      handler:{ (UIAlertAction)in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.selectPDF()
        }))

        alert.addAction(UIAlertAction(title: perevod("Cancel"),
                                      style: .cancel,
                                      handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: { })
        }
    }
}

//MARK: - All pickers
private extension PreviewViewController {

    func convertImagesToPDF(_ images: [UIImage]) {
        guard let currentPDF = pdfView.document else { return }
        presenter?.addImgToPDF(title: file.title,
                               pdf: currentPDF,
                               images: images)
    }

    func sheckCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
           case .authorized:
            DispatchQueue.main.async {
                self.scanCamera()
            }
           case .notDetermined:
               AVCaptureDevice.requestAccess(for: .video) { granted in
                   if granted {
                       DispatchQueue.main.async {
                           self.scanCamera()
                       }
                   } else {
                       self.showErrorSettingAlert(title: perevod("Sorry"),
                                                  message: perevod("Allow the app to access your phone's camera to scan and document."))
                   }
               }
           case .denied, .restricted:
            self.showErrorSettingAlert(title: perevod("Sorry"),
                                       message: perevod("Allow the app to access your phone's camera to scan and document."))
           default:
            self.showErrorSettingAlert(title: perevod("Sorry"),
                                       message: perevod("Allow the app to access your phone's camera to scan and document."))
           }
    }

    func scanCamera() {
        let scanerVC = VNDocumentCameraViewController()
        scanerVC.delegate = self
        present(scanerVC, animated: true)
    }

    func checkPhotoLibraryPermission() {
           switch PHPhotoLibrary.authorizationStatus() {
           case .authorized:
               DispatchQueue.main.async {
                   self.presentPhotoPicker()
               }
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
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0
        configuration.selection = .ordered

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    func selectPDF() {
        let documentPicker = UIDocumentPickerViewController(
            forOpeningContentTypes: [.pdf],
            asCopy: true
        )
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true, completion: nil)
    }

}

//MARK: - VNDocumentCameraViewControllerDelegate

extension PreviewViewController: VNDocumentCameraViewControllerDelegate {
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
extension PreviewViewController: PHPickerViewControllerDelegate {
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
extension PreviewViewController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let sourceUrl = urls.first else { return }

        guard let pdfFromFile = PDFDocument(url: sourceUrl),
              let pdfDoc1 = pdfView.document else {return}

        presenter?.needSplitPDF(title: file.title, pdf1: pdfDoc1, pdf2: pdfFromFile)
    }
}
