#ifndef QQMLMODELS_GLOBAL_H
#define QQMLMODELS_GLOBAL_H

#ifndef QT_STATIC
#   if defined(QQML_EXPORT)
#       define QQMLMODELS_EXPORT Q_DECL_EXPORT
#   else
#       define QQMLMODELS_EXPORT Q_DECL_IMPORT
#   endif
#else
#   define QQMLMODELS_EXPORT
#endif
//#define  QQMLMODELS_EXPORT
#endif // QQMLMODELS_GLOBAL_H
