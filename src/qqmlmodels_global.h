#ifndef QQMLMODELS_GLOBAL_H
#define QQMLMODELS_GLOBAL_H

#include <QtCore/qglobal.h>

#ifndef QT_STATIC
#if defined(QQML_EXPORT)
/* We are building this library */
#define QQMLMODELS_EXPORT Q_DECL_EXPORT
#else
/* We are using this library */
#define QQMLMODELS_EXPORT Q_DECL_IMPORT
#endif
#else
#define QQMLMODELS_EXPORT
#endif

#endif // QQMLMODELS_GLOBAL_H
