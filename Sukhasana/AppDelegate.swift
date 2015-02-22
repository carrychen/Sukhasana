//
//  AppDelegate.swift
//  Sukhasana
//
//  Created by Tom Brow on 2/4/15.
//  Copyright (c) 2015 Tom Brow. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, MainViewControllerDelegate,  NSApplicationDelegate, NSWindowDelegate {
  @IBOutlet var panel: NSPanel!
  
  @IBAction func didClickStatusItem(sender: AnyObject) {
    let statusItemFrame = sender.window.frame
    panel.setFrameTopLeftPoint(NSMakePoint(
      statusItemFrame.origin.x,
      statusItemFrame.origin.y + statusItemFrame.size.height))
    panel.makeKeyAndOrderFront(self)    
  }
  
  // MARK: MainViewControllerDelegate
  
  func mainViewControllerDidChangeFittingSize(mainViewController: MainViewController) {
    updatePanelFrame()
  }
  
  // MARK: NSWindowDelegate
  
  func windowDidResignKey(notification: NSNotification) {
    panel.close()
  }
  
  // MARK: NSApplicationDelegate
  
  func applicationDidFinishLaunching(notification: NSNotification) {    
    statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2 /* NSSquareStatusItemLength */)
    statusItem.title = "a⋮"
    statusItem.highlightMode = true
    statusItem.target = self
    statusItem.action = "didClickStatusItem:"
    
    panel.floatingPanel = true
    
    // FIXME: retain cycle
    model.shouldDisplayScreen.start { screen in
      self.displayingViewController = {
        switch screen {
        case .Settings(let model):
          return SettingsViewController(model: model)
        case .Main(let model):
          return MainViewController(model: model, delegate: self)
        }
      }()
      self.setContentView(self.displayingViewController!.view)
    }
  }
  
  // MARK: private
  
  private func setContentView(view: NSView) {
    panel.contentView = view
    updatePanelFrame()
  }
  
  private func updatePanelFrame() {
    let topLeft = CGPointMake(
      panel.frame.origin.x,
      panel.frame.origin.y + panel.frame.size.height)
    let newSize = panel.contentView.fittingSize
    let newFrame = NSMakeRect(
      topLeft.x,
      topLeft.y - newSize.height,
      newSize.width,
      newSize.height)
    panel.setFrame(newFrame, display: true)
  }
  
  // MARK: private
  
  private var model = ApplicationModel(settingsStore: NSUserDefaults.standardUserDefaults())
  private var statusItem: NSStatusItem!
  private var displayingViewController: NSViewController?
}

