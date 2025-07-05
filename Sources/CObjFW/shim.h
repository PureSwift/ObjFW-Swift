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

static inline objfw_class objfw_allocate_class_pair(objfw_class superclass, const char *name, size_t extraBytes) {
    return objc_allocateClassPair(superclass, name, extraBytes);
}

static inline void objfw_register_class_pair(objfw_class cls) {
    objc_registerClassPair(cls);
}

static inline objfw_sel objfw_register_selector(const char *name) {
    return sel_registerName(name);
}

// Shims for object instantiation
static inline objfw_id objfw_create_instance(objfw_class cls, size_t extraBytes) {
    return class_createInstance(cls, extraBytes);
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

// Instance method returning objfw_id, taking no parameters
static inline objfw_id objfw_msgSend_id(objfw_id obj, objfw_sel sel) {
    return ((objfw_id (*)(objfw_id, objfw_sel))objc_msgSend)(obj, sel);
}

// Instance method returning objfw_id, taking one objfw_id parameter
static inline objfw_id objfw_msgSend_id_id(objfw_id obj, objfw_sel sel, objfw_id arg) {
    return ((objfw_id (*)(objfw_id, objfw_sel, objfw_id))objc_msgSend)(obj, sel, arg);
}

// Instance method returning objfw_id, taking one const char * parameter
static inline objfw_id objfw_msgSend_id_cstr(objfw_id obj, objfw_sel sel, const char *arg) {
    return ((objfw_id (*)(objfw_id, objfw_sel, const char *))objc_msgSend)(obj, sel, arg);
}

// Instance method returning int, no parameters
static inline int objfw_msgSend_int(objfw_id obj, objfw_sel sel) {
    return ((int (*)(objfw_id, objfw_sel))objc_msgSend)(obj, sel);
}

// Instance method returning BOOL, no parameters
static inline BOOL objfw_msgSend_bool(objfw_id obj, objfw_sel sel) {
    return ((BOOL (*)(objfw_id, objfw_sel))objc_msgSend)(obj, sel);
}

// Instance method returning const char *, no parameters
static inline const char *objfw_msgSend_cstr(objfw_id obj, objfw_sel sel) {
    return ((const char *(*)(objfw_id, objfw_sel))objc_msgSend)(obj, sel);
}

// Class method returning objfw_id, taking one const char * parameter
static inline objfw_id objfw_msgSend_class_id_cstr(objfw_class cls, objfw_sel sel, const char *arg) {
    return ((objfw_id (*)(objfw_class, objfw_sel, const char *))objc_msgSend)(cls, sel, arg);
}

// Class method returning objfw_id, taking no parameters
static inline objfw_id objfw_msgSend_class_id(objfw_class cls, objfw_sel sel) {
    return ((objfw_id (*)(objfw_class, objfw_sel))objc_msgSend)(cls, sel);
}
