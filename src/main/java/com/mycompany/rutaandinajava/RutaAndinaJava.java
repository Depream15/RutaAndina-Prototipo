package com.mycompany.rutaandinajava;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.util.Random;

public class RutaAndinaJava extends JFrame {

    // Modelos de tablas
    private DefaultTableModel modViajesPasajero, modViajesConductor, modLiquidaciones, modEmpresas, modFacturas;
    private JTable tblViajesPasajero, tblViajesConductor;

    // Combos y campos de formulario Pasajero
    private JComboBox<ItemCombo> cmbPasajero, cmbTarifa, cmbConductor;
    private JTextField txtOrigen, txtDestino, txtDistancia;
    private final Random random = new Random();

    public RutaAndinaJava() {
        setTitle("RutaAndina - Sistema de Movilidad (Peru & Colombia) | Java + MySQL");
        setSize(1080, 680);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(new BorderLayout());

        // Barra superior azul intermedio (entre claro y oscuro)
        JPanel headerPanel = new JPanel(new BorderLayout());
        headerPanel.setBackground(new Color(36, 113, 163));
        headerPanel.setBorder(BorderFactory.createEmptyBorder(14, 20, 14, 20));

        JLabel lblTitulo = new JLabel("RutaAndina | TECSUP x Politecnico Grancolombiano");
        lblTitulo.setForeground(Color.WHITE);
        lblTitulo.setFont(new Font("Segoe UI", Font.BOLD, 18));

        JLabel lblSubtitulo = new JLabel("Base de Datos MySQL: ruta_andina (15 entidades)");
        lblSubtitulo.setForeground(new Color(214, 234, 248));
        lblSubtitulo.setFont(new Font("Segoe UI", Font.PLAIN, 12));

        headerPanel.add(lblTitulo, BorderLayout.WEST);
        headerPanel.add(lblSubtitulo, BorderLayout.EAST);
        add(headerPanel, BorderLayout.NORTH);

        // Pestanas principales
        JTabbedPane tabs = new JTabbedPane();
        tabs.setFont(new Font("Segoe UI", Font.BOLD, 14));

        tabs.addTab("Modulo Pasajero", crearPanelPasajero());
        tabs.addTab("Modulo Conductor", crearPanelConductor());
        tabs.addTab("Modulo Empresa", crearPanelEmpresa());

        add(tabs, BorderLayout.CENTER);
        cargarCombos();
        refrescarTablas();
    }

    // Genera una distancia aleatoria entre 2.0 y 25.0 km
    private String generarDistanciaAleatoria() {
        double valor = 2.0 + (23.0 * random.nextDouble());
        return BigDecimal.valueOf(valor).setScale(1, RoundingMode.HALF_UP).toString();
    }

    // ==================== 1. PESTANA PASAJERO ====================
    private JPanel crearPanelPasajero() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Formulario izquierdo
        JPanel form = new JPanel(new GridLayout(14, 1, 5, 5));
        form.setPreferredSize(new Dimension(300, 0));
        form.setBorder(BorderFactory.createTitledBorder("Solicitar Nuevo Viaje"));

        cmbPasajero = new JComboBox<>();
        cmbTarifa = new JComboBox<>();
        cmbConductor = new JComboBox<>();
        txtOrigen = new JTextField("Miraflores / Calle 93");
        txtDestino = new JTextField("Aeropuerto Internacional");

        txtDistancia = new JTextField(generarDistanciaAleatoria());
        txtDistancia.setEditable(false);
        txtDistancia.setBackground(new Color(235, 245, 251));

        JButton btnPedir = new JButton("Pedir Viaje");
        btnPedir.setBackground(new Color(36, 113, 163));
        btnPedir.setForeground(Color.WHITE);
        btnPedir.setFont(new Font("Segoe UI", Font.BOLD, 13));
        btnPedir.addActionListener(e -> solicitarViaje());

        form.add(new JLabel("Pasajero:"));
        form.add(cmbPasajero);
        form.add(new JLabel("Tarifa / Servicio:"));
        form.add(cmbTarifa);
        form.add(new JLabel("Conductor Activo:"));
        form.add(cmbConductor);
        form.add(new JLabel("Origen:"));
        form.add(txtOrigen);
        form.add(new JLabel("Destino:"));
        form.add(txtDestino);
        form.add(new JLabel("Distancia Estimada Automatica (km):"));
        form.add(txtDistancia);
        form.add(new JLabel(""));
        form.add(btnPedir);

        // Tabla derecha
        modViajesPasajero = new DefaultTableModel(
            new String[]{"ID", "Pasajero", "Cuenta", "Ruta", "Servicio", "Monto", "Estado", "Estrellas"}, 0
        );
        tblViajesPasajero = new JTable(modViajesPasajero);

        JButton btnCalificar = new JButton("Calificar Viaje Seleccionado (5 Estrellas)");
        btnCalificar.addActionListener(e -> calificarViaje());

        JPanel panelTabla = new JPanel(new BorderLayout(5, 5));
        panelTabla.setBorder(BorderFactory.createTitledBorder("Historial de Viajes (Vista SQL)"));
        panelTabla.add(new JScrollPane(tblViajesPasajero), BorderLayout.CENTER);
        panelTabla.add(btnCalificar, BorderLayout.SOUTH);

        panel.add(form, BorderLayout.WEST);
        panel.add(panelTabla, BorderLayout.CENTER);
        return panel;
    }

    // ==================== 2. PESTANA CONDUCTOR ====================
    private JPanel crearPanelConductor() {
        JPanel panel = new JPanel(new GridLayout(2, 1, 10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Arriba: Control de viajes con columna "Estado Actual"
        JPanel top = new JPanel(new BorderLayout(5, 5));
        top.setBorder(BorderFactory.createTitledBorder("Control Operativo de Viajes"));

        modViajesConductor = new DefaultTableModel(
            new String[]{"ID", "Conductor", "Placa", "Pasajero", "Ruta", "Monto", "Estado Actual"}, 0
        );
        tblViajesConductor = new JTable(modViajesConductor);

        JPanel botonesEstado = new JPanel(new FlowLayout(FlowLayout.LEFT));
        JButton btnAceptar = new JButton("1. Aceptar Viaje");
        JButton btnIniciar = new JButton("2. Iniciar Ruta (EN_CURSO)");
        JButton btnFinalizar = new JButton("3. Finalizar y Generar Pago");
        btnFinalizar.setBackground(new Color(30, 132, 73));
        btnFinalizar.setForeground(Color.WHITE);

        btnAceptar.addActionListener(e -> cambiarEstadoViaje("ACEPTADO"));
        btnIniciar.addActionListener(e -> cambiarEstadoViaje("EN_CURSO"));
        btnFinalizar.addActionListener(e -> finalizarViaje());

        botonesEstado.add(btnAceptar);
        botonesEstado.add(btnIniciar);
        botonesEstado.add(btnFinalizar);

        top.add(new JScrollPane(tblViajesConductor), BorderLayout.CENTER);
        top.add(botonesEstado, BorderLayout.SOUTH);

        // Abajo: Tabla LIQUIDACION
        JPanel bottom = new JPanel(new BorderLayout());
        bottom.setBorder(BorderFactory.createTitledBorder("Liquidaciones Periodicas a Conductores (Tabla LIQUIDACION)"));
        modLiquidaciones = new DefaultTableModel(
            new String[]{"ID Liq.", "Conductor", "Inicio", "Fin", "Bruto", "Comision App", "Neto a Pagar", "Moneda", "Estado"}, 0
        );
        bottom.add(new JScrollPane(new JTable(modLiquidaciones)), BorderLayout.CENTER);

        panel.add(top);
        panel.add(bottom);
        return panel;
    }

    // ==================== 3. PESTANA EMPRESA ====================
    private JPanel crearPanelEmpresa() {
        JPanel panel = new JPanel(new GridLayout(2, 1, 10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Arriba: Resumen por empresa
        JPanel top = new JPanel(new BorderLayout());
        top.setBorder(BorderFactory.createTitledBorder("Consumo Corporativo Acumulado por Empresa"));
        modEmpresas = new DefaultTableModel(
            new String[]{"Empresa Cliente", "Moneda", "Viajes Finalizados", "Total Consumido"}, 0
        );
        top.add(new JScrollPane(new JTable(modEmpresas)), BorderLayout.CENTER);

        // Abajo: Tabla FACTURA
        JPanel bottom = new JPanel(new BorderLayout());
        bottom.setBorder(BorderFactory.createTitledBorder("Facturas Emitidas por Periodo (Tabla FACTURA)"));
        modFacturas = new DefaultTableModel(
            new String[]{"ID Factura", "Empresa", "Periodo Inicio", "Periodo Fin", "Emision", "Monto Total", "Moneda", "Estado"}, 0
        );
        bottom.add(new JScrollPane(new JTable(modFacturas)), BorderLayout.CENTER);

        panel.add(top);
        panel.add(bottom);
        return panel;
    }

    // ==================== OPERACIONES JDBC CON MYSQL ====================
    private void cargarCombos() {
        try (Connection con = Conexion.getConexion(); Statement st = con.createStatement()) {
            ResultSet rs = st.executeQuery(
                "SELECT p.id_pasajero, CONCAT(p.nombres, ' ', p.apellidos, ' (', pa.codigo_iso, ')') AS txt " +
                "FROM PASAJERO p JOIN PAIS pa ON p.id_pais = pa.id_pais"
            );
            while (rs.next()) cmbPasajero.addItem(new ItemCombo(rs.getInt("id_pasajero"), rs.getString("txt")));

            rs = st.executeQuery(
                "SELECT tp.id_tarifa, CONCAT(pa.nombre_pais, ' - ', ts.nombre_servicio, ' (', pa.moneda, ')') AS txt " +
                "FROM TARIFA_PAIS tp JOIN PAIS pa ON tp.id_pais = pa.id_pais JOIN TIPO_SERVICIO ts ON tp.id_tipo_servicio = ts.id_tipo_servicio"
            );
            while (rs.next()) cmbTarifa.addItem(new ItemCombo(rs.getInt("id_tarifa"), rs.getString("txt")));

            rs = st.executeQuery(
                "SELECT c.id_conductor, CONCAT(c.nombres, ' ', c.apellidos, ' [', v.placa, ']') AS txt " +
                "FROM CONDUCTOR c JOIN ASIGNACION_VEHICULO av ON c.id_conductor = av.id_conductor AND av.es_activo = TRUE " +
                "JOIN VEHICULO v ON av.id_vehiculo = v.id_vehiculo WHERE c.estado = 'ACTIVO'"
            );
            while (rs.next()) cmbConductor.addItem(new ItemCombo(rs.getInt("id_conductor"), rs.getString("txt")));

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Error cargando listas: " + ex.getMessage());
        }
    }

    private void refrescarTablas() {
        modViajesPasajero.setRowCount(0);
        modViajesConductor.setRowCount(0);
        modLiquidaciones.setRowCount(0);
        modEmpresas.setRowCount(0);
        modFacturas.setRowCount(0);

        try (Connection con = Conexion.getConexion(); Statement st = con.createStatement()) {
            // 1. Vista de viajes
                ResultSet rs = st.executeQuery("SELECT * FROM vw_resumen_viajes ORDER BY id_viaje DESC");
            while (rs.next()) {
                int id = rs.getInt("id_viaje");
                String ruta = rs.getString("origen") + " -> " + rs.getString("destino");
                String monto = rs.getBigDecimal("monto_total") + " " + rs.getString("moneda");
                String estado = rs.getString("estado");
                int pts = rs.getInt("puntaje_conductor");
                String estrellas = rs.wasNull() ? "-" : pts + " estrellas";

                modViajesPasajero.addRow(new Object[]{
                    id, rs.getString("pasajero"), rs.getString("perfil_cuenta"), ruta,
                    rs.getString("tipo_servicio"), monto, estado, estrellas
                });
                modViajesConductor.addRow(new Object[]{
                    id, rs.getString("conductor"), rs.getString("placa"), rs.getString("pasajero"),
                    ruta, monto, estado
                });
            }

            // 2. Liquidaciones
            rs = st.executeQuery(
                "SELECT l.*, CONCAT(c.nombres, ' ', c.apellidos) AS cond FROM LIQUIDACION l " +
                "JOIN CONDUCTOR c ON l.id_conductor = c.id_conductor ORDER BY l.id_liquidacion DESC"
            );
            while (rs.next()) {
                modLiquidaciones.addRow(new Object[]{
                    rs.getInt("id_liquidacion"), rs.getString("cond"), rs.getDate("periodo_inicio"),
                    rs.getDate("periodo_fin"), rs.getBigDecimal("monto_bruto"), rs.getBigDecimal("comision_app"),
                    rs.getBigDecimal("monto_neto"), rs.getString("moneda"), rs.getString("estado")
                });
            }

            // 3. Reporte empresas
            rs = st.executeQuery(
                "SELECT e.razon_social, pa.moneda, COUNT(v.id_viaje) AS cant, COALESCE(SUM(v.monto_total), 0) AS tot " +
                "FROM EMPRESA e JOIN PAIS pa ON e.id_pais = pa.id_pais " +
                "LEFT JOIN PASAJERO p ON e.id_empresa = p.id_empresa " +
                "LEFT JOIN VIAJE v ON p.id_pasajero = v.id_pasajero AND v.estado = 'FINALIZADO' " +
                "WHERE e.tipo_empresa = 'CLIENTE' GROUP BY e.razon_social, pa.moneda"
            );
            while (rs.next()) {
                modEmpresas.addRow(new Object[]{
                    rs.getString("razon_social"), rs.getString("moneda"), rs.getInt("cant"), rs.getBigDecimal("tot")
                });
            }

            // 4. Facturas
            rs = st.executeQuery(
                "SELECT f.*, e.razon_social FROM FACTURA f JOIN EMPRESA e ON f.id_empresa = e.id_empresa ORDER BY f.id_factura DESC"
            );
            while (rs.next()) {
                modFacturas.addRow(new Object[]{
                    rs.getInt("id_factura"), rs.getString("razon_social"), rs.getDate("periodo_inicio"),
                    rs.getDate("periodo_fin"), rs.getDate("fecha_emision"), rs.getBigDecimal("monto_total"),
                    rs.getString("moneda"), rs.getString("estado")
                });
            }

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Error leyendo BD: " + ex.getMessage());
        }
    }

    private void solicitarViaje() {
        try (Connection con = Conexion.getConexion()) {
            ItemCombo pas = (ItemCombo) cmbPasajero.getSelectedItem();
            ItemCombo tar = (ItemCombo) cmbTarifa.getSelectedItem();
            ItemCombo cond = (ItemCombo) cmbConductor.getSelectedItem();
            BigDecimal dist = new BigDecimal(txtDistancia.getText().trim());

            PreparedStatement psTar = con.prepareStatement("SELECT tarifa_base, costo_km FROM TARIFA_PAIS WHERE id_tarifa = ?");
            psTar.setInt(1, tar.id);
            ResultSet rs = psTar.executeQuery();
            rs.next();
            BigDecimal total = rs.getBigDecimal("tarifa_base").add(rs.getBigDecimal("costo_km").multiply(dist));

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO VIAJE (id_pasajero, id_conductor, id_tarifa, origen, destino, distancia_km, monto_total, estado) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 'SOLICITADO')"
            );
            ps.setInt(1, pas.id);
            ps.setInt(2, cond.id);
            ps.setInt(3, tar.id);
            ps.setString(4, txtOrigen.getText().trim());
            ps.setString(5, txtDestino.getText().trim());
            ps.setBigDecimal(6, dist);
            ps.setBigDecimal(7, total);
            ps.executeUpdate();

            JOptionPane.showMessageDialog(this, "Viaje registrado en MySQL con exito (" + dist + " km).");
            txtDistancia.setText(generarDistanciaAleatoria());
            refrescarTablas();
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error al solicitar viaje: " + ex.getMessage());
        }
    }

    private void cambiarEstadoViaje(String nuevoEstado) {
        int fila = tblViajesConductor.getSelectedRow();
        if (fila == -1) {
            JOptionPane.showMessageDialog(this, "Selecciona primero un viaje en la tabla de arriba.");
            return;
        }
        int idViaje = (int) modViajesConductor.getValueAt(fila, 0);
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement("UPDATE VIAJE SET estado = ? WHERE id_viaje = ?")) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idViaje);
            ps.executeUpdate();
            refrescarTablas();
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Error actualizando estado: " + ex.getMessage());
        }
    }

    private void finalizarViaje() {
        int fila = tblViajesConductor.getSelectedRow();
        if (fila == -1) {
            JOptionPane.showMessageDialog(this, "Selecciona un viaje en la tabla para finalizarlo.");
            return;
        }
        int idViaje = (int) modViajesConductor.getValueAt(fila, 0);
        try (Connection con = Conexion.getConexion()) {
            PreparedStatement psUpd = con.prepareStatement("UPDATE VIAJE SET estado = 'FINALIZADO' WHERE id_viaje = ?");
            psUpd.setInt(1, idViaje);
            psUpd.executeUpdate();

            PreparedStatement psInfo = con.prepareStatement(
                "SELECT v.monto_total, pa.moneda, pa.porcentaje_comision, p.id_empresa, mp.id_metodo_pago " +
                "FROM VIAJE v JOIN PASAJERO p ON v.id_pasajero = p.id_pasajero " +
                "JOIN TARIFA_PAIS tp ON v.id_tarifa = tp.id_tarifa JOIN PAIS pa ON tp.id_pais = pa.id_pais " +
                "JOIN METODO_PAGO mp ON p.id_pasajero = mp.id_pasajero AND mp.es_predeterminado = TRUE " +
                "WHERE v.id_viaje = ? LIMIT 1"
            );
            psInfo.setInt(1, idViaje);
            ResultSet rs = psInfo.executeQuery();
            if (rs.next()) {
                BigDecimal bruto = rs.getBigDecimal("monto_total");
                BigDecimal pct = rs.getBigDecimal("porcentaje_comision").divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP);
                BigDecimal comision = bruto.multiply(pct).setScale(2, RoundingMode.HALF_UP);
                int idEmpresa = rs.getInt("id_empresa");
                String estPago = rs.wasNull() ? "COMPLETADO" : "FACTURADO_EMPRESA";

                PreparedStatement psPago = con.prepareStatement(
                    "INSERT IGNORE INTO PAGO (id_viaje, id_metodo_pago, monto_bruto, comision_app, moneda, estado_pago) " +
                    "VALUES (?, ?, ?, ?, ?, ?)"
                );
                psPago.setInt(1, idViaje);
                psPago.setInt(2, rs.getInt("id_metodo_pago"));
                psPago.setBigDecimal(3, bruto);
                psPago.setBigDecimal(4, comision);
                psPago.setString(5, rs.getString("moneda"));
                psPago.setString(6, estPago);
                psPago.executeUpdate();
            }
            JOptionPane.showMessageDialog(this, "Viaje #" + idViaje + " finalizado y pago generado en MySQL.");
            refrescarTablas();
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Error finalizando viaje: " + ex.getMessage());
        }
    }

    private void calificarViaje() {
        int fila = tblViajesPasajero.getSelectedRow();
        if (fila == -1) {
            JOptionPane.showMessageDialog(this, "Selecciona un viaje finalizado de la tabla.");
            return;
        }
        int idViaje = (int) modViajesPasajero.getValueAt(fila, 0);
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT IGNORE INTO CALIFICACION (id_viaje, puntaje_conductor, comentario_conductor) VALUES (?, 5, 'Excelente servicio')"
             )) {
            ps.setInt(1, idViaje);
            ps.executeUpdate();
            JOptionPane.showMessageDialog(this, "Calificacion registrada con exito.");
            refrescarTablas();
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Error al calificar: " + ex.getMessage());
        }
    }

    private static class ItemCombo {
        int id;
        String texto;
        ItemCombo(int id, String texto) { this.id = id; this.texto = texto; }
        @Override public String toString() { return texto; }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new RutaAndinaJava().setVisible(true));
    }
}