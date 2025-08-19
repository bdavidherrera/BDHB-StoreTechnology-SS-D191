import { obtainProductos, RegistrarProductos, actualizarProductos, eliminarProductos } from '../../Api/consumeApi.js';

document.addEventListener("DOMContentLoaded", () => {
    const tablaProductosS = document.querySelector('#tablaProductos')
    const formEditarProducto = document.querySelector('formEditarProducto')

    mostrarProductosTienda();
    
    if (tablaProductosS) {
        obtenerProductos()
        configurarFormularioProducto()
        configurarSelectorImagen()
    }
    if(formEditarProducto){
        
    }
})

async function obtenerProductos() {
    try {
        const ProductosObtained = await obtainProductos();
        const container = document.querySelector('#tablaProductos');
        container.innerHTML = "";

        ProductosObtained.forEach((productos) => {
            const { idProducto, nombreProducto, imagen, valor, cantidad, informacion, fecha_creacion, porcentaje_impuesto } = productos;

            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${idProducto}</td>
                <td>${nombreProducto}</td>
                <td>
                    <div class="rollo-imagen-container">
                        <img src="img/${imagen}" width="40px" class="rollo-imagen">
                    </div>
                </td>
                <td>$${Number(valor).toLocaleString('es-CO')}</td>
                <td>${cantidad}</td>
                <td>${informacion}</td>
                <td>${new Date(fecha_creacion).toLocaleString()}</td>
                <td>${porcentaje_impuesto || 19}%</td>
                <td>
                    <button class="btn btn-sm btn-edit btn-action" data-id="${idProducto} id="actualizarProducto">
                        <i class="fas fa-edit"> </i>
                    </button>
                    <button class="btn btn-sm btn-delete btn-action" data-id="${idProducto}">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            `;
            container.appendChild(row);
        });

        // Agregar event listeners para los botones de eliminar
        configurarBotonesEliminar();
        configurarBotonesEditar();

    } catch (error) {
        console.error('Error al obtener productos:', error);
        mostrarMensaje('Error al cargar los productos', 'error');
    }
}

function configurarFormularioProducto() {
    const formulario = document.getElementById('formAgregarProducto');

    if (formulario) {
        formulario.addEventListener('submit', manejarEnvioFormulario);
    }
}

function configurarBotonesEditar() {
    const botonesEditar = document.querySelectorAll('.btn-edit');

    botonesEditar.forEach(boton => {
        boton.addEventListener('click', function() {
            window.location.href = `../../frontend/ProductoAdmin/editarProducto.html`;
        });
    });
}

function configurarSelectorImagen() {
    const inputImagen = document.getElementById('imagen');
    const label = document.querySelector('.custom-file-label');
    const preview = document.getElementById('imagenPreview');
    const previewImg = document.getElementById('previewImg');
    const nombreArchivo = document.getElementById('nombreArchivo');

    if (inputImagen) {
        inputImagen.addEventListener('change', function () {
            const file = this.files[0];

            if (file) {
                // Actualizar el label con el nombre del archivo
                if (label) {
                    label.textContent = file.name;
                }

                // Mostrar información del archivo
                if (nombreArchivo) {
                    nombreArchivo.textContent = file.name;
                }

                // Validar tipo de archivo
                const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
                if (validTypes.includes(file.type)) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');

                    // Crear preview de la imagen
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        if (previewImg) {
                            previewImg.src = e.target.result;
                        }
                        if (preview) {
                            preview.style.display = 'block';
                        }
                    };
                    reader.readAsDataURL(file);

                } else {
                    this.classList.add('is-invalid');
                    this.classList.remove('is-valid');
                    if (preview) {
                        preview.style.display = 'none';
                    }
                    mostrarMensaje('Por favor seleccione un archivo de imagen válido (JPG, PNG, GIF, WEBP)', 'warning');
                    this.value = '';
                    if (label) {
                        label.textContent = 'Seleccionar imagen...';
                    }
                }
            } else {
                if (label) {
                    label.textContent = 'Seleccionar imagen...';
                }
                if (preview) {
                    preview.style.display = 'none';
                }
            }
        });
    }
}

async function manejarEnvioFormulario(e) {
    e.preventDefault();

    // Obtener el archivo seleccionado
    const inputImagen = document.getElementById('imagen');
    const archivo = inputImagen.files[0];

    if (!archivo) {
        mostrarMensaje('Por favor seleccione una imagen', 'warning');
        return;
    }

    // Obtener datos del formulario
    const formData = new FormData(e.target);
    const datosProducto = {
        nombreProducto: formData.get('nombreProducto').trim(),
        imagen: archivo.name, // Usar el nombre completo del archivo seleccionado
        valor: parseFloat(formData.get('valor')),
        cantidad: parseInt(formData.get('cantidad')),
        informacion: formData.get('informacion').trim()
    };

    // Validar datos
    if (!validarDatosProducto(datosProducto, archivo)) {
        return;
    }

    // Mostrar estado de carga
    const btnSubmit = e.target.querySelector('button[type="submit"]');
    const textoOriginal = btnSubmit.innerHTML;
    btnSubmit.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Guardando...';
    btnSubmit.disabled = true;

    try {
        // Si necesitas subir la imagen al servidor, aquí puedes hacerlo
        // const imagenSubida = await subirImagen(archivo);

        // Registrar producto con el nombre del archivo
        const resultado = await RegistrarProductos(datosProducto);

        if (resultado) {
            // Éxito
            mostrarMensaje('¡Producto agregado exitosamente!', 'success');

            // Cerrar modal y limpiar formulario
            const modal = document.getElementById('modalAgregarProducto');
            if (window.$ && window.$.fn.modal) {
                window.$('#modalAgregarProducto').modal('hide');
            }
            limpiarFormulario();

            // Recargar tabla de productos
            await obtenerProductos();
        } else {
            mostrarMensaje('Error al agregar el producto', 'error');
        }

    } catch (error) {
        console.error('Error al registrar producto:', error);
        mostrarMensaje('Error al conectar con el servidor', 'error');
    } finally {
        // Restablecer botón
        btnSubmit.innerHTML = textoOriginal;
        btnSubmit.disabled = false;
    }
}

function validarDatosProducto(datos, archivo) {
    const errores = [];

    // Validar nombre
    if (!datos.nombreProducto || datos.nombreProducto.length < 2) {
        errores.push('El nombre del producto debe tener al menos 2 caracteres');
    }

    // Validar valor
    if (!datos.valor || datos.valor <= 0) {
        errores.push('El precio debe ser mayor a 0');
    }

    // Validar cantidad
    if (!datos.cantidad || datos.cantidad < 0) {
        errores.push('La cantidad debe ser mayor o igual a 0');
    }

    // Validar imagen
    if (!archivo) {
        errores.push('Debe seleccionar una imagen');
    } else {
        const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
        if (!validTypes.includes(archivo.type)) {
            errores.push('El archivo debe ser una imagen válida (JPG, PNG, GIF, WEBP)');
        }

        // Validar tamaño del archivo (ejemplo: máximo 5MB)
        const maxSize = 5 * 1024 * 1024; // 5MB en bytes
        if (archivo.size > maxSize) {
            errores.push('El archivo de imagen debe ser menor a 5MB');
        }
    }

    // Validar información
    if (!datos.informacion || datos.informacion.length < 10) {
        errores.push('La información del producto debe tener al menos 10 caracteres');
    }

    if (errores.length > 0) {
        mostrarMensaje('Por favor corrige los siguientes errores:\n' + errores.join('\n'), 'warning');
        return false;
    }

    return true;
}

function configurarBotonesEliminar() {
    const botonesEliminar = document.querySelectorAll('.btn-delete');

    botonesEliminar.forEach(boton => {
        boton.addEventListener('click', async function () {
            const idProducto = this.getAttribute('data-id');

            if (confirm('¿Estás seguro de que quieres eliminar este producto?')) {
                try {
                    const resultado = await eliminarProductos(idProducto);

                    if (resultado) {
                        mostrarMensaje('Producto eliminado exitosamente', 'success');
                        await obtenerProductos(); // Recargar tabla
                    } else {
                        mostrarMensaje('Error al eliminar el producto', 'error');
                    }
                } catch (error) {
                    console.error('Error al eliminar producto:', error);
                    mostrarMensaje('Error al conectar con el servidor', 'error');
                }
            }
        });
    });
}

function mostrarMensaje(mensaje, tipo = 'info') {
    // Crear elemento de alerta
    const alerta = document.createElement('div');
    alerta.className = `alert alert-${tipo === 'success' ? 'success' : tipo === 'error' ? 'danger' : 'warning'} alert-dismissible fade show position-fixed`;
    alerta.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';

    alerta.innerHTML = `
        <div class="d-flex align-items-center">
            <i class="fas fa-${tipo === 'success' ? 'check-circle' : tipo === 'error' ? 'exclamation-triangle' : 'info-circle'} me-2"></i>
            <div>${mensaje}</div>
            <button type="button" class="close ml-auto" onclick="this.parentElement.parentElement.remove()">
                <span>&times;</span>
            </button>
        </div>
    `;

    document.body.appendChild(alerta);

    // Auto-eliminar después de 5 segundos
    setTimeout(() => {
        if (alerta && alerta.parentNode) {
            alerta.remove();
        }
    }, 5000);
}

function limpiarFormulario() {
    const formulario = document.getElementById('formAgregarProducto');
    if (formulario) {
        formulario.reset();
        // Remover clases de validación
        formulario.querySelectorAll('.form-control, .custom-file-input').forEach(input => {
            input.classList.remove('is-valid', 'is-invalid');
        });

        // Limpiar preview de imagen
        const preview = document.getElementById('imagenPreview');
        const previewImg = document.getElementById('previewImg');
        const label = document.querySelector('.custom-file-label');

        if (preview) preview.style.display = 'none';
        if (previewImg) previewImg.src = '';
        if (label) label.textContent = 'Seleccionar imagen...';
    }
}

// === Mostrar productos en la tienda ===
async function mostrarProductosTienda() {
    const productsGrid = document.getElementById('productsGrid');
    if (!productsGrid) return;

    productsGrid.innerHTML = '';

    try {
        const productos = await obtainProductos();

        productos.forEach(producto => {
            const productCard = createProductCardTienda(producto);
            productsGrid.appendChild(productCard);
        });
    } catch (error) {
        console.error("Error al cargar los productos en la tienda:", error);
        productsGrid.innerHTML = `<p class="text-danger">Error al cargar los productos.</p>`;
    }
}

// === Crear card de producto ===
function createProductCardTienda(producto) {
    const productCard = document.createElement('div');
    productCard.className = 'product-card';

    productCard.innerHTML = `
        <div class="product-image">
            <img src="img/${producto.imagen}" alt="${producto.nombreProducto}" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-name">${producto.nombreProducto}</div>
            <div class="product-description">${producto.informacion}</div>
            <div class="product-price">$${Number(producto.valor).toLocaleString('es-CO')}</div>
            <button class="add-to-cart-btn" onclick="addToCart(${producto.idProducto})">
                Agregar al Carrito
            </button>
        </div>
    `;
    const btnAddToCart = productCard.querySelector('.add-to-cart-btn');
    btnAddToCart.addEventListener('click', (e) => {
        e.preventDefault();
        if (!sessionStorage.getItem("rol")) {

            $('#loginRequiredModal').modal('show');
        }})

    return productCard;
}


