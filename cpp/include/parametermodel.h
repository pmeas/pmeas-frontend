#pragma once

#include <QAbstractTableModel>

#include "parameter.h"
#include "effect.h"

class QJsonArray;

class ParameterModel : public QAbstractTableModel
{
    Q_OBJECT
public:

    enum Roles : int {
        ParameterName = Qt::UserRole + 1,
        ParameterValue,
        ParameterMinValue,
        ParameterMaxValue,
    };

    explicit ParameterModel( Effect::Type t_effectType, QObject *parent = nullptr );
    explicit ParameterModel( const QJsonArray &parameters, QObject *parent = nullptr );

    explicit ParameterModel( QObject *parent = nullptr );

    virtual ~ParameterModel() = default;

public: // Overridden model functionality and NEEDS to be here.
    QHash<int, QByteArray> roleNames() const override;

    int rowCount(const QModelIndex &parent) const override;

    int columnCount(const QModelIndex &parent) const override;

    QVariant data(const QModelIndex &index, int role) const override;

    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;

    Qt::ItemFlags flags(const QModelIndex &index) const override;

public: // Iterators
    const Parameter &at( int t_index ) const;
    int size() const;

    QVector<Parameter>::iterator begin();

    QVector<Parameter>::const_iterator cbegin() const;

    QVector<Parameter>::iterator end();

    QVector<Parameter>::const_iterator cend() const;

public slots:
    void initializeParameters( Effect::Type t_type );
    void append( QString t_name, int t_min, int t_max, int t_value );

private slots:

private:
    QHash<int, QByteArray> m_roleNames;

    // Store all of the parameter values.
    QVector<Parameter> m_model;

};

Q_DECLARE_METATYPE( ParameterModel * )
