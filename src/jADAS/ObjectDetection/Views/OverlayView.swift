// Copyright 2019 The TensorFlow Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import AVFoundation

/**
 This structure holds the display parameters for the overlay to be drawon on a detected object.
 */
struct ObjectOverlay {
  let name: String
  let borderRect: CGRect
  let nameStringSize: CGSize
  let color: UIColor
  let font: UIFont
  let lanePoint1: CGPoint
  let lanePoint2: CGPoint
  let lanePoint3: CGPoint
  let lanePoint4: CGPoint
}

/**
 This UIView draws overlay on a detected object.
 */
class OverlayView: UIView {

  var objectOverlays: [ObjectOverlay] = []
  private let cornerRadius: CGFloat = 10.0
  private let stringBgAlpha: CGFloat
    = 0.7
  private let lineWidth: CGFloat = 3
  private let stringFontColor = UIColor.white
  private let stringHorizontalSpacing: CGFloat = 13.0
  private let stringVerticalSpacing: CGFloat = 7.0
    
  var audioPlayer: AVAudioPlayer!

  override func draw(_ rect: CGRect) {

    // Drawing code
    for objectOverlay in objectOverlays {
        
      drawBorders(of: objectOverlay)
      drawBackground(of: objectOverlay)
      drawName(of: objectOverlay)
      drawCenterPoint(of: objectOverlay)
      drawCustomPoint(of: objectOverlay)
      drawLaneLine(of: objectOverlay)
    }
  }

  /**
   This method draws the borders of the detected objects.
   */
  func drawBorders(of objectOverlay: ObjectOverlay) {

    let path = UIBezierPath(rect: objectOverlay.borderRect)
    path.lineWidth = lineWidth
    objectOverlay.color.setStroke()

    path.stroke()
  }

  /**
   This method draws the background of the string.
   */
  func drawBackground(of objectOverlay: ObjectOverlay) {

    let stringBgRect = CGRect(x: objectOverlay.borderRect.origin.x, y: objectOverlay.borderRect.origin.y , width: 2 * stringHorizontalSpacing + objectOverlay.nameStringSize.width, height: 2 * stringVerticalSpacing + objectOverlay.nameStringSize.height
    )

    let stringBgPath = UIBezierPath(rect: stringBgRect)
    objectOverlay.color.withAlphaComponent(stringBgAlpha).setFill()
    stringBgPath.fill()
  }

  /**
   This method draws the name of object overlay.
   */
  func drawName(of objectOverlay: ObjectOverlay) {

    // Draws the string.
    let stringRect = CGRect(x: objectOverlay.borderRect.origin.x + stringHorizontalSpacing, y: objectOverlay.borderRect.origin.y + stringVerticalSpacing, width: objectOverlay.nameStringSize.width, height: objectOverlay.nameStringSize.height)

    let attributedString = NSAttributedString(string: objectOverlay.name, attributes: [NSAttributedString.Key.foregroundColor : stringFontColor, NSAttributedString.Key.font : objectOverlay.font])
    attributedString.draw(in: stringRect)
  }
    
    // johyukjun - draw center point method
  func drawCenterPoint(of objectOverlay: ObjectOverlay) {
    let point = CGPoint(x: objectOverlay.borderRect.origin.x + objectOverlay.borderRect.width / 2, y: objectOverlay.borderRect.origin.y + objectOverlay.borderRect.height / 2)
           
    let pointPath = UIBezierPath(rect: CGRect(origin: point, size: CGSize(width: 5, height: 5)))
    pointPath.fill()
    }
    
    func drawCustomPoint(of objectOverlay: ObjectOverlay) {
        let plusPath = UIBezierPath()
        
        let halfWidth = bounds.width / 2
        let halfHeight = bounds.height / 1.0
        
        let thresholderWidth = bounds.width / 3
        let thresholderHeight = bounds.height / 3
        
        plusPath.lineWidth = 3.0
        plusPath.move(to: CGPoint(x: halfWidth , y: halfHeight))
        
        let point = CGPoint(x: objectOverlay.borderRect.origin.x + objectOverlay.borderRect.width / 2, y: objectOverlay.borderRect.origin.y + objectOverlay.borderRect.height / 2)
        
        plusPath.addLine(to: point)
        
        if (objectOverlay.borderRect.width > thresholderWidth && objectOverlay.borderRect.height > thresholderHeight) {
            UIColor.red.setStroke()
            playSoundAlert(status: true)
        }
        else {
            UIColor.white.setStroke()
        }
        
        plusPath.stroke()
    }
    
    func drawLaneLine(of objectOverlay: ObjectOverlay) {
        
        let leftLanePath = UIBezierPath()
        
        leftLanePath.lineWidth = 2.0
        
        leftLanePath.move(to: objectOverlay.lanePoint1)
        
        leftLanePath.addLine(to: objectOverlay.lanePoint2)
        
        UIColor.blue.setStroke()
        leftLanePath.stroke()
        print(objectOverlay.lanePoint1)
        
        
        let rigthLanePath = UIBezierPath()
        
        rigthLanePath.lineWidth = 2.0
        
        rigthLanePath.move(to: objectOverlay.lanePoint3)
        
        rigthLanePath.addLine(to: objectOverlay.lanePoint4)
        
        UIColor.orange.setStroke()
        rigthLanePath.stroke()
        
    }
    
    func playSoundAlert(status: Bool) {
        if let soundURL = Bundle.main.url(forResource: "alert-sound", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            }
            catch {
                print(error)
            }
            
            if (status) {
                audioPlayer.play()
            }
            else {
                audioPlayer.stop()
            }
        }
        else {
            print("Unable to locate audio file")
        }
        
    }

}
