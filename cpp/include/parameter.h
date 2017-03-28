#pragma once

#include <QMetaType>

struct  Parameter
{
    Parameter() = default;
    ~Parameter() = default;

    QString name;
    QString broadcastName;
    QVariant min{ 0 };
    QVariant max{ 0 };
    QVariant value{ 0 };
};

Q_DECLARE_METATYPE( Parameter )
