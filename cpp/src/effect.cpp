
#include "effect.h"
#include "parametermodel.h"

#include <QDebug>

Effect::Effect(QObject *parent) : QObject( parent ) {

}

Effect::Effect( Type t_type, QObject *parent ) : Effect( parent )
{

    setEffectType( t_type );

}

QString Effect::broadcastName() const {
    return m_broadcastName;
}

QString Effect::name() const {
    return m_name;
}

Effect::Type Effect::effectType() const {
    return m_effectType;
}

ParameterModel *Effect::model() const {
    return m_model;
}

void Effect::setEffectType(Effect::Type t_type) {

    m_effectType = t_type;
    switch( t_type ) {

    case Type::Distortion:
        m_name = "Distortion";
        m_broadcastName = "distortion";
        break;

    case Type::Delay:
        m_name = "Delay";
        m_broadcastName = "delay";
        break;

    case Type::Reverb:
        m_name = "Reverb";
        m_broadcastName = "reverb";
        break;

    case Type::Harmonizer:
        m_name = "Harmonizer";
        m_broadcastName = "harmonizer";
        break;

    case Type::FrequencyShift:
        m_name = "Frequency Shift";
        m_broadcastName = "freqshift";
        break;

    case Type::Phaser:
        m_name = "Phaser";
        m_broadcastName = "phaser";
        break;

    case Type::Chorus:
        m_name = "Chorus";
        m_broadcastName = "chorus";
        break;

    case Type::Flanger:
        m_name = "Flanger";
        m_broadcastName = "flanger";
        break;

    default:
        break;
    }

    emit effectTypeChanged();

}

void Effect::setModel(const QJsonArray &t_array) {
    m_model = new ParameterModel( t_array, this );
}

void Effect::setModel(Effect::Type t_type) {
    m_model = new ParameterModel( t_type, this );
}
