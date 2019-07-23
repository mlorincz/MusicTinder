//
//  ReachabilityService.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 03/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import Foundation

struct ReachabilityService {

    static var isNetworkReachable: Bool {
        let url: URL = URL(string: "http://google.com" as String)!
        let reachability = Reachability(hostname: url.host!)
        return reachability?.currentReachabilityStatus != .notReachable
    }
}
