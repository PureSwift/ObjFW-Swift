#ifdef __APPLE__
#include "/opt/homebrew/include/ObjFW/ObjFW.h"
#else
#include "ObjFWRT.h"
#endif

// Types
typedef id objfw_id;
typedef Class objfw_class;
typedef SEL objfw_sel;

// Shims for class and selector handling
static inline objfw_class _Nullable objfw_get_class(const char *name) {
    return objc_getClass(name);
}

static inline objfw_class _Nullable objfw_get_meta_class(const char *name) {
    Class cls = objc_getClass(name);
    Class metaCls = object_getClass(cls);
    return metaCls;
}

static inline objfw_class objfw_allocate_class_pair(objfw_class superclass, const char *name, size_t extraBytes) {
    return objc_allocateClassPair(superclass, name, extraBytes);
}

static inline void objfw_register_class_pair(objfw_class cls) {
    objc_registerClassPair(cls);
}

static inline objfw_sel objfw_register_selector(const char *name) {
    return sel_registerName(name);
}

#if __APPLE__
#else
extern id OFAllocObject(objfw_class class_, size_t extraSize, size_t extraAlignment, void *_Nullable *_Nullable extra);
#endif

// Shims for object instantiation
static inline objfw_id _Nullable objfw_create_instance(objfw_class class_, size_t extraSize) {
#if __APPLE__
    return class_createInstance(class_, extraSize);
#else
    return OFAllocObject(class_, extraSize, 0, nil);
#endif
}

// Shims for adding methods
static inline BOOL objfw_class_add_method(
    objfw_class cls,
    objfw_sel name,
    IMP imp,
    const char *types
) {
    return class_addMethod(cls, name, imp, types);
}

id ofobject_create_and_init() {
    Class cls = objc_getClass("OFObject");
    if (!cls) {
        [OFStdErr writeLine: @"OFObject class not found"];
        return nil;
    }

    id obj = class_createInstance(cls, 0);
    SEL initSel = sel_registerName("init");
    obj = objc_msg_send(obj, initSel);

    return obj;
}

id ofobject_description(id obj) {
    SEL descSel = sel_registerName("description");
    return objc_msg_send(obj, descSel);
}
