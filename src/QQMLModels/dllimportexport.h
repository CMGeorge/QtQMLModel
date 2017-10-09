#ifndef DLLIMPORTEXPORT_H
#define DLLIMPORTEXPORT_H

#ifndef QT_STATIC
#   if defined(QQML_LIB_BUILD)
#       define QQMLMODELS_EXPORT Q_DECL_EXPORT
#   else
#       define QQMLMODELS_EXPORT Q_DECL_IMPORT
#   endif
#else
#   define QQMLMODELS_EXPORT
#endif
//#define  QQMLMODELS_EXPORT
#endif // DLLIMPORTEXPORT_H
