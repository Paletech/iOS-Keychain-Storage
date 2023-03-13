# iOS-Keychain-Storage

This library provides a Keychain service implementation that allows storing and retrieving data securely using the iOS Keychain. The `KeychainService` class offers several methods to set and retrieve data for a given key, as well as delete and clear all data from the Keychain.

# Public Methods

`setString(_:_:withAccessibility:)`
```swift 
open func setString(_ value: String, forKey key: String, withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool
```
This method allows you to store a string value for a given key in the Keychain. The accessibility parameter specifies the level of security required to access the data. The method returns `true` if the operation succeeds, or `false` if an error occurs.

<hr>

`getString(_:)`
```swift 
open func getString(_ key: String) -> String?
```
This method allows you to retrieve a string value for a given key from the Keychain. The method returns the `String` value if it exists, or nil if it does not.

<hr>

`setData(_:_:withAccessibility:)`
```swift 
open func setData(_ value: Data, forKey key: String, withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool
```
This method allows you to store a `Data` value for a given key in the Keychain. The `accessibility` parameter specifies the level of security required to access the data. The method returns `true` if the operation succeeds, or `false` if an error occurs.

<hr>

`getData(_:)`
```swift 
open func getData(_ key: String) -> Data?
```
This method allows you to retrieve a `Data` value for a given key from the Keychain. The method returns the `Data` value if it exists, or `nil` if it does not.

<hr>

`setBool(_:_:withAccessibility:)`
```swift 
open func setBool(_ value: Bool, forKey key: String, withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool
```
This method allows you to store a `Bool` value for a given key in the Keychain. The `accessibility` parameter specifies the level of security required to access the data. The method returns `true` if the operation succeeds, or `false` if an error occurs.

<hr>

`getBool(_:)`
```swift 
open func getBool(_ key: String) -> Bool?
```
This method allows you to retrieve a `Bool` value for a given key from the Keychain. The method returns the `Bool` value if it exists, or `nil` if it does not.

<hr>

`delete(_:)`
```swift
open func delete(_ key: String) -> Bool
```
This method allows you to delete the data for a given key from the Keychain. The method returns `true` if the operation succeeds, or `false` if an error occurs.

<hr>

`clear()`
```swift
open func clear() -> Bool
```
This method allows you to clear all data from the Keychain. The method returns `true` if the operation succeeds, or `false` if an error occurs.

<hr>

`allKeys()`
```swift
open func allKeys() -> [String]
```
This method allows you to retrieve all keys in the Keychain. The method returns an array of all the keys, or an empty array if no keys exist.

# KeychainWrapper
In addition to the `KeychainService` class, this library provides a wrapper class called `KeychainWrapper`. The `KeychainWrapper` class provides a simpler interface for storing and retrieving data in the Keychain.

## Usage 
To use wrapper, declare a property using the `@KeychainWrapper` wrapper and specify the type of data to be stored/retrieved, along with a unique key:
```swift
@KeychainWrapper(key: "mySensitiveData")
var sensitiveData: String?
```
The wrapped value can then be accessed and set just like any other property:
```swift
sensitiveData = "mySecretPassword"
print(sensitiveData) // Optional("mySecretPassword")
```
## Supported Types
`@KeychainWrapper` currently supports storing/retrieving values of the following types:
* `Bool`
* `String`
* `Data`

#### For more examples checkout [Sample](https://github.com/Paletech/iOS-Keychain-Storage/tree/fix/Sources/Sample) module in a package

# Error handling
The `KeychainService` class can throw several different types of errors when performing operations. These errors are all instances of the `KeychainError` enum. The possible error cases are:
* `encodingError` - Encoding task failed in the Keychain. Code: -1
* `decodingError` - Decoding task failed in the Keychain. Code: -67853
* `securityError` - SecurityError in the Keychain. Check your entitlements. Code: -34018
* `noDataError` - No data found by provided key in the Keychain
* `noDataToDeleteError` - No data to delete by this provided key
* `noKeysData` - Error retrieving all keys from Keychain. Keychain is empty 
