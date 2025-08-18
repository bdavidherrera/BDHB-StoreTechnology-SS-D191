import { Router } from "express";
import { getHistorialCompras } from "../controllers/historialClientes.controllers.js";

const router = Router();

// Ruta protegida solo para clientes
router.get("/historial", getHistorialCompras);

export default router;
