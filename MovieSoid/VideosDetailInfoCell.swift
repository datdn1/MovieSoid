//
//  VideosDetailInfoCell.swift
//  MovieSoid
//
//  Created by datdn1 on 6/19/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class VideosDetailInfoCell: HorizalDetailCell {

    let model: VideosInfo

    override func didLoad() {
        super.didLoad()
        self.adapter.dataSource = self
    }

    init(model: VideosInfo, controller: UIViewController?) {
        self.model = model
        super.init(title: "Videos", height: 110.0, controller: controller)
    }
}

extension VideosDetailInfoCell: IGListAdapterDataSource {
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return VideoSection(heightCollectionNode: self.heightForNode)
    }

    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return [self.model as IGListDiffable]
    }

    func emptyView(for listAdapter: IGListAdapter) -> UIView? { return nil }
}

class VideoSection: IGListSectionController, IGListSectionType, ASSectionController {

    let heightCollectionNode: CGFloat
    init(heightCollectionNode: CGFloat) {
        self.heightCollectionNode = heightCollectionNode
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.minimumLineSpacing = 3
    }

    var videos: VideosInfo?

    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        return { return VideoCell(model: self.videos!.videos[index], height: self.heightCollectionNode) }
    }

    func numberOfItems() -> Int {
        guard let videosInfo = self.videos, let videos = videosInfo.videos else { return 0 }
        return videos.count
    }

    func didUpdate(to object: Any) {
        self.videos = object as? VideosInfo
    }

    func didSelectItem(at index: Int) { }

    func sizeForItem(at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }

    func cellForItem(at index: Int) -> UICollectionViewCell {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
    }
}

class VideoCell: ASCellNode {

    let height: CGFloat
    lazy var thumnailVideoImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.contentMode = .scaleToFill
        return node
    }()

    lazy var typeTextNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()

    lazy var playButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setImage(#imageLiteral(resourceName: "ic_play"), for: .normal)
        return node
    }()

    init(model: Videos, height: CGFloat) {
        self.height = height
        super.init()
        self.typeTextNode.attributedText = NSAttributedString(string: model.type)
        if let videoKey = model.key {
            self.thumnailVideoImageNode.url = URL(string: Constants.URL.ThumbnailBaseURL + videoKey + "/0.jpg")
        }
        self.thumnailVideoImageNode.backgroundColor = Constants.Color.headerColor
        self.automaticallyManagesSubnodes = true
    }

    override func didLoad() {
        super.didLoad()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = self.height * 16.0 / 9
        self.thumnailVideoImageNode.style.preferredSize = CGSize(width: width, height: self.height)

        let typeInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 5, 5, 0), child: self.typeTextNode)
        let typeRelSpec = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .end, sizingOption: .minimumSize, child: typeInsetSpec)
        let typeOverlaySpec = ASOverlayLayoutSpec(child: self.thumnailVideoImageNode, overlay: typeRelSpec)
        let playButtonCenterSpec = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: self.playButtonNode)
        return ASOverlayLayoutSpec(child: typeOverlaySpec, overlay: playButtonCenterSpec)
    }
}


