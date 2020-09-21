//
//  ViewController.swift
//  Compositional
//
//  Created by Greg Spiers on 17/09/2020.
//  Copyright © 2020 Greg Spiers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let exerciseBug = true

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<String, Int>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupDataSource()
    }


    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(234), heightDimension: .absolute(340))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(39))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: SectionHeader.supplementaryViewKind,
                                                                        alignment: .top)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        if exerciseBug {
            section.orthogonalScrollingBehavior = .continuous
        }

        let layoutHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
        let layoutHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutHeaderSize, elementKind: LayoutHeader.supplementaryViewKind, alignment: .top)

        layoutHeader.zIndex = 2
        layoutHeader.pinToVisibleBounds = true

        let layoutFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
        let layoutFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutFooterSize, elementKind: LayoutFooter.supplementaryViewKind, alignment: .bottom)

        layoutFooter.zIndex = 2
        layoutFooter.pinToVisibleBounds = true

        let layoutConfiguration = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfiguration.interSectionSpacing = 8
        layoutConfiguration.scrollDirection = .vertical
        layoutConfiguration.boundarySupplementaryItems = [layoutHeader, layoutFooter]

        let layout = UICollectionViewCompositionalLayout(section: section, configuration: layoutConfiguration)

        return layout
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .purple

        collectionView.alwaysBounceVertical = true
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: SectionHeader.supplementaryViewKind, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(LayoutHeader.self, forSupplementaryViewOfKind: LayoutHeader.supplementaryViewKind, withReuseIdentifier: LayoutHeader.reuseIdentifier)
        collectionView.register(LayoutFooter.self, forSupplementaryViewOfKind: LayoutFooter.supplementaryViewKind, withReuseIdentifier: LayoutFooter.reuseIdentifier)
    }

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource <String, Int>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, thing: Int) -> UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath)

            return cell
        }

        dataSource.supplementaryViewProvider = { ( collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in

            switch kind {
            case SectionHeader.supplementaryViewKind:
                let headerView: SectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: SectionHeader.supplementaryViewKind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as! SectionHeader
                return headerView
            case LayoutHeader.supplementaryViewKind:
                let headerView: LayoutHeader = collectionView.dequeueReusableSupplementaryView(ofKind: LayoutHeader.supplementaryViewKind, withReuseIdentifier: LayoutHeader.reuseIdentifier, for: indexPath) as! LayoutHeader
                return headerView
            case LayoutFooter.supplementaryViewKind:
                let footerView: LayoutFooter = collectionView.dequeueReusableSupplementaryView(ofKind: LayoutFooter.supplementaryViewKind, withReuseIdentifier: LayoutFooter.reuseIdentifier, for: indexPath) as! LayoutFooter
                return footerView
            default:
                fatalError()
            }

        }

        collectionView.dataSource = dataSource
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<String, Int> {
        var snapshot = NSDiffableDataSourceSnapshot<String, Int>()

        let firstSection = "First section"
        snapshot.appendSections([firstSection])
        snapshot.appendItems([0, 1, 2], toSection: firstSection)

        let secondSection = "Second section"
        snapshot.appendSections([secondSection])
        snapshot.appendItems([4, 5, 6], toSection: secondSection)

        let thirdSection = "Third section"
        snapshot.appendSections([thirdSection])
        snapshot.appendItems([8, 9, 10], toSection: thirdSection)

        return snapshot
    }
}

class SectionHeader: UICollectionReusableView {
    static var supplementaryViewKind: String = "SectionHeaderKind"
    static var reuseIdentifier: String = "SectionHeaderReuse"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LayoutHeader: UICollectionReusableView {
    static var supplementaryViewKind: String = "LayoutHeaderKind"
    static var reuseIdentifier: String = "LayoutHeaderReuse"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LayoutFooter: UICollectionReusableView {
    static var supplementaryViewKind: String = "LayoutFooterKind"
    static var reuseIdentifier: String = "LayoutFooterReuse"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Cell: UICollectionViewCell {
    static var reuseIdentifier: String = "CellReuse"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
