//
//  Formatter.swift
//  
//
//  Created by Jay on 2/21/23.
//

import Foundation
import PackagePlugin


@main
public struct Formatter: CommandPlugin {
    public init() { }
    @available(macOS 11, *)
    public func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        let swiftFormatTool = try context.tool(named: "swift-format")
        // Optional
        let configFile = context.package.directory.appending(".swift-format.json")
        // Setup Swift format execution
        if #available(macOS 13.0, *) {
            let format = URL(filePath: swiftFormatTool.path.string)
            for target in context.package.targets {
                let formatArgs = [
                    "--configuration \(configFile.string)",
                    "--i",
                    "--r",
                    target.directory.string
                ]

                let process = try Process.run(format, arguments: formatArgs)
                process.waitUntilExit()

                if process.terminationReason == .exit && process.terminationStatus == 0 {
                    print("Formatted the source code in \(target.directory).")
                }
                else {
                    let problem = "\(process.terminationReason):\(process.terminationStatus)"
                    Diagnostics.error("swift-format invocation failed: \(problem)")
                }
            }
        }
    }
}
