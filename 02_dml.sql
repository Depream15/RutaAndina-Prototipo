-- Paso 2: Datos de prueba
USE ruta_andina;

-- 1. PAISES (Peru y Colombia)
INSERT INTO PAIS (nombre_pais, codigo_iso, moneda, porcentaje_comision) VALUES
('Peru', 'PE', 'PEN', 15.00),
('Colombia', 'CO', 'COP', 18.00);

-- 2. TIPOS DE SERVICIO
INSERT INTO TIPO_SERVICIO (nombre_servicio, descripcion, capacidad) VALUES
('Economico', 'Vehiculo compacto estandar urbano', 4),
('Confort', 'Sedan amplio con aire acondicionado', 4),
('XL', 'Camioneta SUV hasta 6 pasajeros', 6);

-- 3. TARIFAS POR PAIS Y SERVICIO
INSERT INTO TARIFA_PAIS (id_pais, id_tipo_servicio, tarifa_base, costo_km, costo_min) VALUES
(1, 1, 5.00, 1.50, 0.30),
(1, 2, 8.00, 2.20, 0.45),
(1, 3, 12.00, 3.00, 0.60),
(2, 1, 4500.00, 1400.00, 250.00),
(2, 2, 7000.00, 2000.00, 350.00),
(2, 3, 11000.00, 2800.00, 500.00);

-- 4. EMPRESAS (5 empresas: 1 Operadora, 3 Clientes Corporativos, 1 Flota)
INSERT INTO EMPRESA (id_pais, razon_social, ruc_nit, tipo_empresa) VALUES
(1, 'RutaAndina Operaciones SAC', '20601234561', 'OPERADORA'),
(1, 'Minera Andina del Sur SAC', '20519876542', 'CLIENTE'),
(2, 'Bancolombia Servicios Tech SAS', '900456789-1', 'CLIENTE'),
(2, 'Grupo Nutresa Corporativo SAS', '890900123-4', 'CLIENTE'),
(1, 'Flota Express Lima SAC', '20554433221', 'FLOTA');

-- 5. PASAJEROS (20 pasajeros: 10 en Peru, 10 en Colombia)
INSERT INTO PASAJERO (id_pais, id_empresa, nombres, apellidos, email, telefono) VALUES
(1, 2, 'Carlos', 'Mendoza Quispe', 'cmendoza@mineraandina.pe', '+51987654321'),
(1, 2, 'Lucia', 'Fernandez Rojas', 'lfernandez@mineraandina.pe', '+51987654322'),
(1, NULL, 'Diego', 'Huaman Paredes', 'diego.huaman@gmail.com', '+51987654323'),
(1, NULL, 'Valeria', 'Torres Salazar', 'valeria.torres@outlook.com', '+51987654324'),
(1, 2, 'Jorge', 'Castillo Vargas', 'jcastillo@mineraandina.pe', '+51987654325'),
(1, NULL, 'Camila', 'Rios Delgado', 'camila.rios@gmail.com', '+51987654326'),
(1, NULL, 'Renato', 'Chavez Silva', 'renato.chavez@gmail.com', '+51987654327'),
(1, NULL, 'Mariana', 'Peralta Cruz', 'mariana.peralta@hotmail.com', '+51987654328'),
(1, 2, 'Alonso', 'Guzman Soto', 'aguzman@mineraandina.pe', '+51987654329'),
(1, NULL, 'Sofia', 'Vega Morales', 'sofia.vega@gmail.com', '+51987654330'),
(2, 3, 'Andres', 'Gomez Restrepo', 'agomez@bancolombiatech.co', '+573001234501'),
(2, 3, 'Natalia', 'Arango Velez', 'narango@bancolombiatech.co', '+573001234502'),
(2, 4, 'Santiago', 'Ospina Cardona', 'sospina@nutresacorp.co', '+573001234503'),
(2, 4, 'Paula', 'Jimenez Ruiz', 'pjimenez@nutresacorp.co', '+573001234504'),
(2, NULL, 'Felipe', 'Cardenas Mora', 'felipe.cardenas@gmail.com', '+573001234505'),
(2, NULL, 'Laura', 'Mejias Duarte', 'laura.mejias@gmail.com', '+573001234506'),
(2, 3, 'Sebastian', 'Pineda Ortiz', 'spineda@bancolombiatech.co', '+573001234507'),
(2, NULL, 'Daniela', 'Lozano Castro', 'daniela.lozano@yahoo.com', '+573001234508'),
(2, NULL, 'Mateo', 'Rincon Herrera', 'mateo.rincon@gmail.com', '+573001234509'),
(2, 4, 'Carolina', 'Suarez Arias', 'csuarez@nutresacorp.co', '+573001234510');

-- 6. DIRECCIONES FAVORITAS
INSERT INTO DIRECCION_FAVORITA (id_pasajero, alias, direccion_texto, latitud, longitud) VALUES
(1, 'Oficina', 'Av. El Derby 254, Santiago de Surco, Lima', -12.098700, -76.975400),
(3, 'Casa', 'Calle Los Pinos 410, Miraflores, Lima', -12.119100, -77.029000),
(11, 'Oficina', 'Calle 93 # 13-45, Chico, Bogota', 4.676800, -74.048300),
(15, 'Universidad', 'Carrera 7 # 40-62, Chapinero, Bogota', 4.628500, -74.064700);

-- 7. METODOS DE PAGO PREDETERMINADOS (1 por cada pasajero)
INSERT INTO METODO_PAGO (id_pasajero, tipo_pago, detalle_enmascarado, es_predeterminado) VALUES
(1, 'Tarjeta', 'VISA Corp **** 4511', TRUE),
(2, 'Tarjeta', 'VISA Corp **** 4512', TRUE),
(3, 'Billetera', 'Yape **** 4323', TRUE),
(4, 'Tarjeta', 'MC **** 8821', TRUE),
(5, 'Tarjeta', 'VISA Corp **** 4515', TRUE),
(6, 'Efectivo', 'Efectivo PEN', TRUE),
(7, 'Billetera', 'Plin **** 4327', TRUE),
(8, 'Tarjeta', 'VISA **** 1190', TRUE),
(9, 'Tarjeta', 'VISA Corp **** 4519', TRUE),
(10, 'Efectivo', 'Efectivo PEN', TRUE),
(11, 'Tarjeta', 'VISA Corp **** 9001', TRUE),
(12, 'Tarjeta', 'VISA Corp **** 9002', TRUE),
(13, 'Tarjeta', 'MC Corp **** 7703', TRUE),
(14, 'Tarjeta', 'MC Corp **** 7704', TRUE),
(15, 'Billetera', 'Nequi **** 4505', TRUE),
(16, 'Tarjeta', 'VISA **** 3321', TRUE),
(17, 'Tarjeta', 'VISA Corp **** 9007', TRUE),
(18, 'Efectivo', 'Efectivo COP', TRUE),
(19, 'Billetera', 'Daviplata **** 4509', TRUE),
(20, 'Tarjeta', 'MC Corp **** 7710', TRUE);

-- 8. CONDUCTORES (10 conductores: 5 en Peru, 5 en Colombia)
INSERT INTO CONDUCTOR (id_pais, id_empresa_flota, nombres, apellidos, num_licencia, venc_licencia, estado) VALUES
(1, 5, 'Marco', 'Salinas Quispe', 'Q44556611', '2028-06-15', 'ACTIVO'),
(1, 5, 'Pedro', 'Caceres Huerta', 'Q44556612', DATE_ADD(CURDATE(), INTERVAL 18 DAY), 'ACTIVO'),
(1, NULL, 'Luis', 'Benitez Navarro', 'Q44556613', '2027-11-20', 'ACTIVO'),
(1, NULL, 'Hector', 'Paredes Luna', 'Q44556614', '2028-03-10', 'ACTIVO'),
(1, 5, 'Raul', 'Espinoza Tapia', 'Q44556615', '2027-09-01', 'ACTIVO'),
(2, NULL, 'Jhon', 'Bermudez Cano', 'CC10203041', '2028-08-22', 'ACTIVO'),
(2, NULL, 'Camilo', 'Vargas Parra', 'CC10203042', DATE_ADD(CURDATE(), INTERVAL 12 DAY), 'ACTIVO'),
(2, NULL, 'Oscar', 'Rojas Giraldo', 'CC10203043', '2027-12-14', 'ACTIVO'),
(2, NULL, 'Mauricio', 'Salazar Marin', 'CC10203044', '2028-04-30', 'ACTIVO'),
(2, NULL, 'Wilson', 'Patino Acosta', 'CC10203045', '2027-10-05', 'ACTIVO');

-- 9. VEHICULOS (10 vehiculos: 5 en Peru, 5 en Colombia)
INSERT INTO VEHICULO (id_empresa_flota, placa, marca, modelo, anio, venc_soat) VALUES
(5, 'ABC-101', 'Toyota', 'Yaris', 2022, '2027-07-20'),
(5, 'ABC-102', 'Hyundai', 'Accent', 2021, '2027-05-15'),
(NULL, 'BXY-203', 'Kia', 'Cerato', 2023, DATE_ADD(CURDATE(), INTERVAL 20 DAY)),
(NULL, 'CZA-304', 'Nissan', 'Sentra', 2022, '2027-09-12'),
(5, 'DLM-405', 'Toyota', 'Rav4', 2023, '2027-11-30'),
(NULL, 'KLM-501', 'Chevrolet', 'Onix', 2022, '2027-06-18'),
(NULL, 'NOP-502', 'Renault', 'Logan', 2021, '2027-08-25'),
(NULL, 'QRS-503', 'Mazda', 'Mazda 3', 2023, DATE_ADD(CURDATE(), INTERVAL 10 DAY)),
(NULL, 'TUV-504', 'Kia', 'Sportage', 2022, '2027-10-19'),
(NULL, 'WXY-505', 'Hyundai', 'Tucson', 2023, '2027-12-01');

-- 10. ASIGNACION DE VEHICULOS ACTIVOS
INSERT INTO ASIGNACION_VEHICULO (id_conductor, id_vehiculo, fecha_inicio, fecha_fin, es_activo) VALUES
(1, 1, '2026-01-10', NULL, TRUE),
(2, 2, '2026-01-15', NULL, TRUE),
(3, 3, '2026-02-01', NULL, TRUE),
(4, 4, '2026-02-10', NULL, TRUE),
(5, 5, '2026-03-01', NULL, TRUE),
(6, 6, '2026-01-12', NULL, TRUE),
(7, 7, '2026-01-20', NULL, TRUE),
(8, 8, '2026-02-05', NULL, TRUE),
(9, 9, '2026-02-18', NULL, TRUE),
(10, 10, '2026-03-05', NULL, TRUE);

-- 11. VIAJES (55 viajes: 28 en Peru y 27 en Colombia)
INSERT INTO VIAJE (id_pasajero, id_conductor, id_tarifa, origen, destino, distancia_km, monto_total, estado, fecha_solicitud) VALUES
(1, 1, 2, 'Av. El Derby 254, Surco', 'Aeropuerto Jorge Chavez', 18.50, 48.70, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 22 DAY)),
(2, 1, 2, 'San Isidro Centro Financiero', 'Miraflores Parque Kennedy', 5.20, 19.44, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 20 DAY)),
(3, 1, 1, 'Barranco Plaza', 'Universidad de Lima', 9.80, 19.70, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 18 DAY)),
(4, 1, 1, 'Jockey Plaza', 'Larcomar Miraflores', 7.40, 16.10, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 15 DAY)),
(5, 1, 2, 'Av. Javier Prado Este', 'San Borja Norte', 4.50, 17.90, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 10 DAY)),
(6, 1, 1, 'Magdalena del Mar', 'Centro Civico Lima', 6.10, 14.15, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(7, 2, 1, 'Jesus Maria', 'Lince Av. Arequipa', 3.80, 10.70, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 21 DAY)),
(8, 2, 2, 'Miraflores Malecon', 'Aeropuerto Jorge Chavez', 17.00, 45.40, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 19 DAY)),
(9, 2, 2, 'Surco Caminos del Inca', 'San Isidro Camino Real', 6.50, 22.30, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 16 DAY)),
(10, 2, 1, 'Pueblo Libre', 'Plaza San Miguel', 3.20, 9.80, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 12 DAY)),
(1, 2, 2, 'San Isidro', 'La Molina Universidad', 11.20, 32.64, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 8 DAY)),
(2, 2, 1, 'Miraflores', 'Barranco', 3.50, 10.25, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(3, 3, 2, 'Chorrillos', 'Miraflores', 8.00, 25.60, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 24 DAY)),
(4, 3, 1, 'San Borja', 'Surquillo', 4.00, 11.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 17 DAY)),
(5, 3, 2, 'Aeropuerto Jorge Chavez', 'Hotel Westin San Isidro', 16.40, 44.08, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 14 DAY)),
(6, 3, 1, 'La Victoria', 'Santa Anita', 7.50, 16.25, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 11 DAY)),
(7, 3, 2, 'Miraflores', 'San Isidro', 4.10, 17.02, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 7 DAY)),
(8, 3, 1, 'Los Olivos', 'Plaza Norte', 3.00, 9.50, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(9, 4, 2, 'Surco', 'Aeropuerto Jorge Chavez', 19.00, 49.80, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 23 DAY)),
(10, 4, 1, 'Brena', 'Centro de Lima', 3.40, 10.10, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 15 DAY)),
(1, 4, 2, 'San Isidro', 'Chacarilla Surco', 5.80, 20.76, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 9 DAY)),
(2, 4, 1, 'Miraflores', 'Magdalena', 6.30, 14.45, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(3, 4, 1, 'Surco', 'Barranco', 5.00, 12.50, 'CANCELADO', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(5, 5, 3, 'Aeropuerto Jorge Chavez', 'Minera Andina Surco', 20.00, 72.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 19 DAY)),
(9, 5, 3, 'San Isidro', 'Club Regatas Chorrillos', 12.50, 49.50, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 13 DAY)),
(4, 5, 3, 'Miraflores', 'Asia Boulevard', 85.00, 267.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 6 DAY)),
(6, 5, 3, 'La Molina', 'Aeropuerto Jorge Chavez', 24.00, 84.00, 'CANCELADO', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(1, 5, 3, 'Av. El Derby 254, Surco', 'Aeropuerto Jorge Chavez', 18.50, 67.50, 'SOLICITADO', NOW()),
(11, 6, 5, 'Calle 93 Chico', 'Aeropuerto El Dorado', 14.20, 35400.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 25 DAY)),
(12, 6, 5, 'Parque de la 93', 'Centro Internacional', 8.50, 24000.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 21 DAY)),
(13, 6, 4, 'Usaquen', 'Andino Zona T', 4.60, 10940.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 18 DAY)),
(14, 6, 5, 'Salitre Plaza', 'Chapinero Alto', 7.80, 22600.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 14 DAY)),
(15, 6, 4, 'Teusaquillo', 'Universidad Nacional', 3.20, 8980.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 9 DAY)),
(16, 6, 5, 'Cedritos Calle 140', 'Calle 100 Autopista', 5.40, 17800.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(17, 7, 5, 'Aeropuerto El Dorado', 'Hotel W Bogota Santa Barbara', 16.00, 39000.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 24 DAY)),
(18, 7, 4, 'Suba', 'Titan Plaza', 5.10, 11640.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 20 DAY)),
(19, 7, 4, 'Kennedy', 'Plaza de las Americas', 3.90, 9960.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 16 DAY)),
(20, 7, 5, 'Zona G Bogota', 'Aeropuerto El Dorado', 13.50, 34000.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 11 DAY)),
(11, 7, 5, 'Calle 72 Financiera', 'Usaquen Plaza', 6.80, 20600.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 6 DAY)),
(12, 7, 4, 'Modelia', 'Corferias', 6.00, 12900.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(13, 8, 5, 'Nutresa Calle 80', 'Aeropuerto El Dorado', 11.00, 29000.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 23 DAY)),
(14, 8, 5, 'Chia Centro', 'Calle 127 Bogota', 18.00, 43000.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 17 DAY)),
(15, 8, 4, 'La Candelaria', 'Monserrate Teleferico', 2.80, 8420.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 13 DAY)),
(16, 8, 4, 'Galerias', 'Unicentro Bogota', 9.20, 17380.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 8 DAY)),
(17, 8, 5, 'Bancolombia Calle 93', 'Salitre Empresarial', 9.50, 26000.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(18, 8, 4, 'Fontibon', 'Terminal Salitre', 5.50, 12200.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(19, 9, 6, 'Aeropuerto El Dorado', 'Rosales Calle 76', 15.00, 53000.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 19 DAY)),
(20, 9, 6, 'Nutresa Bogota', 'Parque Jaime Duque', 32.00, 100600.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 14 DAY)),
(11, 9, 6, 'Chico Norte', 'Aeropuerto El Dorado', 14.50, 51600.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 7 DAY)),
(13, 9, 6, 'Santa Barbara', 'Multiparque Autopista', 10.20, 39560.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(15, 9, 4, 'Chapinero', 'Centro Mayor', 8.00, 15700.00, 'CANCELADO', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(14, 10, 6, 'Aeropuerto El Dorado', 'Calle 100 Bogota', 13.80, 49640.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 12 DAY)),
(17, 10, 5, 'Calle 93', 'Hayuelos', 12.40, 31800.00, 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(18, 10, 4, 'Engativa', 'Portal 80', 3.50, 9400.00, 'CANCELADO', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(11, 10, 5, 'Calle 93 # 13-45, Bogota', 'Aeropuerto El Dorado', 14.20, 35400.00, 'SOLICITADO', NOW());

-- 12. PAGOS (Generados para todos los viajes FINALIZADOS)
INSERT INTO PAGO (id_viaje, id_metodo_pago, monto_bruto, comision_app, moneda, estado_pago, fecha_pago)
SELECT 
    v.id_viaje,
    mp.id_metodo_pago,
    v.monto_total,
    ROUND(v.monto_total * (pa.porcentaje_comision / 100), 2),
    pa.moneda,
    IF(p.id_empresa IS NULL, 'COMPLETADO', 'FACTURADO_EMPRESA'),
    v.fecha_solicitud
FROM VIAJE v
JOIN PASAJERO p ON v.id_pasajero = p.id_pasajero
JOIN METODO_PAGO mp ON p.id_pasajero = mp.id_pasajero AND mp.es_predeterminado = TRUE
JOIN TARIFA_PAIS tp ON v.id_tarifa = tp.id_tarifa
JOIN PAIS pa ON tp.id_pais = pa.id_pais
WHERE v.estado = 'FINALIZADO';

-- 13. CALIFICACIONES (Algunos pasajeros se dejan sin calificar para la Consulta 7)
INSERT INTO CALIFICACION (id_viaje, puntaje_conductor, comentario_conductor, puntaje_pasajero, comentario_pasajero)
SELECT 
    v.id_viaje,
    CASE 
        WHEN v.id_conductor IN (1, 6, 8) THEN 5
        WHEN v.id_conductor IN (2, 7, 9) THEN 4
        ELSE 5
    END,
    'Buen servicio y puntualidad',
    5,
    'Pasajero amable'
FROM VIAJE v
WHERE v.estado = 'FINALIZADO' AND v.id_pasajero NOT IN (6, 10, 16, 18);

-- 14. FACTURAS (Facturacion periodica a las 3 empresas cliente)
INSERT INTO FACTURA (id_empresa, periodo_inicio, periodo_fin, fecha_emision, monto_total, moneda, estado) VALUES
(2, '2026-10-01', '2026-10-31', '2026-11-02', 315.40, 'PEN', 'PAGADA'),
(3, '2026-10-01', '2026-10-31', '2026-11-02', 208400.00, 'COP', 'PAGADA'),
(4, '2026-10-01', '2026-10-31', '2026-11-02', 245700.00, 'COP', 'EMITIDA');

-- 15. LIQUIDACIONES (Pagos netos periodicos a conductores)
INSERT INTO LIQUIDACION (id_conductor, periodo_inicio, periodo_fin, monto_bruto, comision_app, monto_neto, moneda, estado) VALUES
(1, '2026-11-01', '2026-11-15', 135.99, 20.40, 115.59, 'PEN', 'PAGADA'),
(2, '2026-11-01', '2026-11-15', 131.09, 19.66, 111.43, 'PEN', 'PAGADA'),
(6, '2026-11-01', '2026-11-15', 119720.00, 21549.60, 98170.40, 'COP', 'PAGADA'),
(7, '2026-11-01', '2026-11-15', 128100.00, 23058.00, 105042.00, 'COP', 'PENDIENTE');