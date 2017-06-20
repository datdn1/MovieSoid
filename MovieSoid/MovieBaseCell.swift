//
//  MovieBaseCell.swift
//  MovieSoid
//
//  Created by datdn1 on 6/17/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit


class MovieBaseCell: ASCellNode {

    lazy var posterImageNode: ASNetworkImageNode = {
        let imageNode = ASNetworkImageNode()
        imageNode.contentMode = .scaleAspectFit
        imageNode.backgroundColor = .lightGray
        return imageNode
    }()

    lazy var titleTextNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        return node
    }()


    lazy var yearTextNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        return node
    }()

    lazy var rateTextNode: InsetTextNode = {
        let node = InsetTextNode()
        node.setTextInset(inset: UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8))
        node.backgroundColor = Constants.Color.actionColor
        node.cornerRadius = 5.0
        node.clipsToBounds = true
        return node
    }()

    lazy var overviewTextNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 5
        return node
    }()

    init(model: Movies) {
        super.init()
        self.posterImageNode.url = URL(string: Constants.URL.ImageBaseURL + model.posterPath)
        self.titleTextNode.attributedText = model.attrStringForTitle(withSize: Constants.CellLayout.TitleFontSize)
        self.yearTextNode.attributedText = model.attrStringForYear(withSize: Constants.CellLayout.FontSize)
        self.rateTextNode.setAttributeString(attrString: model.voteAverage > 0 ? model.attrStringForRate(withSize: Constants.CellLayout.FontSize) : nil)
        self.overviewTextNode.attributedText = model.attrStringForOverview(withSize: Constants.CellLayout.FontSize)
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = Constants.Color.primaryColor
    }
}
