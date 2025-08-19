import { obtainPedidos } from './../Api/consumeApi.js';

document.addEventListener("DOMContentLoaded", () => {
    const tablaPedidosT = document.querySelector('#tablaPedidos')

    if (tablaPedidosT) {
        obtenerPedidos();
    }

})

async function obtenerPedidos() {
    try {
        const PedidosObtained = await obtainPedidos();
        const container = document.querySelector('#tablaPedidos');
        container.innerHTML = "";

        PedidosObtained.forEach((pedidos) => {
            const { idPedido, estado, infopersona, correo_electronico, fecha_pedido, fecha_actualizacion, idUsuario, Direccion, nombresProductos, subtotal, descuentos_totales, impuestos_totales, total } = pedidos;

            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${idPedido}</td>
                <td>${estado}</td>
                <td>${infopersona}</td>
                <td>${correo_electronico}</td>
                <td>${Direccion}</td>
                <td>${nombresProductos}</td>
                <td>${new Date(fecha_pedido).toLocaleString()}</td>
                <td>${new Date(fecha_actualizacion).toLocaleString()}</td>
                <td>${subtotal}</td>
                <td>${descuentos_totales}</td>
                <td>${impuestos_totales}</td>
                <td>${total}%</td>
                <td>${idUsuario}</td>
                <td>
                    <button class="btn btn-sm btn-edit btn-action" data-id="${idPedido} id="actualizarProducto">
                        <i class="fas fa-edit"> </i>
                    </button>
                </td>
            `;
            container.appendChild(row);
        });





    } catch (error) {
        console.error('Error al obtener pedidos:', error);
        mostrarMensaje('Error al cargar los pedidos', 'error');
    }
}