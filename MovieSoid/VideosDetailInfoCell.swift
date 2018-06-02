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

extension VideosDetailInfoCell: ListAdapterDataSource {
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return VideoSection(heightCollectionNode: self.heightForNode)
    }

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [self.model as ListDiffable]
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
}

class VideoSection: ListSectionController, ASSectionController {

    let heightCollectionNode: CGFloat
    init(heightCollectionNode: CGFloat) {
        self.heightCollectionNode = heightCollectionNode
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.minimumLineSpacing = 3
    }

    var videos: VideosInfo?

    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        return { return VideoCell(model: self.videos!.videos[index], delegate: self, height: self.heightCollectionNode) }
    }

    override func numberOfItems() -> Int {
        guard let videosInfo = self.videos, let videos = videosInfo.videos else { return 0 }
        return videos.count
    }

    override func didUpdate(to object: Any) {
        self.videos = object as? VideosInfo
    }

    override func didSelectItem(at index: Int) {
        guard let controller = self.viewController as? DetailMovieController, let video = self.videos?.videos[index] else { return }
        let playerController = PlayVideoController(nibName: "PlayVideoController", bundle: nil)
        playerController.videoId = video.key
        controller.navigationController?.pushViewController(playerController, animated: true)
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
    }
}

extension VideoSection: VideoCellDelegate {
    func playVideo(key: String) {

    }
}

protocol VideoCellDelegate {
    func playVideo(key: String)
}

class VideoCell: ASCellNode {

    let height: CGFloat
    let delegate: VideoCellDelegate?
    let model: Videos

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
//        node.addTarget(self, action: #selector(playVideo), forControlEvents: .touchUpInside)
        return node
    }()

    @objc private func playVideo() {
        print("Video play")
        guard let delegate = self.delegate, let key = self.model.key else { return }
        delegate.playVideo(key: key)
    }

    init(model: Videos, delegate: VideoCellDelegate?, height: CGFloat) {
        self.height = height
        self.delegate = delegate
        self.model = model
        super.init()
        self.typeTextNode.attributedText = Helper.attrString(attrs: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.boldSystemFont(ofSize: 10)], text: model.type)
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


