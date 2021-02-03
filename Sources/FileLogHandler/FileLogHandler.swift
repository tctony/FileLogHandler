import Foundation
import struct Logging.Logger
import protocol Logging.LogHandler
import LogFormatter
import os

public final class FileLogFormatter: LogFormatter {
    private var inner: LogDefaultFormatter
    private var dateFormatter: DateFormatter

    public init(shortFileName: ((String) -> String)? = nil) {
        self.inner = LogDefaultFormatter(shortFileName: shortFileName)
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }

    public func format(level: Logger.Level,
                       message: Logger.Message,
                       metadata: Logger.Metadata,
                       file: String, function: String,
                       line: UInt) -> String {
        let message = self.inner.format(level: level, message: message, metadata: metadata, file: file, function: function, line: line)

        return "\(self.dateFormatter.string(from: Date())) \(message)\n"
    }
}

public class FileLogHandler: LogHandler {

    public var logLevel: Logger.Level = .info

    public var formatter: LogFormatter

    private var queue: DispatchQueue
    private var fh: FileHandle!

    public init(filePath: String,
                formatter: LogFormatter = FileLogFormatter()) {
        self.formatter = formatter

        self.queue = DispatchQueue(label: "FileLogQueue", qos: .background)
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        self.fh = FileHandle(forUpdatingAtPath: filePath)
        self.fh.seekToEndOfFile()
    }

    public func close() {
        guard self.fh != nil else {
            return
        }
        
        self.queue.sync {
            self.fh!.closeFile()
            self.fh = nil
        }
    }

    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    source: String,
                    file: String,
                    function: String,
                    line: UInt) {
        guard self.fh != nil else {
            return
        }

        self.queue.async {
            let formattedMessage = self.formatter.format(level: level,
                                                      message: message,
                                                      metadata: self.metadata,
                                                      file: file,
                                                      function: function,
                                                      line: line)
            if let data = formattedMessage.data(using: .utf8) {
                self.fh?.write(data)
            }
        }
    }

    public subscript(metadataKey _: String) -> Logger.Metadata.Value? {
        get {
            // do nothing
            return nil
        }
        set(newValue) {
            // do nothing
        }
    }

    public var metadata: Logger.Metadata = Logger.Metadata()
}
