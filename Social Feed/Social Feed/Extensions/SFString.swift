//
//  SFString.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 05/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import Foundation

extension String {
    static func extractURLs(text: String) -> [NSURL] {
        var urls : [NSURL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: text,
                                      options: [],
                                      range: NSMakeRange(0, text.characters.count),
                                      using: { (result, _, _) in
                                                if let match = result, let url = match.url {
                                                    urls.append(url as NSURL)
                                                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
}
