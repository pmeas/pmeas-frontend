#pragma once

#include "parametermodel.h"
#include "effect.h"

#include <QAbstractTableModel>

#include <QQmlListProperty>

#include <QJsonDocument>

#include <initializer_list>


class EffectsModel : public QAbstractTableModel
{
    Q_OBJECT
    Q_PROPERTY( QQmlListProperty<Effect> effectList READ effectList )

    // This enables SqlModel to use SqlColumns declared as children and
    // use them in the 'tableColumns' Q_PROPERTY, without needing to directly
    // assign them.
    Q_CLASSINFO("DefaultProperty", "effectList")

public:
    explicit EffectsModel( QObject *parent = nullptr );
    virtual ~EffectsModel();

    enum Roles : int {
        EffectName = Qt::UserRole + 1,
        EffectType,
        EffectModel,
    };

    QHash<int, QByteArray> roleNames() const override;

    int rowCount(const QModelIndex &parent) const override;

    int columnCount(const QModelIndex &parent) const override;

    QVariant data(const QModelIndex &index, int role) const override;

    Qt::ItemFlags flags(const QModelIndex &index) const override;

    static void registerTypes();

    QQmlListProperty<Effect> effectList();

    static void appendEffect( QQmlListProperty<Effect> *list, Effect *effect );

    QByteArray toJson( QJsonDocument::JsonFormat t_fmt );

public slots:
    void append( Effect::Type t_type );
    void remove( int t_index );
    void insert( int t_index, Effect::Type t_type );

    void move( int t_srcIndex, int t_destIndex );

    void clear();

    bool loadSetlist( QString filePath );
    bool saveSetlist( QString filePath );

    QByteArray toBroadcastJson();
    QByteArray toBroadcastJson(float);

    static QString dialogPath();

private:
    void append( Effect *t_effect );

private:
    QVector<Effect *> m_model;
    QHash<int, QByteArray> m_roleNames;
};
