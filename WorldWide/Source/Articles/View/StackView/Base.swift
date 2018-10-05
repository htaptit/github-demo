//
//  Base.swift
//  WorldWide
//
//  Created by Hoang Trong Anh on 10/4/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//
import UIKit
import AsyncDisplayKit

class Base: ASDisplayNode {
    
    private let baseImage: ASImageNode = {
        let node = ASImageNode()
        node.image = #imageLiteral(resourceName: "no_image")
        node.style.preferredSize = CGSize(width: 80.0, height: 80.0)
        node.cornerRadius = 5.0
        
        return node
    }()
    
    private let nameText: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "Hoang Trong Anh")
        return node
    }()
    
    private let locationText: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "Hung Yen")
        return node
    }()
    
    private let languageText: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "Viet Nam")
        return node
    }()
    
    private let explanButton: ASButtonNode = {
        let node = ASButtonNode()
        node.setImage(#imageLiteral(resourceName: "icn_more"), for: .normal)
        node.style.preferredSize = CGSize(width: 20, height: 20)
        
        return node
    }()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let childAreaCenter = ASStackLayoutSpec(direction: .horizontal, spacing: 5.0, justifyContent: .spaceAround, alignItems: .center, children: [locationText, languageText])
        
        let centerArea = ASStackLayoutSpec(direction: .vertical, spacing: 2.0, justifyContent: .spaceAround, alignItems: .center, children: [nameText, childAreaCenter])
       
        let centerYArea  = ASCenterLayoutSpec(centeringOptions: .Y, sizingOptions: [], child: centerArea)
        let centerYImage = ASCenterLayoutSpec(centeringOptions: .Y, sizingOptions: [], child: baseImage)
        let centerYExplan = ASCenterLayoutSpec(centeringOptions: .Y, sizingOptions: [], child: explanButton)
        
        let _area = ASStackLayoutSpec(direction: .horizontal,
                                      spacing: 0.0,
                                      justifyContent: .spaceBetween,
                                      alignItems: .stretch,
                                      children: [ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 0), child: centerYImage),
                                                 centerYArea,
                                                 ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10), child: centerYExplan)])
        
        return _area
    }
    
}