//
//  AirShare.swift
//  AirShare
//
//  Created by 周辉 on 10/12/2017.
//  Copyright © 2017 FaiChou. All rights reserved.
//

import Foundation
import Cocoa

fileprivate let CHROME_SCRIPT = "tell application \"Google Chrome\" to get URL of active tab of front window as string"
fileprivate let SAFARI_SCRIPT = "tell application \"Safari\" to return URL of front document as string"

enum OptionType: String {
  case chrome = "c"
  case safari = "s"
  case help = "h"
  case unkonwn
  
  init(value: String) {
    switch value {
    case "c": self = .chrome
    case "s": self = .safari
    case "h": self = .help
    default: self = .unkonwn
    }
  }
}

class AirShare: NSObject, NSApplicationDelegate, NSSharingServiceDelegate  {
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {}
  
  let consoleIO = ConsoleIO()
  
  func getOption(_ option: String) -> (option: OptionType, value: String) {
    return (OptionType(value: option), option)
  }
  
  func run() {
    if CommandLine.argc == 1 {
      getUrl(with: CHROME_SCRIPT)
      return
    }
    let argument = CommandLine.arguments[1]
    let index = argument.index(argument.startIndex, offsetBy: 1)
    let (option, _) = getOption(String(argument[index...]))
    switch option {
    case .chrome:
      getUrl(with: CHROME_SCRIPT)
    case .safari:
      getUrl(with: SAFARI_SCRIPT)
    case .help:
      consoleIO.printUsage()
      exit(0)
    case .unkonwn:
      consoleIO.writeMessage("Unknow option.\n", to: .error)
      consoleIO.printUsage()
      exit(0)
    }
  }
  func getUrl(with cmd: String) {
    var error: NSDictionary?
    guard let scriptObject = NSAppleScript(source: cmd)  else {
      consoleIO.writeMessage("Cannot attach to browser.", to: .error)
      exit(1)
    }
    let output = scriptObject.executeAndReturnError(&error)
    if error != nil {
      consoleIO.writeMessage("\(String(describing: error))", to: .error)
      exit(1)
    }
    guard let urlString = output.stringValue, let url = URL(string: urlString) else {
      consoleIO.writeMessage("Cannot resolve correct URL.", to: .error)
      exit(1)
    }
    share(url)
  }
  func share(_ url: URL) {
    let service = NSSharingService(named: .sendViaAirDrop)!
    let items: [URL] = [url]
    if service.canPerform(withItems: items) {
      service.delegate = self
      service.perform(withItems: items)
    } else {
      consoleIO.writeMessage("Cannot perform", to: .error)
      exit(1)
    }
  }
  func sharingService(_ sharingService: NSSharingService, willShareItems items: [Any]) {
    consoleIO.writeMessage("Will Share: \(items)".blue.bold)
  }
  func sharingService(_ sharingService: NSSharingService, didShareItems items: [Any]) {
    consoleIO.writeMessage("Share Succeeded!".blue.bold)
    exit(0)
  }
  func sharingService(_ sharingService: NSSharingService, didFailToShareItems items: [Any], error: Error) {
    consoleIO.writeMessage("Share Failed, due to: \(error.localizedDescription)".red.bold)
    exit(1)
  }
}
