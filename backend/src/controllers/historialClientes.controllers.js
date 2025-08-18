import getConnection from "../db/database.js";

export const getHistorialCompras = async (req, res) => {
  try {
   
    const idUsuario = req.session.idUsuario;
    const rol = req.session.rol;

    if (!idUsuario || rol !== "cliente") {
      return res.status(403).json({ 
        success: false, 
        message: "Acceso denegado. Debes iniciar sesión como cliente." 
      });
    }

    const connection = await getConnection();

    // Consulta pedidos filtrados por usuario
    const result = await connection.query(
      `SELECT p.idPedido, p.estado, p.subtotal, p.descuentos_totales, 
              p.impuestos_totales, p.total, p.fechaCreacion, 
              p.nombresProductos
       FROM pedidos p
       WHERE p.idUsuario = ? 
       ORDER BY p.fechaCreacion DESC`,
      [idUsuario]
    );

    res.json({
      success: true,
      historial: result
    });

  } catch (error) {
    console.error("Error al obtener historial de compras:", error);
    res.status(500).json({
      success: false,
      message: "Error al obtener el historial de compras"
    });
  }
};

export const methodHTPP = {
    getHistorialCompras
}
