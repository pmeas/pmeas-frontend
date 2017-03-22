
#include "effect.h"
#include "parametermodel.h"

#include <QDebug>

Effect::Effect(QObject *parent) : QObject( parent ) {

}

Effect::Effect( Type t_type, QObject *parent ) : Effect( parent )
{

    setEffectType( t_type );

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
        break;

    case Type::Delay:
        m_name = "Delay";
        break;

    case Type::Reverb:
        m_name = "Reverb";
        break;

    case Type::Harmonizer:
        m_name = "Harmonizer";
        break;

    case Type::FrequencyShift:
        m_name = "Frequency Shift";
        break;

    case Type::Phaser:
        m_name = "Phaser";
        break;

    case Type::Chorus:
        m_name = "Chorus";
        break;

    case Type::Flanger:
        m_name = "Flanger";
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
