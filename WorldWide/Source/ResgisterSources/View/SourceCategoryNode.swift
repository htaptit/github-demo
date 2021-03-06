//
//  SourceCategoryNode.swift
//  WorldWide
//
//  Created by Hoang Trong Anh on 11/12/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import AsyncDisplayKit

class SourceCategoryNode: ASCellNode {
    private let nameNode: ASTextNode = {
        let node = ASTextNode()
        node.calculateSizeThatFits(CGSize(width: 45, height: 45))
        return node
    }()
    
    private let photoNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.contentMode = .scaleAspectFill
        node.clipsToBounds = true
        node.cornerRadius = 2.0
        return node
    }()
    
    init(type: Type?) {
        super.init()
        automaticallyManagesSubnodes = true
        cornerRadius = 2.0
        
        guard let tp = type, let name = tp.name else {
            return
        }
        
        self.photoNode.url = tp.image
        self.nameNode.attributedText = NSAttributedString(string: name, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10.0, weight: .bold),  NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.photoNode.style.preferredSize = CGSize(width: 50, height: 50)
        
        let name = ASCenterLayoutSpec(centeringOptions: ASCenterLayoutSpecCenteringOptions.XY, sizingOptions: [], child: self.nameNode)
        
        let absoluteSepec = ASAbsoluteLayoutSpec(sizing: .sizeToFit, children: [self.photoNode, name])
        
        return absoluteSepec
    }
}
