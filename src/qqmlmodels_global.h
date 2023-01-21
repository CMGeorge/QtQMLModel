#ifndef QQMLMODELS_GLOBAL_H
#define QQMLMODELS_GLOBAL_H

    #ifndef QT_STATIC
        #pragma message("Not stativ")
        #if defined(QQML_EXPORT)
            #pragma message("Is Export")
            #define QQMLMODELS_EXPORT Q_DECL_EXPORT
        #else
            #pragma message("Is import")
            #define QQMLMODELS_EXPORT Q_DECL_IMPORT
        #endif
    #else
        #define QQMLMODELS_EXPORT
    #endif
//#define  QQMLMODELS_EXPORT
#endif // QQMLMODELS_GLOBAL_H
