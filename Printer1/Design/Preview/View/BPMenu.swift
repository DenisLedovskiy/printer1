import UIKit

final class BPMenu: UIView {

    var didTap: ((Int) -> Void)?

    var isPDF: Bool = false

    // MARK: - properties

    typealias DataSource = UICollectionViewDiffableDataSource<BPSection, BPCellModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<BPSection, BPCellModel>

    private lazy var dataSource = makeDataSource()
    private var sections: [BPSection] = [BPSection]()

    // MARK: - views

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        BPCell.register(collectionView)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }

    func setCollection() {
        if isPDF {
            sections = BPSection.setPDF()
        } else {
            sections = BPSection.setDoc()
        }
        applySnapshot()
    }
}

private extension BPMenu {

    // MARK: - makeDataSource
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                let cell = BPCell.getCell(collectionView, for: indexPath)
                cell.configCell(item)
                return cell
            })
        return dataSource
    }

    func makeLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        return UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            if self.isPDF {
                return self.makeMenu(3, left: 32, right: 32)
            } else {
                return self.makeMenu(2, left: 32, right: 32)
            }
        }, configuration: configuration)
    }

    func makeMenu(_ count: Int, left: CGFloat, right: CGFloat) -> NSCollectionLayoutSection {
        var width: CGFloat = (screeneWidth - left - right)/CGFloat(count)
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(width),
                                              heightDimension: .absolute(width))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupWidth: CGFloat = width * CGFloat(count)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(groupWidth),
            heightDimension: .absolute(BPCell.size.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: count)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0,
                                      leading: left,
                                      bottom: 0,
                                      trailing: right)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }

    private func applySnapshot(animatingDifferences: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - UICollectionViewDelegate

extension BPMenu: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        didTap?(indexPath.row)
    }
}

private extension BPMenu {

    func customInit() {
        backgroundColor = .white

        layer.shadowOpacity = 1
        layer.shadowRadius = 30
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor

        addSubview(collectionView)

        collectionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(BPCell.size.height)
            $0.top.equalToSuperview().offset(16)
        })
    }
}
