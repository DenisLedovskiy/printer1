import PanModal
import UIKit
import MobileCoreServices

protocol AddPrinterVCDelegate: AnyObject {

}

final class AddPrinterVC: GeneralViewController {

    weak var delegate: AddPrinterVCDelegate?

    private var sections: [AddPrinterSection] = [AddPrinterSection]()
    private lazy var dataSource = makeDataSource()

    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<AddPrinterSection, AddPrinterCellModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<AddPrinterSection, AddPrinterCellModel>

    //MARK: - UI
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.close, for: .normal)
        button.setImage(.close, for: .highlighted)
        button.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = perevod("Add a Printer")
        label.font = .dmSans(.heavy, size: 22)
        label.textColor = .prBlack
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .apTopImg
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()

    private lazy var lookingLabel: UILabel = {
       let label = UILabel()
        label.text = perevod("Looking for Printers...")
        label.font = .dmSans(.heavy, size: 22)
        label.textColor = .prBlack
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var bottomLabel: UILabel = {
       let label = UILabel()
        label.text = perevod("Select a printer model first to release the print job")
        label.font = .dmSans(.semibold, size: 18)
        label.textColor = .subtitleGray
        label.numberOfLines = 2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var guideView: GuideView = {
        let view = GuideView()
        view.didTap = {
            self.openGuide()
        }
        return view
    }()

    private lazy var refreshButton: GradientButton = {
        let button = GradientButton()
        button.setTitle(perevod("Refresh"))
        button.addTarget(self, action: #selector(tapRefresh), for: .touchUpInside)

        button.setCornerRadius(20)

        button.layer.shadowRadius = 18
        button.layer.shadowOpacity = 1
        button.layer.shadowColor = UIColor.gradient1.withAlphaComponent(0.29).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 11)
        button.clipsToBounds = false

        button.isHidden = true
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.isHidden = true
        collectionView.contentInset.bottom = 80
        AddPrinterCell.register(collectionView)
        return collectionView
    }()


    //MARK: -  Lifecicle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(true)
        hideNavBar(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        congifureConstraits()

        //TODO: - переделать заполнение секции
        let items = [AddPrinterCellModel(title: "adas Sd adas das das  ad"),
                     AddPrinterCellModel(title: "adas Sd adas das das  ad d asdsa d asd asd a"),
                     AddPrinterCellModel(title: "adas Sd adas das das  ad")]
        let sections = AddPrinterSection.makeSection(items)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.makeCollectionImg()
//            self.collectionView.isHidden = false
//            self.setSections(sections)

//            self.startSearchPrinters()
        }
    }

}

//MARK: - Printer search
extension AddPrinterVC: UIPrintInteractionControllerDelegate {

    func startSearchPrinters() {
//        let printerPicker = UIPrinterPickerController(initiallySelectedPrinter: nil)
//        printerPicker.selectPrinter(nil) { (printer, error) in
//
//            if let error = error {
//                print("Error fetching printers: \(error)")
//                return
//            }
//
//            guard let printer = printer else {
//                print("No printer selected.")
//                return
//            }
//
//            print("Printer Name: \(printer.displayName)")
//            print("Printer URL: \(printer.url?.absoluteString ?? "No URL")")
//        }
//    }





    }

    // Реализация делегата для получения выбранного принтера
    func printInteractionControllerChoosePaper(_ controller: UIPrintInteractionController) -> UIPrintPaper? {
        // Возвращаем выбранный лист бумаги (необязательно)
        return nil
    }

    func printInteractionControllerWillStartJob(_ printInteractionController: UIPrintInteractionController) {
        // Здесь можно обработать событие начала задания печати
    }

    func printInteractionControllerDidFinishJob(_ printInteractionController: UIPrintInteractionController) {
        // Обработка завершения задания печати
    }

    func printInteractionControllerParentViewController(_ printInteractionController: UIPrintInteractionController) -> UIViewController? {
        return self
    }
}

//MARK: - Private
private extension AddPrinterVC {

    @objc func tapClose() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        close()
    }

    func close() {
        dismiss(animated: true)
    }

    func openGuide() {
        let vc = FAQVC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }

    @objc func tapRefresh() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        bottomLabel.text = perevod("Select a printer model first to release the print job")
        lookingLabel.text = perevod("Looking for Printers...")
        refreshButton.isHidden = true
    }

    func setRefreshState() {
        refreshButton.isHidden = false
        bottomLabel.text = perevod("Double-check that your printer is on and connected, then try again")
        lookingLabel.text = perevod("No printers found")
        makeEmptyImg()
    }
}

//MARK: - Collection

private extension AddPrinterVC {

    // MARK: - makeDataSource
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                let cell = AddPrinterCell.getCell(collectionView, for: indexPath)
                cell.setCell(item)
                return cell
            })
        return dataSource
    }

    // MARK: - makeLayout
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        return UICollectionViewCompositionalLayout(sectionProvider: { [self] section, _ in
            makeTableLayout(size: AddPrinterCell.size)
        }, configuration: configuration)
    }

    func makeTableLayout(size: CGSize,
                         interGroupSpace: CGFloat = 16,
                         leftRightInset: CGFloat = 22,
                         topInset: CGFloat = 0) -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(size.width),
                                              heightDimension: .absolute(size.height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, repeatingSubitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpace
        section.contentInsets = .init(top: topInset,
                                      leading: leftRightInset,
                                      bottom: 0,
                                      trailing: leftRightInset)
        return section
    }

    private func setSections(_ section: [AddPrinterSection]) {
        self.sections = section
        applySnapshot()
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

extension AddPrinterVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        let rows = collectionView.numberOfItems(inSection: indexPath.section)
        let selectRow = indexPath.row
        guard rows > 0 else {return}
        for row in 0...rows {
            let indexPathCell = IndexPath(row: row, section: indexPath.section)
            guard let cell = collectionView.cellForItem(at: indexPathCell) as? AddPrinterCell else {
                return
            }
            row == selectRow ? cell.setIsSelected(true) : cell.setIsSelected(false)
        }
    }
}


//MARK: - UI
private extension AddPrinterVC {

    func congifureConstraits() {

        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(topImageView)
        view.addSubview(lookingLabel)
        view.addSubview(collectionView)
        view.addSubview(bottomLabel)
        view.addSubview(refreshButton)
        view.addSubview(guideView)

        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(28)
            $0.leading.trailing.equalToSuperview().inset(60)
        })

        backButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().inset(25)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(34)
        })

        makeEmptyImg()

        lookingLabel.snp.makeConstraints({
            $0.top.equalTo(topImageView.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(40)
        })

        bottomLabel.snp.makeConstraints({
            $0.top.equalTo(lookingLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(40)
        })

        guideView.snp.makeConstraints({
            $0.height.equalTo(74)
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        })

        refreshButton.snp.makeConstraints({
            $0.height.equalTo(refreshButton.height)
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.bottom.equalTo(guideView.snp.top).offset(-14)
        })

        collectionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(guideView.snp.bottom)
            $0.top.equalTo(bottomLabel.snp.bottom).offset(18)
        })

    }

    func makeEmptyImg() {
        let width = screeneWidth - 30 - 38
        let height = width * 0.9754
        topImageView.snp.remakeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(70)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(38)
            $0.height.equalTo(height)
        })
    }

    func makeCollectionImg() {
        let width = screeneWidth - 118
        let height = width * 0.9781
        topImageView.snp.remakeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(59)
            $0.trailing.equalToSuperview().inset(59)
            $0.height.equalTo(height)
        })
    }

}

// MARK: - PanModalPresentable
extension AddPrinterVC: PanModalPresentable {
    var shortFormHeight: PanModalHeight {
        .maxHeightWithTopInset(20)
    }

    var panScrollable: UIScrollView? {
        nil
    }

    var panModalBackgroundColor: UIColor {
        .black.withAlphaComponent(0.5)
    }

    var cornerRadius: CGFloat {
        42.0
    }

    var showDragIndicator: Bool { false }
}
