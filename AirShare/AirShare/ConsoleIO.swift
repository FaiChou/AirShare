//
//  ConsoleIO.swift
//  AirShare
//
//  Created by 周辉 on 10/12/2017.
//  Copyright © 2017 FaiChou. All rights reserved.
//

import Foundation
enum OutputType {
  case error
  case standard
}

class ConsoleIO {
  func writeMessage(_ message: String, to: OutputType = .standard) {
    switch to {
    case .standard:
      print("\(message)")
    case .error:
      print("\(message)\n".red.bold)
    }
  }
  func printUsage() {
    let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
    writeMessage("Usage:")
    writeMessage("\(executableName) -c".green.underline)
    writeMessage("\t Share chrome current tab url".blue)
    writeMessage("\(executableName) -s".green.underline)
    writeMessage("\t Share safari current tab url".blue)
    writeMessage("\(executableName) -h".green.underline)
    writeMessage("\t Show usage information".blue)
    writeMessage("Type \(executableName) without an option to share chrome current tab URL.")
  }
}
