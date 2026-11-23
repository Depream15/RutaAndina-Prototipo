# RutaAndina - Sistema de Gestión de Transporte (Perú y Colombia)

Prototipo funcional desarrollado en **Java (Swing + JDBC)** conectado a una base de datos relacional en **MySQL**, diseñado para gestionar pasajeros, conductores, vehículos, tarifas multipaís (`PEN` y `COP`), viajes, pagos, calificaciones, facturación corporativa y liquidaciones.

Proyecto desarrollado en colaboración internacional entre **TECSUP (Perú)** y **Politécnico Grancolombiano (Colombia)**.

---

## Requisitos Previos

* **Java Development Kit (JDK):** Versión 17 o superior.
* **IDE recomendado:** Apache NetBeans (con soporte Maven).
* **Motor de Base de Datos:** MySQL Server 8.0+ y MySQL Workbench.

---

## Instalación y Configuración

### 1. Configurar la Base de Datos en MySQL
1. Abre **MySQL Workbench** y conéctate a tu servidor local (`localhost:3306`).
2. Ejecuta los scripts SQL en el siguiente orden exacto:
   * `01_ddl.sql`: Crea la base de datos `ruta_andina`, las 15 entidades normalizadas en 3FN y la vista `vw_resumen_viajes`.
   * `02_dml.sql`: Carga los datos de prueba (20 pasajeros, 10 conductores, 10 vehículos, 5 empresas y 55 viajes distribuidos entre Lima y Bogotá).
   * `03_consultas.sql`: Contiene las 8 consultas de negocio y el procedimiento almacenado `sp_generar_liquidacion_conductor`.

### 2. Configurar y Ejecutar el Prototipo en Java
1. Descarga o clona este repositorio:
   ```bash
   git clone [https://github.com/Depream15/RutaAndina-Prototipo.git](https://github.com/Depream15/RutaAndina-Prototipo.git)
   ```
2. Abre el proyecto **`RutaAndinaJava`** en **Apache NetBeans**.
3. Abre la clase `Conexion.java` y verifica las credenciales de tu servidor MySQL local:
   ```java
   private static final String URL = "jdbc:mysql://localhost:3306/ruta_andina?useSSL=false&serverTimezone=UTC";
   private static final String USER = "root";
   private static final String PASSWORD = "tu_password_mysql";
   ```
4. Haz clic derecho sobre el proyecto y selecciona **Build with Dependencies** para descargar el conector `mysql-connector-j`.
5. Ejecuta el proyecto presionando **`F6`** (o el botón **Run Project**).

---

## Módulos del Prototipo

* **Módulo Pasajero:** Solicitud de nuevos viajes con cálculo automático de tarifa según país (`PEN`/`COP`) y servicio (`Económico`, `Confort`, `XL`), consulta de historial y calificación de viajes finalizados.
* **Módulo Conductor:** Visualización de solicitudes, actualización del flujo de estados (`SOLICITADO` → `ACEPTADO` → `EN_CURSO` → `FINALIZADO`) con registro automático de pago y comisión, y consulta de liquidaciones.
* **Módulo Empresa:** Reporte de consumo corporativo por empresa cliente y consulta de facturación periódica.
