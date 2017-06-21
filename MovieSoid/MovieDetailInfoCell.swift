//
//  MovieDetailInfoCell.swift
//  MovieSoid
//
//  Created by datdn1 on 6/19/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MovieDetailInfoCell: ASCellNode {
    lazy var titleTextNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()

    lazy var genresTextNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()

    lazy var overviewTextNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()

    lazy var addWatchlistButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        let attrs = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: Constants.CellLayout.WatchListButtonFontSize)
        ]
        node.setAttributedTitle(Helper.attrString(attrs: attrs, text: "+ Add to Watchlist"), for: .normal)
        node.backgroundColor = Constants.Color.actionColor
        node.cornerRadius = 5.0
        node.clipsToBounds = true
        return node
    }()

    lazy var rateTextNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()

    lazy var voteCountTextNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()

    lazy var rateButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setImage(#imageLiteral(resourceName: "ic_star_rate"), for: .normal)
        node.setTitle("Rate this film", with: UIFont.systemFont(ofSize: 13), with: .white, for: .normal)
        return node
    }()

    lazy var rateImageNode: ASImageNode = {
        let node = ASImageNode()
        node.image = #imageLiteral(resourceName: "ic_star_rate_fill")
        return node
    }()

    init(model: Movies) {
        super.init()
        self.titleTextNode.attributedText = model.attrStringForDetailTitle(withSize: Constants.CellLayout.FontSize)
        self.genresTextNode.attributedText = model.attrStringForDetailGenres(withSize: 13)
        self.overviewTextNode.attributedText = model.attrStringForDetailOverview(withSize: 14)
        self.rateTextNode.attributedText = model.voteAverage > 0 ? model.attrStringForRate(withSize: 14) : nil
        self.voteCountTextNode.attributedText = model.voteCount > 0 ? model.attrStringForVoteCount(withSize: 12) : nil
        self.automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        self.titleTextNode.style.flexGrow = 1
        self.titleTextNode.style.flexShrink = 1
        self.genresTextNode.style.flexShrink = 1
        self.genresTextNode.style.flexGrow = 1
        self.addWatchlistButtonNode.style.height = ASDimension(unit: .points, value: 40)

        let titleStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 3, justifyContent: .start, alignItems: .start, children: [self.titleTextNode, self.genresTextNode])
        titleStackSpec.style.width = ASDimension(unit: .points, value: UIScreen.main.bounds.size.width)
        let titleInsetsSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(8, 8, 8, 8), child: titleStackSpec)


        let titleBackgroundNode = ASDisplayNode()
        titleBackgroundNode.backgroundColor = Constants.Color.headerColor
        let titleBackgroundSpec = ASBackgroundLayoutSpec(child: titleInsetsSpec, background: titleBackgroundNode)

        self.addWatchlistButtonNode.style.alignSelf = .stretch

        let overviewStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 15, justifyContent: .start, alignItems: .start, children: [self.overviewTextNode, self.addWatchlistButtonNode])
        overviewStackSpec.style.width = ASDimension(unit: .points, value: UIScreen.main.bounds.size.width)
        let overviewInsetsSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(8, 8, 8, 8), child: overviewStackSpec)

        let overviewBackgroundNode = ASDisplayNode()
        overviewBackgroundNode.backgroundColor = Constants.Color.primaryColor
        let overviewBackgroundSpec = ASBackgroundLayoutSpec(child: overviewInsetsSpec, background: overviewBackgroundNode)

        var rateStackChildren: [ASLayoutElement] = []
        if let rateStr = self.rateTextNode.attributedText, rateStr.length > 0 {
            rateStackChildren.append(self.rateTextNode)
        }

        if let vote = self.voteCountTextNode.attributedText, vote.length > 0 {
            rateStackChildren.append(self.voteCountTextNode)
        }

        var rateBackgroundSpec: ASBackgroundLayoutSpec?
        if rateStackChildren.count > 0 {
            let rateStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 5, justifyContent: .start, alignItems: .center, children: [self.rateImageNode, ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .center, children: rateStackChildren)])
            let rateInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(8, 8, 8, 0), child: rateStackSpec)

            let rateBackgroundNode = ASDisplayNode()
            rateBackgroundNode.borderWidth = 1.0
            rateBackgroundNode.borderColor = Constants.Color.headerColor.cgColor
            rateBackgroundNode.backgroundColor = Constants.Color.primaryColor
            rateBackgroundSpec = ASBackgroundLayoutSpec(child: rateInsetSpec, background: rateBackgroundNode)
        }

        let rateItInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(8, 0, 8, 0), child: self.rateButtonNode)
        let rateItBackgroundNode = ASDisplayNode()
        rateItBackgroundNode.borderWidth = 1.0
        rateItBackgroundNode.borderColor = Constants.Color.headerColor.cgColor
        rateItBackgroundNode.backgroundColor = Constants.Color.primaryColor


        let rateItBackgroundSpec = ASBackgroundLayoutSpec(child: rateItInsetSpec, background: rateItBackgroundNode)
        rateItBackgroundSpec.style.flexGrow = 0.5

        var rateHorizonChildren: [ASLayoutElement] = [rateItBackgroundSpec]
        if let rateBackgroundSpec = rateBackgroundSpec {
            rateBackgroundSpec.style.flexGrow = 0.5
            rateHorizonChildren.insert(rateBackgroundSpec, at: 0)
        }

        let rateHorizonStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .center, alignItems: .stretch, children: rateHorizonChildren)
        return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [titleBackgroundSpec, overviewBackgroundSpec, rateHorizonStackSpec])
    }
}
























