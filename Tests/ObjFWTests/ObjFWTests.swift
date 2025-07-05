import Testing
import CObjFW
@testable import ObjFW

@MainActor
@Test func string() async throws {
    
    #if canImport(Darwin)
    let className = "NSString"
    #else
    let className = "OFString"
    #endif
    
    // Get OFString class
    let stringClass: objfw_class = try #require(objfw_get_class(className))
    let stringMetaClass: objfw_class = try #require(objfw_get_meta_class(className))
    
    // Get selectors
    let selCreate = try #require(objfw_register_selector("stringWithUTF8String:"))
    let selString = try #require(objfw_register_selector("UTF8String"))
    
    // Create the OFString instance
    let swiftStr = "Hello from Swift calling ObjFW C API!"
    let obj = swiftStr.withCString { cString in
        let imp = class_getMethodImplementation(stringMetaClass, selCreate)
        typealias MsgSendCreate = @convention(c) (objfw_class, objfw_sel, UnsafePointer<CChar>) -> objfw_id
        let fn = unsafeBitCast(imp, to: MsgSendCreate.self)
        return fn(stringClass, selCreate, cString)
    }
    
    let message: String
    do {
        let impUTF8 = class_getMethodImplementation(stringClass, selString)
        typealias FnUTF8 = @convention(c) (objfw_id, objfw_sel) -> UnsafePointer<CChar>
        let fnUTF8 = unsafeBitCast(impUTF8, to: FnUTF8.self)
        let cStr = fnUTF8(obj, selString)
        message = String(cString: cStr)
    }
    
    print("ObjFW says: \(message)")
}

//@_silgen_name("objc_msgSend")
//func objfw_msgSend()

/*
// objfw_id objfw_msgSend_class_id_cstr(objfw_class cls, objfw_sel sel, const char *arg)
@_silgen_name("objc_msgSend")
func objfw_msgSend_class_id_cstr(_ class: objfw_class, _ sel: objfw_sel, _ cString: UnsafePointer<Int8>) -> objfw_id

// const char *objfw_msgSend_cstr(objfw_id obj, objfw_sel sel)
@_silgen_name("objc_msgSend")
func objfw_msgSend_cstr(_ obj: objfw_id, _ sel: objfw_sel) -> UnsafePointer<Int8>
*/
