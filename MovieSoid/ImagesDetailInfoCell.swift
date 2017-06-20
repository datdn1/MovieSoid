//
//  ImageDetailInfoCell.swift
//  MovieSoid
//
//  Created by datdn1 on 6/20/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class ImagesDetailInfoCell: HorizalDetailCell {

    let model: ImagesInfo

    override func didLoad() {
        super.didLoad()
        self.adapter.dataSource = self
    }

    init(model: ImagesInfo, controller: UIViewController?) {
        self.model = model
        super.init(title: "Images", height: 150.0, controller: controller)
    }
}

extension ImagesDetailInfoCell: IGListAdapterDataSource {
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return ImageSection(heightCollectionNode: self.heightForNode)
    }

    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return [self.model as IGListDiffable]
    }

    func emptyView(for listAdapter: IGListAdapter) -> UIView? { return nil }
}

class ImageSection: IGListSectionController, IGListSectionType, ASSectionController {

    let heightCollectionNode: CGFloat
    init(heightCollectionNode: CGFloat) {
        self.heightCollectionNode = heightCollectionNode
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.minimumInteritemSpacing = 3
    }

    var images: ImagesInfo?

    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        return { return ImageCell(model: self.images!.posters[index], height: self.heightCollectionNode) }
    }

    func numberOfItems() -> Int {
        guard let imagesInfo = self.images, let images = imagesInfo.posters else { return 0 }
        return images.count
    }

    func didUpdate(to object: Any) {
        self.images = object as? ImagesInfo
    }

    func didSelectItem(at index: Int) { }

    func sizeForItem(at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }

    func cellForItem(at index: Int) -> UICollectionViewCell {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
    }
}

class ImageCell: ASCellNode {

    let height: CGFloat
    let model: Image
    lazy var posterImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.defaultImage = #imageLiteral(resourceName: "ic_no_image")
        node.contentMode = .scaleToFill
        return node
    }()

    init(model: Image, height: CGFloat) {
        self.height = height
        self.model = model
        super.init()
        if let path = model.filePath {
            self.posterImageNode.url = URL(string: Constants.URL.ImageBaseURL + path)
        }
        self.automaticallyManagesSubnodes = true
    }

    override func didLoad() {
        super.didLoad()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var width = self.height
        if let ratio = self.model.ratio {
            width = CGFloat(ratio) * self.height
        }
        self.posterImageNode.style.preferredSize = CGSize(width: width, height: self.height)
        return ASWrapperLayoutSpec(layoutElement: self.posterImageNode)
    }
}





