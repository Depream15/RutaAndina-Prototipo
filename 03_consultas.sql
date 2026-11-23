-- Paso 3: consultas, vista y procedimiento
USE ruta_andina;
-- 1. Viajes finalizados por conductor en el ultimo mes
SELECT 
    c.id_conductor,
    CONCAT(c.nombres, ' ', c.apellidos) AS conductor,
    pa.nombre_pais AS pais,
    COUNT(v.id_viaje) AS viajes_finalizados,
    SUM(v.monto_total) AS total_generado,
    pa.moneda
FROM CONDUCTOR c
JOIN PAIS pa ON c.id_pais = pa.id_pais
JOIN VIAJE v ON c.id_conductor = v.id_conductor
WHERE v.estado = 'FINALIZADO'
  AND v.fecha_solicitud >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY c.id_conductor, conductor, pa.nombre_pais, pa.moneda
ORDER BY viajes_finalizados DESC;

-- 2. Ingresos de la plataforma por pais y moneda
SELECT 
    pa.nombre_pais AS pais,
    pg.moneda,
    COUNT(pg.id_pago) AS total_viajes_pagados,
    SUM(pg.monto_bruto) AS facturacion_bruta,
    SUM(pg.comision_app) AS ingreso_neto_plataforma
FROM PAGO pg
JOIN VIAJE v ON pg.id_viaje = v.id_viaje
JOIN TARIFA_PAIS tp ON v.id_tarifa = tp.id_tarifa
JOIN PAIS pa ON tp.id_pais = pa.id_pais
GROUP BY pa.nombre_pais, pg.moneda;

-- 3. Top 5 conductores por calificacion promedio (minimo 5 viajes finalizados)
SELECT 
    c.id_conductor,
    CONCAT(c.nombres, ' ', c.apellidos) AS conductor,
    pa.nombre_pais AS pais,
    COUNT(DISTINCT v.id_viaje) AS total_viajes,
    ROUND(AVG(cal.puntaje_conductor), 2) AS calificacion_promedio
FROM CONDUCTOR c
JOIN PAIS pa ON c.id_pais = pa.id_pais
JOIN VIAJE v ON c.id_conductor = v.id_conductor AND v.estado = 'FINALIZADO'
JOIN CALIFICACION cal ON v.id_viaje = cal.id_viaje
GROUP BY c.id_conductor, conductor, pa.nombre_pais
HAVING COUNT(DISTINCT v.id_viaje) >= 5
ORDER BY calificacion_promedio DESC, total_viajes DESC
LIMIT 5;

-- 4. Consumo mensual de cada empresa cliente (y estado de facturacion)
SELECT 
    e.razon_social AS empresa_cliente,
    pa.nombre_pais AS pais,
    DATE_FORMAT(v.fecha_solicitud, '%Y-%m') AS mes,
    COUNT(v.id_viaje) AS viajes_corporativos,
    SUM(v.monto_total) AS consumo_total,
    pa.moneda
FROM EMPRESA e
JOIN PAIS pa ON e.id_pais = pa.id_pais
JOIN PASAJERO p ON e.id_empresa = p.id_empresa
JOIN VIAJE v ON p.id_pasajero = v.id_pasajero
WHERE e.tipo_empresa = 'CLIENTE'
  AND v.estado = 'FINALIZADO'
GROUP BY e.razon_social, pa.nombre_pais, mes, pa.moneda
ORDER BY mes DESC, consumo_total DESC;

-- 5. Conductores con licencia o seguro (SOAT) que vence en 30 dias
SELECT 
    c.id_conductor,
    CONCAT(c.nombres, ' ', c.apellidos) AS conductor,
    pa.nombre_pais AS pais,
    c.num_licencia,
    c.venc_licencia,
    veh.placa,
    veh.venc_soat,
    CASE 
        WHEN c.venc_licencia <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN 'Licencia proxima a vencer'
        WHEN veh.venc_soat <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN 'SOAT/Seguro proximo a vencer'
    END AS alerta_vencimiento
FROM CONDUCTOR c
JOIN PAIS pa ON c.id_pais = pa.id_pais
JOIN ASIGNACION_VEHICULO av ON c.id_conductor = av.id_conductor AND av.es_activo = TRUE
JOIN VEHICULO veh ON av.id_vehiculo = veh.id_vehiculo
WHERE c.venc_licencia <= DATE_ADD(CURDATE(), INTERVAL 30 DAY)
   OR veh.venc_soat <= DATE_ADD(CURDATE(), INTERVAL 30 DAY);

-- 6. Tasa de cancelacion por tipo de servicio
SELECT 
    ts.nombre_servicio AS tipo_servicio,
    COUNT(v.id_viaje) AS total_solicitudes,
    SUM(CASE WHEN v.estado = 'CANCELADO' THEN 1 ELSE 0 END) AS total_cancelados,
    ROUND((SUM(CASE WHEN v.estado = 'CANCELADO' THEN 1 ELSE 0 END) * 100.0) / COUNT(v.id_viaje), 2) AS tasa_cancelacion_pct
FROM TIPO_SERVICIO ts
JOIN TARIFA_PAIS tp ON ts.id_tipo_servicio = tp.id_tipo_servicio
JOIN VIAJE v ON tp.id_tarifa = v.id_tarifa
GROUP BY ts.nombre_servicio
ORDER BY tasa_cancelacion_pct DESC;

-- 7. Pasajeros que nunca calificaron un viaje
SELECT 
    p.id_pasajero,
    CONCAT(p.nombres, ' ', p.apellidos) AS pasajero,
    p.email,
    pa.nombre_pais AS pais,
    COUNT(v.id_viaje) AS viajes_realizados
FROM PASAJERO p
JOIN PAIS pa ON p.id_pais = pa.id_pais
LEFT JOIN VIAJE v ON p.id_pasajero = v.id_pasajero
LEFT JOIN CALIFICACION cal ON v.id_viaje = cal.id_viaje
GROUP BY p.id_pasajero, pasajero, p.email, pa.nombre_pais
HAVING COUNT(cal.id_calificacion) = 0;

-- 8. Consulta de la vista (VIEW) con el resumen del viaje para el pasajero
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

SELECT * FROM vw_resumen_viajes ORDER BY id_viaje DESC;

-- PARTE B: PROCEDIMIENTO ALMACENADO (LIQUIDACION DE CONDUCTOR)
DROP PROCEDURE IF EXISTS sp_generar_liquidacion_conductor;

DELIMITER //
CREATE PROCEDURE sp_generar_liquidacion_conductor(
    IN p_id_conductor INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    DECLARE v_bruto DECIMAL(12,2) DEFAULT 0;
    DECLARE v_comision DECIMAL(12,2) DEFAULT 0;
    DECLARE v_neto DECIMAL(12,2) DEFAULT 0;
    DECLARE v_moneda CHAR(3);

    SELECT 
        COALESCE(SUM(pg.monto_bruto), 0),
        COALESCE(SUM(pg.comision_app), 0),
        pa.moneda
    INTO v_bruto, v_comision, v_moneda
    FROM CONDUCTOR c
    JOIN PAIS pa ON c.id_pais = pa.id_pais
    LEFT JOIN VIAJE v ON c.id_conductor = v.id_conductor 
        AND v.estado = 'FINALIZADO'
        AND DATE(v.fecha_solicitud) BETWEEN p_fecha_inicio AND p_fecha_fin
    LEFT JOIN PAGO pg ON v.id_viaje = pg.id_viaje
    WHERE c.id_conductor = p_id_conductor
    GROUP BY pa.moneda;

    SET v_neto = v_bruto - v_comision;

    IF v_bruto > 0 THEN
        INSERT INTO LIQUIDACION (id_conductor, periodo_inicio, periodo_fin, monto_bruto, comision_app, monto_neto, moneda, estado)
        VALUES (p_id_conductor, p_fecha_inicio, p_fecha_fin, v_bruto, v_comision, v_neto, v_moneda, 'PENDIENTE');
    END IF;

    SELECT * FROM LIQUIDACION WHERE id_conductor = p_id_conductor ORDER BY id_liquidacion DESC LIMIT 1;
END //
DELIMITER ;

CALL sp_generar_liquidacion_conductor(3, DATE_SUB(CURDATE(), INTERVAL 30 DAY), CURDATE());