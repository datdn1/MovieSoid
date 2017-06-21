//
//  ReviewsCell.swift
//  MovieSoid
//
//  Created by datdn1 on 6/20/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol ReviewsCellDelegate {
    func didTapSeeMore(at index: Int)
}


class ReviewsCell: ASCellNode {

    let hiddenSeperator: Bool
    let model: Reviews
    let index: Int
    let delegate: ReviewsCellDelegate?

    lazy var usernameTextNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        node.style.flexGrow = 1
        node.style.flexShrink = 1
        return node
    }()

    lazy var contentTextNode: ASTextNode = {
        let node = ASTextNode()
        node.style.flexShrink = 1
        node.style.flexGrow = 1
        node.truncationAttributedText = Helper.attrString(attrs: [
                NSForegroundColorAttributeName : UIColor.white,
                NSFontAttributeName: UIFont.systemFont(ofSize: 13)], text: "See More...")
        node.truncationMode = NSLineBreakMode.byTruncatingTail
        node.maximumNumberOfLines = 10
        node.isUserInteractionEnabled =  true
        node.delegate = self
        return node
    }()

    lazy var seperatorNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .white
        node.style.height = ASDimension(unit: .points, value: 0.5)
        return node
    }()


    init(model: Reviews, hiddenSeperator: Bool, delegate: ReviewsCellDelegate?, index: Int) {
        self.hiddenSeperator = hiddenSeperator
        self.model = model
        self.delegate = delegate
        self.index = index
        super.init()
        setupViews()
        self.automaticallyManagesSubnodes = true
    }

    override func didLoad() {
        view.clipsToBounds = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let reviewStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [self.usernameTextNode, self.contentTextNode])
        let mainInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(8, 8, 8, 8), child: reviewStackSpec)

        var mainStackChildren: [ASLayoutElement] = [mainInsetSpec]
        if !self.hiddenSeperator {
            mainStackChildren.append(self.seperatorNode)
        }
        return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: mainStackChildren)
    }

    private func setupViews() {
        if let isSeeMore = self.model.isSeeMore, isSeeMore {
            self.contentTextNode.maximumNumberOfLines = 0
        }
        self.usernameTextNode.attributedText = model.attrStringForAuthor(withSize: 14)
        self.contentTextNode.attributedText = model.attrStringForContent(withSize: 12)
        self.contentTextNode.addLinkDetection(model.content, highLightColor: Constants.Color.actionColor, delegate: self)
    }
}

extension ReviewsCell: ASTextNodeDelegate {
    func textNodeTappedTruncationToken(_ textNode: ASTextNode) {
        self.model.isSeeMore = true
        guard let delegate = self.delegate else { return }
        delegate.didTapSeeMore(at: self.index)
    }

    func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        print("Did tap link")
    }
}

extension ASTextNode {
    func addLinkDetection(_ text: String, highLightColor: UIColor, delegate: ASTextNodeDelegate) {
        self.isUserInteractionEnabled = true
        self.delegate = delegate

        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        let range = NSMakeRange(0, self.attributedText!.string.characters.count)
        if let attributedText = self.attributedText {
            let mutableString = NSMutableAttributedString()
            mutableString.append(attributedText)
            detector?.enumerateMatches(in: text, range: range) {
                (result, _, _) in
                if let fixedRange = result?.range {
                    mutableString.addAttribute(NSUnderlineColorAttributeName, value: highLightColor, range: fixedRange)
                    mutableString.addAttribute(NSLinkAttributeName, value: result?.url, range: fixedRange)
                    mutableString.addAttribute(NSForegroundColorAttributeName, value: highLightColor, range: fixedRange)
                }
            }
            self.attributedText = mutableString
        }
    }
}














