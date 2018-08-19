//
//  cache.swift
//  llv2
//
//  Created by 林蔼欣 on 2018-08-16.
//  Copyright © 2018 Luna Cao. All rights reserved.
//

import Foundation

//
//func clearCache() {
//
//    // 取出cache文件夹目录 缓存文件都在这个目录下
//    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
//
//    // 取出文件夹下所有文件数组
//    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
//
//    // 遍历删除
//    for file in fileArr! {
//
//        let path = cachePath?.stringByAppendingString("/\(file)")
//        if FileManager.defaultManager().fileExistsAtPath(path!) {
//
//            do {
//                try FileManager.defaultManager().removeItemAtPath(path!)
//            } catch {
//
//            }
//        }
//    }
//}

