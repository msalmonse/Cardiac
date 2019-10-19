//
//  FileData.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-26.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

class FileData {
    let id = UUID()

    var url: URL?
    var contents: String = ""

    init(_ url: URL?) {
        self.url = url
    }

    func open(_ url: URL? = nil) -> Result<String, Error> {
        if self.url == nil && url == nil { return .failure(FileError.urlNotDefined) }
        if url != nil { self.url = url }

        do {
            contents = try String(contentsOf: self.url!)
        } catch {
            return .failure(error)
        }

        return .success(contents)
    }

    func saveAs(_ url: URL) -> Result<Void, Error> {
        do {
            switch createDirectoryContaining(url: url) {
            case let .failure(err): return.failure(err)
            case .success: break
            }
            try contents.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            return .failure(error)
        }
        return .success(Void())
    }

    func save() -> Result<Void, Error> {
        if url == nil { return .failure(FileError.urlNotDefined) }
        return self.saveAs(url!)
    }
}
