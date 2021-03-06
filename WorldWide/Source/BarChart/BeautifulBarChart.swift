//
//  BeautifulBarChartView.swift
//
//  Created by Hoang Trong Anh on 16/8/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class BeautifulBarChart: ASDisplayNode {

    let barWidth: CGFloat = UIScreen.main.bounds.width / 2.5
    
    /// Reserved space to show text below each bar
    private let bottomSpace: CGFloat = 40.0
    
    /// Reserved space to show value (or height) of the bar
    private let topSpace: CGFloat = 100
    
    private let topBubbleRadius: CGFloat = 20.0

    var dataEntries: [BarEntry]? = nil {
        didSet {
            self.subnodes?.forEach({$0.removeFromSupernode()})
            
            if let dataEntries = dataEntries {
                self.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
                for i in 0..<dataEntries.count {
                    self.showEntry(index: i, entry: dataEntries[i])
                }
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    private func showEntry(index: Int, entry: BarEntry) {
        let height: CGFloat = CGFloat(entry.height) * (self.style.preferredSize.height - bottomSpace - topSpace)
        
        /// Starting x postion of the bar
        let xPos: CGFloat = CGFloat(index) * barWidth / 2
        
        /// Starting y postion of the bar
        let yPos: CGFloat = self.style.preferredSize.height - bottomSpace
        
        drawBar(xPos: xPos, yPos: yPos, height: height, color: entry.color)
        
        /// Draw the top bubble
        drawTopBuble(xPos: xPos+barWidth/2-topBubbleRadius, yPos: round(yPos - height - 80), color: entry.color)
        
        /// Draw the line that connect top of the bar to the top bubble
        drawLinkingLine(xPos: xPos+barWidth/2, yPos: yPos - height - 4, color: entry.color)
        
        /// Draw text above the bar, inside the top bubble
        drawTextValue(xPos: xPos+barWidth/2-topBubbleRadius, yPos: yPos - height - 86, textValue: entry.textValue)
        
        /// Draw text below the bar
        drawTitle(xPos: xPos, yPos: yPos + 10, title: entry.title, color: entry.color)
        
    }
    
    private func drawBar(xPos: CGFloat, yPos: CGFloat, height: CGFloat, color: UIColor) {
        let leftLine = ASDisplayNode { () -> CALayer in
            let leftPath: UIBezierPath = UIBezierPath()
            leftPath.move(to: CGPoint(x: xPos, y: yPos))
            leftPath.addCurve(to: CGPoint(x: xPos+self.barWidth/2, y: yPos - height), controlPoint1: CGPoint(x: (xPos+self.barWidth/2), y: yPos), controlPoint2: CGPoint(x: xPos + self.barWidth*3/10, y: yPos - height))
            leftPath.addLine(to: CGPoint(x: xPos + self.barWidth/2, y: yPos))
            
            let leftLine = CAShapeLayer()
            leftLine.path = leftPath.cgPath
            leftLine.lineWidth = 0.0
            leftLine.fillColor = color.cgColor
            leftLine.strokeColor = color.cgColor
            
            return leftLine
        }
        
        let rightLine = ASDisplayNode { () -> CALayer in
            let rightPath: UIBezierPath = UIBezierPath()
            rightPath.move(to: CGPoint(x: xPos+self.barWidth, y: yPos))
            rightPath.addCurve(to: CGPoint(x: xPos + self.barWidth/2, y: yPos-height), controlPoint1: CGPoint(x: xPos+self.barWidth/2, y: yPos), controlPoint2: CGPoint(x: xPos + self.barWidth*7/10, y: yPos-height))
            rightPath.addLine(to: CGPoint(x: xPos + self.barWidth/2, y: yPos))
            
            let rightLine = CAShapeLayer()
            rightLine.path = rightPath.cgPath
            rightLine.lineWidth = 0.0
            rightLine.fillColor = color.cgColor
            rightLine.strokeColor = color.cgColor
            return rightLine
        }

        self.addSubnode(leftLine)
        self.addSubnode(rightLine)

    }
    
    private func drawTopBuble(xPos: CGFloat, yPos: CGFloat, color: UIColor) {
        /// This magicValue helps to create 2 control points that can be used to draw a quater of a circle using Bezier curve function
        let magicValue: CGFloat = 0.552284749831 * topBubbleRadius
        
        let _segment1Layer = ASDisplayNode { () -> CALayer in
            let segment1Path = UIBezierPath()
            segment1Path.move(to: CGPoint(x: xPos, y: yPos))
            segment1Path.addCurve(to: CGPoint(x: xPos+self.topBubbleRadius, y: yPos-self.topBubbleRadius), controlPoint1: CGPoint(x: xPos, y: yPos-magicValue), controlPoint2: CGPoint(x: xPos+self.topBubbleRadius-magicValue, y: yPos-self.topBubbleRadius))
            segment1Path.addLine(to: CGPoint(x: xPos+self.topBubbleRadius, y: yPos))
            let segment1Layer = CAShapeLayer()
            segment1Layer.path = segment1Path.cgPath
            segment1Layer.fillColor = color.cgColor
            segment1Layer.strokeColor = color.cgColor
            segment1Layer.lineWidth = 0.0
            
            return segment1Layer
        }
        
        self.addSubnode(_segment1Layer)

        let _segment2Layer = ASDisplayNode { () -> CALayer in
            let segment2Path = UIBezierPath()
            segment2Path.move(to: CGPoint(x: xPos+self.topBubbleRadius, y: yPos-self.topBubbleRadius))
            segment2Path.addCurve(to: CGPoint(x: xPos+self.topBubbleRadius*2, y: yPos), controlPoint1: CGPoint(x: xPos+self.topBubbleRadius+magicValue, y: yPos-self.topBubbleRadius), controlPoint2: CGPoint(x: xPos+self.topBubbleRadius*2, y: yPos-magicValue))
            segment2Path.addLine(to: CGPoint(x: xPos+self.topBubbleRadius, y: yPos))
            let segment2Layer = CAShapeLayer()
            segment2Layer.path = segment2Path.cgPath
            segment2Layer.fillColor = color.cgColor
            segment2Layer.strokeColor = color.cgColor
            segment2Layer.lineWidth = 0.0
            return segment2Layer
        }
        
        self.addSubnode(_segment2Layer)

        let _segment3Layer = ASDisplayNode { () -> CALayer in
            let segment3Path = UIBezierPath()
            segment3Path.move(to: CGPoint(x: xPos, y: yPos))
            segment3Path.addCurve(to: CGPoint(x: xPos+self.topBubbleRadius, y: yPos+self.topBubbleRadius*1.5), controlPoint1: CGPoint(x: xPos, y: yPos+magicValue), controlPoint2: CGPoint(x: xPos+self.topBubbleRadius-magicValue, y: yPos+self.topBubbleRadius))
            segment3Path.addLine(to: CGPoint(x: xPos+self.topBubbleRadius, y: yPos))
            let segment3Layer = CAShapeLayer()
            segment3Layer.path = segment3Path.cgPath
            segment3Layer.fillColor = color.cgColor
            segment3Layer.strokeColor = color.cgColor
            segment3Layer.lineWidth = 0.0
            return segment3Layer
        }
        
        self.addSubnode(_segment3Layer)

        let _segment4Layer = ASDisplayNode { () -> CALayer in
            let segment4Path = UIBezierPath()
            segment4Path.move(to: CGPoint(x: xPos+self.topBubbleRadius*2, y: yPos))
            segment4Path.addCurve(to: CGPoint(x: xPos+self.topBubbleRadius, y: yPos+self.topBubbleRadius*1.5), controlPoint1: CGPoint(x: xPos+self.topBubbleRadius*2, y: yPos+magicValue), controlPoint2: CGPoint(x: xPos+self.topBubbleRadius+magicValue, y: yPos+self.topBubbleRadius))
            segment4Path.addLine(to: CGPoint(x: xPos+self.topBubbleRadius, y: yPos))
            let segment4Layer = CAShapeLayer()
            segment4Layer.path = segment4Path.cgPath
            segment4Layer.fillColor = color.cgColor
            segment4Layer.strokeColor = color.cgColor
            segment4Layer.lineWidth = 0.0
            
            return segment4Layer
        }
        
        self.addSubnode(_segment4Layer)
    }
    
    private func drawTextValue(xPos: CGFloat, yPos: CGFloat, textValue: String) {
        let _textLayer = ASDisplayNode { () -> CALayer in
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: xPos, y: yPos, width: self.topBubbleRadius*2, height: 22)
            textLayer.foregroundColor = UIColor.white.cgColor
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.alignmentMode = CATextLayerAlignmentMode.center
            textLayer.truncationMode = CATextLayerTruncationMode.end
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
            textLayer.fontSize = 14
            textLayer.string = textValue
            textLayer.isHidden = false
            return textLayer
        }
        
        self.addSubnode(_textLayer)
    }
    
    private func drawTitle(xPos: CGFloat, yPos: CGFloat, title: String, color: UIColor) {
        let _textLayer = ASDisplayNode { () -> CALayer in
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: xPos, y: yPos, width: self.barWidth, height: 22)
            textLayer.foregroundColor = color.cgColor
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.alignmentMode = CATextLayerAlignmentMode.center
            textLayer.truncationMode = CATextLayerTruncationMode.end
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
            textLayer.fontSize = 14
            textLayer.string = NSString(string: title)
            textLayer.isHidden = false
            return textLayer
        }
        
        self.addSubnode(_textLayer)
    }
    
    private func drawLinkingLine(xPos: CGFloat, yPos: CGFloat, color: UIColor) {
        let line = ASDisplayNode { () -> CALayer in
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPos, y: yPos))
            path.addLine(to: CGPoint(x: xPos, y: yPos-40))
            let line = CAShapeLayer()
            line.path = path.cgPath
            line.fillColor = UIColor.clear.cgColor
            line.strokeColor = color.cgColor
            line.lineWidth = 2.0
            return line
        }
        
        self.addSubnode(line)

        let topCircle = ASDisplayNode { () -> CALayer in
            let topCircle = CALayer()
            topCircle.frame = CGRect(x: xPos-3, y: yPos-40, width: 6, height: 6)
            topCircle.backgroundColor = color.cgColor
            topCircle.cornerRadius = 3.0
            
            return topCircle
        }
        
        self.addSubnode(topCircle)
    }
}
