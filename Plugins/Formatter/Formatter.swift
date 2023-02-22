//
//  Formatter.swift
//  
//
//  Created by Jay on 2/21/23.
//

import Foundation
import PackagePlugin


@available(macOS 13.0, *)
@main
public struct Formatter: CommandPlugin {
    public init() { }
    public func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        let swiftFormatTool = try context.tool(named: "swift-format")
        // Setup Swift format execution
        let format = URL(filePath: swiftFormatTool.path.string)
        for target in context.package.targets {
            guard let target = target as? SourceModuleTarget else { continue }
            let formatArgs = [
                "-i",
                "-r",
                "\(target.directory)"
            ]

            let process = Process()
            process.executableURL = format
            process.arguments = formatArgs

            try process.run()
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
