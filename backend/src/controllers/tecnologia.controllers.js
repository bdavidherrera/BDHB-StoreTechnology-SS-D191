import getConnection from "../db/database.js"


const getTecnologiaProducto = async (req, res)=>{
    try {
        const connection = await getConnection();
        console.log("Conexión obtenida [GET /producto]");
        const result= await connection.query("SELECT * FROM producto WHERE activo = '1' ")
        res.json(result) 
    } catch (error) {
        console.error("ERROR 500");
    }
    
};

const postTecnologiaProducto = async (req, res) => {
    try {
        const { nombreProducto, imagen, valor, cantidad, informacion } = req.body;

        const producto = {
            nombreProducto, 
            imagen, 
            valor, 
            cantidad, 
            informacion
        };
        const connection =  await getConnection();
        console.log("Conexión obtenida [POST /Producto]");
        const result = await connection.query("INSERT INTO producto SET ?", producto);
        res.json(result);

    } catch (error) {
        console.error("ERROR 500:", error);
        res.status(500).json({ message: "Error al crear el producto" });
    }
};

const putTecnologiaProducto = async (req, res)=> {
    try {
        const { idProducto, nombreProducto, imagen, valor, cantidad, informacion, porcentaje_impuesto } = req.body;

        const productos = {
            idProducto ,nombreProducto, imagen, valor, cantidad, informacion, porcentaje_impuesto
        };

        const connection = await getConnection();
        console.log("Conexión obtenida [PUT /Productos/:id]");
        const result = await connection.query("UPDATE producto SET ? WHERE idProducto = ? AND activo = '1'", [productos, idProducto]);
        res.json(result);
    } catch (error) {
        console.error("ERROR 500:", error);
        res.status(500).json({ message: "error al actualizar el productos", error: error.message });
    }
};

const deleteTecnologiaProducto = async (req, res) => {
    try {
        const { idProducto } = req.params;

        const connection = await getConnection();
        console.log("Conexión obtenida [DELETE /producto/:id]");
        const result = await connection.query("UPDATE producto SET activo = '0' WHERE idProducto = ?", [idProducto]);
        res.json(result);
    } catch (error) {
        console.error("ERROR 500:", error);
        res.status(500).json({ message: "error al eliminar el producto", error: error.message });
    }
}

export const methodHTPP = {
    getTecnologiaProducto, 
    postTecnologiaProducto,
    putTecnologiaProducto,
    deleteTecnologiaProducto
}

