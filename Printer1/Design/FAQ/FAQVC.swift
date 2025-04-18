import UIKit

final class FAQVC: GeneralViewController {

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

private extension FAQVC {

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

extension FAQVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }
}


//MARK: - UI
private extension FAQVC {

    func congifureConstraits() {

        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(collectionView)

        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(28)
            $0.leading.trailing.equalToSuperview().inset(60)
        })

        backButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().inset(25)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(34)
        })

        collectionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(guideView.snp.bottom)
            $0.top.equalTo(bottomLabel.snp.bottom).offset(18)
        })

    }
}
