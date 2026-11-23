DROP DATABASE IF EXISTS ruta_andina;
CREATE DATABASE ruta_andina CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ruta_andina;

CREATE TABLE PAIS (
    id_pais INT AUTO_INCREMENT PRIMARY KEY,
    nombre_pais VARCHAR(60) NOT NULL UNIQUE,
    codigo_iso CHAR(2) NOT NULL UNIQUE,
    moneda CHAR(3) NOT NULL,
    porcentaje_comision DECIMAL(5,2) NOT NULL CHECK (porcentaje_comision >= 0 AND porcentaje_comision <= 100),
    CONSTRAINT chk_pais_moneda CHECK (moneda IN ('PEN', 'COP'))
);

CREATE TABLE TIPO_SERVICIO (
    id_tipo_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(40) NOT NULL UNIQUE,
    descripcion VARCHAR(150) NOT NULL,
    capacidad INT NOT NULL CHECK (capacidad > 0)
);

CREATE TABLE TARIFA_PAIS (
    id_tarifa INT AUTO_INCREMENT PRIMARY KEY,
    id_pais INT NOT NULL,
    id_tipo_servicio INT NOT NULL,
    tarifa_base DECIMAL(10,2) NOT NULL CHECK (tarifa_base >= 0),
    costo_km DECIMAL(10,2) NOT NULL CHECK (costo_km >= 0),
    costo_min DECIMAL(10,2) NOT NULL CHECK (costo_min >= 0),
    UNIQUE KEY uk_pais_servicio (id_pais, id_tipo_servicio),
    FOREIGN KEY (id_pais) REFERENCES PAIS(id_pais),
    FOREIGN KEY (id_tipo_servicio) REFERENCES TIPO_SERVICIO(id_tipo_servicio)
);

CREATE TABLE EMPRESA (
    id_empresa INT AUTO_INCREMENT PRIMARY KEY,
    id_pais INT NOT NULL,
    razon_social VARCHAR(100) NOT NULL,
    ruc_nit VARCHAR(25) NOT NULL UNIQUE,
    tipo_empresa VARCHAR(20) NOT NULL,
    CONSTRAINT chk_tipo_empresa CHECK (tipo_empresa IN ('OPERADORA', 'CLIENTE', 'FLOTA')),
    FOREIGN KEY (id_pais) REFERENCES PAIS(id_pais)
);

CREATE TABLE PASAJERO (
    id_pasajero INT AUTO_INCREMENT PRIMARY KEY,
    id_pais INT NOT NULL,
    id_empresa INT NULL,
    nombres VARCHAR(60) NOT NULL,
    apellidos VARCHAR(60) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(25) NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES PAIS(id_pais),
    FOREIGN KEY (id_empresa) REFERENCES EMPRESA(id_empresa)
);

CREATE TABLE DIRECCION_FAVORITA (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    id_pasajero INT NOT NULL,
    alias VARCHAR(40) NOT NULL,
    direccion_texto VARCHAR(150) NOT NULL,
    latitud DECIMAL(10,6) NULL,
    longitud DECIMAL(10,6) NULL,
    FOREIGN KEY (id_pasajero) REFERENCES PASAJERO(id_pasajero)
);

CREATE TABLE METODO_PAGO (
    id_metodo_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_pasajero INT NOT NULL,
    tipo_pago VARCHAR(20) NOT NULL,
    detalle_enmascarado VARCHAR(50) NOT NULL,
    es_predeterminado BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_tipo_pago CHECK (tipo_pago IN ('Tarjeta', 'Efectivo', 'Billetera')),
    FOREIGN KEY (id_pasajero) REFERENCES PASAJERO(id_pasajero)
);

CREATE TABLE CONDUCTOR (
    id_conductor INT AUTO_INCREMENT PRIMARY KEY,
    id_pais INT NOT NULL,
    id_empresa_flota INT NULL,
    nombres VARCHAR(60) NOT NULL,
    apellidos VARCHAR(60) NOT NULL,
    num_licencia VARCHAR(30) NOT NULL UNIQUE,
    venc_licencia DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT chk_estado_conductor CHECK (estado IN ('ACTIVO', 'SUSPENDIDO', 'INACTIVO')),
    FOREIGN KEY (id_pais) REFERENCES PAIS(id_pais),
    FOREIGN KEY (id_empresa_flota) REFERENCES EMPRESA(id_empresa)
);

CREATE TABLE VEHICULO (
    id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
    id_empresa_flota INT NULL,
    placa VARCHAR(15) NOT NULL UNIQUE,
    marca VARCHAR(40) NOT NULL,
    modelo VARCHAR(40) NOT NULL,
    anio INT NOT NULL CHECK (anio >= 2010),
    venc_soat DATE NOT NULL,
    FOREIGN KEY (id_empresa_flota) REFERENCES EMPRESA(id_empresa)
);

CREATE TABLE ASIGNACION_VEHICULO (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_conductor INT NOT NULL,
    id_vehiculo INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    es_activo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_conductor) REFERENCES CONDUCTOR(id_conductor),
    FOREIGN KEY (id_vehiculo) REFERENCES VEHICULO(id_vehiculo)
);

CREATE TABLE VIAJE (
    id_viaje INT AUTO_INCREMENT PRIMARY KEY,
    id_pasajero INT NOT NULL,
    id_conductor INT NOT NULL,
    id_tarifa INT NOT NULL,
    origen VARCHAR(120) NOT NULL,
    destino VARCHAR(120) NOT NULL,
    distancia_km DECIMAL(8,2) NOT NULL CHECK (distancia_km > 0),
    monto_total DECIMAL(12,2) NOT NULL CHECK (monto_total >= 0),
    estado VARCHAR(20) NOT NULL DEFAULT 'SOLICITADO',
    fecha_solicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_estado_viaje CHECK (estado IN ('SOLICITADO', 'ACEPTADO', 'EN_CURSO', 'FINALIZADO', 'CANCELADO')),
    FOREIGN KEY (id_pasajero) REFERENCES PASAJERO(id_pasajero),
    FOREIGN KEY (id_conductor) REFERENCES CONDUCTOR(id_conductor),
    FOREIGN KEY (id_tarifa) REFERENCES TARIFA_PAIS(id_tarifa)
);

CREATE TABLE PAGO (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_viaje INT NOT NULL UNIQUE,
    id_metodo_pago INT NOT NULL,
    monto_bruto DECIMAL(12,2) NOT NULL CHECK (monto_bruto >= 0),
    comision_app DECIMAL(12,2) NOT NULL CHECK (comision_app >= 0),
    moneda CHAR(3) NOT NULL,
    estado_pago VARCHAR(25) NOT NULL DEFAULT 'COMPLETADO',
    fecha_pago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_moneda_pago CHECK (moneda IN ('PEN', 'COP')),
    FOREIGN KEY (id_viaje) REFERENCES VIAJE(id_viaje),
    FOREIGN KEY (id_metodo_pago) REFERENCES METODO_PAGO(id_metodo_pago)
);

CREATE TABLE CALIFICACION (
    id_calificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_viaje INT NOT NULL UNIQUE,
    puntaje_conductor INT NOT NULL CHECK (puntaje_conductor BETWEEN 1 AND 5),
    comentario_conductor VARCHAR(200) NULL,
    puntaje_pasajero INT NULL CHECK (puntaje_pasajero BETWEEN 1 AND 5),
    comentario_pasajero VARCHAR(200) NULL,
    FOREIGN KEY (id_viaje) REFERENCES VIAJE(id_viaje)
);

CREATE TABLE FACTURA (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_empresa INT NOT NULL,
    periodo_inicio DATE NOT NULL,
    periodo_fin DATE NOT NULL,
    fecha_emision DATE NOT NULL,
    monto_total DECIMAL(12,2) NOT NULL CHECK (monto_total > 0),
    moneda CHAR(3) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'EMITIDA',
    CONSTRAINT chk_moneda_factura CHECK (moneda IN ('PEN', 'COP')),
    FOREIGN KEY (id_empresa) REFERENCES EMPRESA(id_empresa)
);

CREATE TABLE LIQUIDACION (
    id_liquidacion INT AUTO_INCREMENT PRIMARY KEY,
    id_conductor INT NOT NULL,
    periodo_inicio DATE NOT NULL,
    periodo_fin DATE NOT NULL,
    monto_bruto DECIMAL(12,2) NOT NULL CHECK (monto_bruto > 0),
    comision_app DECIMAL(12,2) NOT NULL CHECK (comision_app >= 0),
    monto_neto DECIMAL(12,2) NOT NULL CHECK (monto_neto > 0),
    moneda CHAR(3) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'PAGADA',
    CONSTRAINT chk_moneda_liq CHECK (moneda IN ('PEN', 'COP')),
    FOREIGN KEY (id_conductor) REFERENCES CONDUCTOR(id_conductor)
);

CREATE OR REPLACE VIEW vw_resumen_viajes AS
SELECT 
    v.id_viaje,
    CONCAT(p.nombres, ' ', p.apellidos) AS pasajero,
    IF(p.id_empresa IS NULL, 'Personal', CONCAT('Corp: ', e.razon_social)) AS perfil_cuenta,
    CONCAT(c.nombres, ' ', c.apellidos) AS conductor,
    veh.placa,
    v.origen,
    v.destino,
    ts.nombre_servicio AS tipo_servicio,
    v.monto_total,
    pa.moneda,
    v.estado,
    v.fecha_solicitud,
    cal.puntaje_conductor
FROM VIAJE v
JOIN PASAJERO p ON v.id_pasajero = p.id_pasajero
LEFT JOIN EMPRESA e ON p.id_empresa = e.id_empresa
JOIN CONDUCTOR c ON v.id_conductor = c.id_conductor
LEFT JOIN ASIGNACION_VEHICULO av ON c.id_conductor = av.id_conductor AND av.es_activo = TRUE
LEFT JOIN VEHICULO veh ON av.id_vehiculo = veh.id_vehiculo
JOIN TARIFA_PAIS tp ON v.id_tarifa = tp.id_tarifa
JOIN PAIS pa ON tp.id_pais = pa.id_pais
JOIN TIPO_SERVICIO ts ON tp.id_tipo_servicio = ts.id_tipo_servicio
LEFT JOIN CALIFICACION cal ON v.id_viaje = cal.id_viaje;