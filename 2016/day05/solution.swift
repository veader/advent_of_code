#!/usr/bin/env swift

import Foundation

func shell(_ args: String...) -> String? {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)

    task.waitUntilExit()
    return output
}

func md5(_ input: String) -> String? {
    guard let md5Response = shell("md5", "-s", input) else { return nil }
    return md5Response.components(separatedBy: " ").last
}

/*
func md5(_ string: String) -> String {
    var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
    CC_MD5(string, CC_LONG(string.lengthOfBytes(using: .utf8)), &digest)
    let hexString = digest.map { String(format: "%02hhx", $0) }.joined()

    return hexString
}
*/

// ------------------------------------------------------------------
// MARK: - "MAIN()"

print("Unable to shell out enough times, quickly enough, to solve this.")
print("Unable to determine how to import CommonCrypto into a script to perform MD5 in code.")

/*
let input = "abc"
// let input = "wtnhxymk"

var passwordChars = [Character]()
var hashSuffix = 0
while passwordChars.count < 2 {
    if let hash = md5("\(input)\(hashSuffix)") {
        if hash.hasPrefix("00000") {
            print("\(hashSuffix) -> \(hash)")
            let passwordCharIndex = hash.index(hash.startIndex, offsetBy: 5)
            passwordChars.append(hash[passwordCharIndex])
        }
    }
    hashSuffix = hashSuffix + 1

    if hashSuffix % 1000 == 0 {
        print("Mod 1k: \(hashSuffix)")
    }
}

print(md5("abc3231929")!)
print(md5("abc5017308")!)
*/
