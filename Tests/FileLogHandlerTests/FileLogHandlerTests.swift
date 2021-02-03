import XCTest
@testable import FileLogHandler

final class FileLogHandlerTests: XCTestCase {
    func testExample() {
        let handler: FileLogHandler! = FileLogHandler(filePath: "/tmp/test.log")
        for index in 0..<100 {
            handler.log(level: .info, message: "\(index)\n", metadata: nil, source: "", file: "test.swift", function: "test", line: 8)
        }
        handler.close()

        let handler2: FileLogHandler! = FileLogHandler(filePath: "/tmp/test.log")
        for index in 0..<100 {
            handler2.log(level: .info, message: "\(100+index)\n", metadata: nil, source: "", file: "test.swift", function: "test", line: 8)
        }
        handler2.close()
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
