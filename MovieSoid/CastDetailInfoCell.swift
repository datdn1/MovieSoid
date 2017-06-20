//
//  CastDetailInfoCell.swift
//  MovieSoid
//
//  Created by datdn1 on 6/19/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CastInfoCell: MovieDetailBaseCell {

    init(model: Cast, height: CGFloat) {
        super.init(height: height)

        if let castImagePath = model.profilePath {
            self.imageNode.url =  URL(string: Constants.URL.ImageBaseURL + castImagePath)
        }
        self.titleTextNode.attributedText = model.attrStringForName(withSize: 12)
        self.subtitleTextNode.attributedText = model.attrStringForCharater(withSize: 10)
        self.automaticallyManagesSubnodes = true
    }

    override func didLoad() {
        super.didLoad()
    }

//    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        let width: Double = 120
//        let height: Double = width * 3 / 2.0
//        self.castImageNode.style.preferredSize = CGSize(width: width, height: height)
//
//        self.nameTextNode.style.flexGrow = 1
//        self.nameTextNode.style.flexShrink = 1
//        self.characterTextNode.style.flexShrink = 1
//        self.characterTextNode.style.flexGrow = 1
//
//        let nameStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .center, children: [self.nameTextNode, self.characterTextNode])
//        nameStackSpec.style.width = ASDimension(unit: .points, value: CGFloat(width))
//
//        let mainStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [self.castImageNode, nameStackSpec])
//        mainStackSpec.style.height = ASDimension(unit: .points, value: self.height)
//
//        return mainStackSpec
//    }
}

// cast cell
class CastDetailInfoCell: HorizalDetailCell {

    let model: CastInfo

    override func didLoad() {
        super.didLoad()
        self.adapter.dataSource = self
    }

    init(model: CastInfo, controller: UIViewController?) {
        self.model = model
        super.init(title: "Casting", height: 230.0, controller: controller)
    }
}

extension CastDetailInfoCell: IGListAdapterDataSource {
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return CastSection(heightCollectionNode: self.heightForNode)
    }

    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return [self.model as IGListDiffable]
    }

    func emptyView(for listAdapter: IGListAdapter) -> UIView? { return nil }
}

class CastSection: IGListSectionController, IGListSectionType, ASSectionController {

    let heightCollectionNode: CGFloat
    init(heightCollectionNode: CGFloat) {
        self.heightCollectionNode = heightCollectionNode
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.minimumLineSpacing = 3
    }
    var casts: CastInfo?

    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        return { return CastInfoCell(model: self.casts!.casts[index], height: self.heightCollectionNode) }
    }

    func numberOfItems() -> Int {
        guard let castsInfo = self.casts, let casts = castsInfo.casts else { return 0 }
        return casts.count
    }

    func didUpdate(to object: Any) {
        self.casts = object as? CastInfo
    }

    func didSelectItem(at index: Int) { }

    func sizeForItem(at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }

    func cellForItem(at index: Int) -> UICollectionViewCell {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
    }
}









