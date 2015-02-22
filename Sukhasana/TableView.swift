//
//  TableView.swift
//  Sukhasana
//
//  Created by Tom Brow on 2/22/15.
//  Copyright (c) 2015 Tom Brow. All rights reserved.
//

import Cocoa

class TableView: NSTableView {
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    self.allowsTypeSelect = false
    
    addTrackingArea(
      NSTrackingArea(
        rect: NSZeroRect, // ignored due to .InVisibleRect option
        options: .ActiveAlways | .InVisibleRect | .MouseEnteredAndExited | .MouseMoved,
        owner: self,
        userInfo: nil))
  }
  
  // MARK: NSResponder
  
  func acceptsFirstResponder() -> Bool {
    return numberOfRows > 0
  }
  
  override func becomeFirstResponder() -> Bool {
    selectRowIndexes(NSIndexSet(index: 0), byExtendingSelection: false)
    return true
  }
  
  override func mouseExited(theEvent: NSEvent) {
    super.mouseExited(theEvent)
    selectRowIndexes(NSIndexSet(), byExtendingSelection: false)
  }
  
  override func mouseMoved(theEvent: NSEvent) {
    super.mouseMoved(theEvent)
    
    let row = rowAtPoint(convertPoint(theEvent.locationInWindow, fromView: nil))
    let rowIndexesToSelect: NSIndexSet = {
      if row == -1 {
        return NSIndexSet()
      } else {
        return NSIndexSet(index: row)
      }
    }()
    
    window?.makeFirstResponder(self)
    selectRowIndexes(rowIndexesToSelect, byExtendingSelection: false)
  }
}