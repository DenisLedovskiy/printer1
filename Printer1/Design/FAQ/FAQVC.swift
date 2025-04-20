import UIKit
import SafariServices

final class FAQVC: GeneralViewController {

    private var sections: [FAQSection] = FAQSection.makeSection()
    private lazy var dataSource = makeDataSource()

    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<FAQSection, FAQCellModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<FAQSection, FAQCellModel>

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
        label.text = "FAQ"
        label.font = .dmSans(.black, size: 25)
        label.textColor = .prBlack
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.contentInset.bottom = 80
        FAQCell.register(collectionView)
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
        applySnapshot()
    }

}
//MARK: - Private
private extension FAQVC {

    @objc func tapClose() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        close()
    }

    func close() {
        dismiss(animated: true)
    }

    func openLink() {
        guard let url = URL(string: "https://support.apple.com/en-us/HT201311") else {return}
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
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
                let cell = FAQCell.getCell(collectionView, for: indexPath)
                cell.setCell(item)
                cell.didTapLink = {
                    self.openLink()
                }
                return cell
            })
        return dataSource
    }

    // MARK: - makeLayout
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        return UICollectionViewCompositionalLayout(sectionProvider: { [self] section, _ in
            makeTableLayout(size: FAQCell.size)
        }, configuration: configuration)
    }

    func makeTableLayout(size: CGSize,
                         interGroupSpace: CGFloat = 16,
                         leftRightInset: CGFloat = 22,
                         topInset: CGFloat = 0) -> NSCollectionLayoutSection {

        let estimatedHeight: CGFloat = 50
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(size.width),
                                              heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpace
        section.contentInsets = .init(top: topInset,
                                      leading: leftRightInset,
                                      bottom: 0,
                                      trailing: leftRightInset)
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
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(36)
            $0.leading.equalToSuperview().offset(22)
        })

        backButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().inset(22)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(34)
        })

        collectionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
        })
    }
}
