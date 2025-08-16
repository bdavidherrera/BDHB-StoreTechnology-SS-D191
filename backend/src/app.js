/*importamos al framework express */

import express, { request } from "express";
import cors from "cors";
import usuariosRoutes from "./routers/usuarios.routes.js"
import usuariosLoginRoutes from "./routers/usuariosLogin.routes.js"

/*Asignamos a app toda funcionalidad para mi server web */
const app = express();


/*setear un puerto ami web server */
app.set("port",8000);

/* Midelware*/
app.use(express.json());
app.use(express.urlencoded({extended:true}));


/*routers */
app.use(cors()); 

/*usuarios*/

app.use("/Registrar", usuariosRoutes); //Registrar Usuarios clientes


app.use("/Login", usuariosLoginRoutes); //Verificar datos del login

app.use("/api/usuarios", usuariosRoutes); //Mostrar Usuarios clientes, actualizar y eliminar usuarios (desde admin)




app.get("/",(req,res)=>{
    res.send("Manuel Isaac Gomez Galvis y Herrera Barajas Brayan David B191")
});

export default app;