//
//  InsetTextNode.swift
//  MovieSoid
//
//  Created by datdn1 on 6/17/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class InsetTextNode: ASControlNode {
    private var textInsets: UIEdgeInsets!
    private var attributeString: NSAttributedString!
    private var textNode: ASTextNode!

    override init() {
        self.textInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.textNode = ASTextNode()
        super.init()
        self.addSubnode(self.textNode)
    }

    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        let availableTextWidth = constrainedSize.width - self.textInsets.left - self.textInsets.right
        let availableTextHeight = constrainedSize.height - self.textInsets.top - self.textInsets.bottom
        let constrainedTextSize = CGSize(width: availableTextWidth, height: availableTextHeight)

        let textSize = self.textNode.layoutThatFits(ASSizeRangeMake(CGSize.zero, constrainedTextSize)).size
        let finalWidth = self.textInsets.left + textSize.width + self.textInsets.right;
        let finalHeight = self.textInsets.top + textSize.height + self.textInsets.bottom;

        let finalSize = CGSize(width: finalWidth, height: finalHeight);
        return finalSize;
    }

    override func layout() {
        let textX = self.textInsets.left;
        let textY = self.textInsets.top;
        let textSize = self.textNode.calculatedSize;
        textNode.frame = CGRect(x: textX, y: textY, width: textSize.width, height: textSize.height)
    }

    func attributedString() -> NSAttributedString? {
        return self.textNode.attributedText
    }

    func setAttributeString(attrString: NSAttributedString?) {
        self.textNode.attributedText = attrString
        self.invalidateCalculatedLayout()
    }

    func setTextInset(inset: UIEdgeInsets) {
        self.textInsets = inset
        self.invalidateCalculatedLayout()
    }
}
