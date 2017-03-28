#pragma once

#include <QObject>

class ParameterModel;
class QJsonArray;

class Effect : public QObject {
    Q_OBJECT
    Q_PROPERTY(Type effectType READ effectType WRITE setEffectType NOTIFY effectTypeChanged)

public:

    enum Type : int {
        Invalid = -1,
        Distortion,
        Delay,
        Reverb,
        Harmonizer,
        FrequencyShift,
        Phaser,
        Chorus,
        Flanger,
        Max,
    };
    Q_ENUM( Type )

    explicit Effect( QObject *parent = nullptr );
    explicit Effect( Type t_type, QObject *parent = nullptr );

    QString broadcastName() const;
    QString name() const;
    Type effectType() const;
    ParameterModel *model() const;

    void setEffectType( Type t_type );
    void setModel( const QJsonArray &t_array );
    void setModel( Type t_type );


signals:
    void effectTypeChanged();

private:
    Type m_effectType;
    ParameterModel *m_model;
    QString m_name;
    QString m_broadcastName;

};


Q_DECLARE_METATYPE( Effect * )
