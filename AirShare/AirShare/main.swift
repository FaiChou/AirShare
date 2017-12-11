//
//  main.swift
//  AirShare
//
//  Created by 周辉 on 10/12/2017.
//  Copyright © 2017 FaiChou. All rights reserved.
//

import Cocoa

let air = AirShare()
air.run()

let app = NSApplication.shared
app.delegate = air
app.run()
