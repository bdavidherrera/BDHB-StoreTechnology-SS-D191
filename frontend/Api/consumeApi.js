//Usuarios API
const urlRegistarUsu = "http://localhost:8000/Registrar";
const urlLoginUsu = "http://localhost:8000/Login";
const urlUsuarios = "http://localhost:8000/api/usuarios/admin"
const urlActualizarUsuarios = "http://localhost:8000/api/usuarios/Actualizar";
const  urlEliminarUsuarios = "http://localhost:8000/api/usuarios/EliminarUsuario/:idusuarios";

//Productos API
const urlProductos = "http://localhost:8000/api/tecnologia"
const urlRegistrarProductos = "http://localhost:8000/api/tecnologia/RegistrarProducto"
const urlActualizarProductos = "http://localhost:8000/api/tecnologia/ActualizarProducto"
const urlEliminarProductos = "http://localhost:8000/api/tecnologia/EliminarProducto/:idProducto"


//Usuarios CRUD

export const registrarUsuario = async (datosUsuario) => {
    try {
        const response = await fetch(`${urlRegistarUsu}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(datosUsuario)
        });
        
        const resultado = await response.json();
        return resultado;
        
    } catch (error) {
        console.error("Error al registrar usuario:", error);
    }
}

export const loginUsuario = async (datosLogin) => {
    try {
        const response = await fetch(`${urlLoginUsu}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(datosLogin)
        });
        
        const resultado = await response.json();
        return resultado;
        
    } catch (error) {
        console.error("Error al iniciar sesión:", error);
    }
}

export const obtainUsuarios = async ()=>{
    try {
        const resultadousuarios = await fetch(urlUsuarios);
        const usuarios = await resultadousuarios.json();
        return usuarios;
    } catch (error) {
        console.error("error al obtener los usuarios");
    }
}

export const actualizarUsuarios = async (datosUsuarios) => {
    try {
        const response = await fetch(`${urlActualizarUsuarios}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(datosUsuarios)
        });
        const resultado = await response.json();
        return resultado;                                   
    } catch (error) {
        console.error("Error al actualizar usuarios:", error);
    }
} 

export const eliminarUsuarios = async (idusuarios) => {
    try {
        const response = await fetch(`${urlEliminarUsuarios.replace(':idusuarios', idusuarios)}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            }   
        });
        const resultado = await response.json();
        return resultado;
    } catch (error) {
        console.error("Error al eliminar el usuario:", error);
    }
}

//Productos Tecnologicos CRUD

export const obtainProductos = async ()=>{
    try {
        const resultado = await fetch(urlProductos);
        const productos = await resultado.json();
        return productos;
    } catch (error) {
        console.error("error al obtener los productos");
    }
}

export const RegistrarProductos = async (datosProductos) => {
    try {
        const response = await fetch(`${urlRegistrarProductos}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(datosProductos)
            
        });
        
        
        const resultado = await response.json();
        return resultado;
        
    } catch (error) {
        console.error("Error al registrar los productos:", error);
    }
}

export const actualizarProductos = async (datosProductos) => {
    try {
        const response = await fetch(`${urlActualizarProductos}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(datosProductos)
        });
        const resultado = await response.json();
        return resultado;                                   
    } catch (error) {
        console.error("Error al actualizar los productos:", error);
    }
}

export const eliminarProductos = async (idproductos) => {
    try {
        const response = await fetch(`${urlEliminarProductos.replace(':idProducto', idproductos)}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            }   
        });
        const resultado = await response.json();
        return resultado;
    } catch (error) {
        console.error("Error al eliminar el Producto:", error);
    }
}


