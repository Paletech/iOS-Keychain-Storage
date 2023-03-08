import XCTest
@testable import KeychainStorage

final class KeychainStorageTests: XCTestCase {
    
    let keychainService = KeychainService()
    let key = "key"
    let value = "value"
    
    func testExample() throws {
        XCTAssertEqual(KeychainService().text, "Hello, World!")
    }
    
    override func setUp() {
        super.setUp()
        XCTAssertTrue(keychainService.clear(), " ")
    }
    
    override func tearDown() {
        XCTAssertTrue(keychainService.clear(), " ")
        super.tearDown()
    }
    
    func testSet() {
        let checkData = keychainService.setString(value, forKey: key)
        XCTAssertTrue(checkData, " ")
    }
    
    func testGet() {
        XCTAssertEqual(keychainService.getString(key), value, "")
    }
    
    func testDelete() {
        XCTAssertTrue(keychainService.setString(value, forKey: key), "")
        XCTAssertTrue(keychainService.delete(key), "")
        XCTAssertNil(keychainService.getString(key), "")
    }
    
    func testClear() {
        XCTAssertTrue(keychainService.setString(value, forKey: key), "")
        XCTAssertTrue(keychainService.clear(), "")
        XCTAssertNil(keychainService.getString(key), "")
    }
    
//    func testAllKeys() {
//        XCTAssertTrue(keychainService.setString(value, forKey: key), " ")
//        let keys = keychainService.allKeys()
//        XCTAssertEqual(keys.count, 1, " ")
//        XCTAssertEqual(keys[0], key, "\(key)")
//    }
}

