//
//  SimilarDetailInfoCell.swift
//  MovieSoid
//
//  Created by datdn1 on 6/20/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class SimilarDetailInfoCell: HorizalDetailCell {

    let model: MoviesInfo

    override func didLoad() {
        super.didLoad()
        self.adapter.dataSource = self
    }

    init(model: MoviesInfo, controller: UIViewController?) {
        self.model = model
        super.init(title: "You may also like", height: 220.0, controller: controller)
    }
}

extension SimilarDetailInfoCell: IGListAdapterDataSource {
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return SimilarSection(heightCollectionNode: self.heightForNode)
    }

    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return [self.model as IGListDiffable]
    }

    func emptyView(for listAdapter: IGListAdapter) -> UIView? { return nil }
}

class SimilarSection: IGListSectionController, IGListSectionType, ASSectionController {

    let heightCollectionNode: CGFloat
    init(heightCollectionNode: CGFloat) {
        self.heightCollectionNode = heightCollectionNode
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.minimumLineSpacing = 3
    }

    var similarVideos: MoviesInfo?

    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        return { return SimilarCell(model: self.similarVideos!.movies[index], height: self.heightCollectionNode) }
    }

    func numberOfItems() -> Int {
        guard let similarInfo = self.similarVideos, let videos = similarInfo.movies else { return 0 }
        return videos.count
    }

    func didUpdate(to object: Any) {
        self.similarVideos = object as? MoviesInfo
    }

    func didSelectItem(at index: Int) { }

    func sizeForItem(at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }

    func cellForItem(at index: Int) -> UICollectionViewCell {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
    }
}

class SimilarCell: MovieDetailBaseCell {

    init(model: Movies, height: CGFloat) {
        super.init(height: height)

        if let path = model.posterPath {
            self.imageNode.url =  URL(string: Constants.URL.ImageBaseURL + path)
        }
        self.titleTextNode.attributedText = model.attrStringForTitle(withSize: 12)
        self.subtitleTextNode.attributedText = model.attrStringForRate(withSize: 10)
    }

    override func didLoad() {
        super.didLoad()
    }
}





