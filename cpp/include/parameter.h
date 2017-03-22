#pragma once

#include <QMetaType>

struct Parameter
{
    Parameter() = default;
    ~Parameter() = default;

    QString name;
    int min{ 0 };
    int max{ 0 };
    int value{ 0 };
};

Q_DECLARE_METATYPE( Parameter )
