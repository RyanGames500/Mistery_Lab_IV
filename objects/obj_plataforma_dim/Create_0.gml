x_base = x;
y_base = y;
oculta = false;
aviso = 0;
objetivo_oculta = false;

// La Soberana la llama en cada teletransporte
alternar = function() {
    if (aviso > 0) return;
    aviso = 40;
    objetivo_oculta = !oculta;
};

// Se usa al morir la jefa
mostrar = function() {
    aviso = 0;
    oculta = false;
    y = y_base;
};