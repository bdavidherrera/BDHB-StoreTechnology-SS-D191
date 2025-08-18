// ==================== CONFIGURACIÓN Y DATOS ====================

import { obtainProductos, crearPedido } from '../Api/consumeApi.js';

const SHIPPING_COST = 15000; // Costo de envío en pesos colombianos

let products = [];
let cart = [];

// ==================== INICIALIZACIÓN ====================

document.addEventListener('DOMContentLoaded', function() {
    loadProducts();
    updateCartUI();
    setupEventListeners();
});

// ==================== GESTIÓN DE PRODUCTOS ====================

async function loadProducts() {
    try {
        const productsData = await obtainProductos();
        
        if (productsData && Array.isArray(productsData)) {
            products = productsData.map(product => ({
                id: product.idProducto,
                name: product.nombreProducto,
                description: product.informacion || "Producto de alta calidad",
                price: parseFloat(product.valor),
                image: product.imagen ? `img/${product.imagen}` : null,
                stock: product.cantidad || 0,
                taxRate: (product.porcentaje_impuesto || 19) / 100
            }));
            
            renderProducts();
        }
    } catch (error) {
        console.error("Error al cargar productos:", error);
        showErrorMessage("Error al cargar los productos");
    }
}

function renderProducts() {
    const productsGrid = document.getElementById('productsGrid');
    if (!productsGrid) return;

    productsGrid.innerHTML = '';

    products.forEach(product => {
        const productCard = createProductCard(product);
        productsGrid.appendChild(productCard);
    });
}

function createProductCard(product) {
    const productCard = document.createElement('div');
    productCard.className = 'product-card';
    productCard.innerHTML = `
        <div class="product-image">
            ${product.image ? 
                `<img src="${product.image}" alt="${product.name}" class="product-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                 <div class="product-emoji-fallback" style="display:none;">📱</div>` :
                `<div class="product-emoji-fallback">📱</div>`
            }
        </div>
        <div class="product-info">
            <div class="product-name">${product.name}</div>
            <div class="product-description">${product.description}</div>
            <div class="product-price">$${formatPrice(product.price)}</div>
            <div class="product-stock">${product.stock > 0 ? `Stock: ${product.stock}` : 'Sin stock'}</div>
            <button class="add-to-cart-btn" 
                    onclick="addToCart(${product.id})" 
                    ${product.stock <= 0 ? 'disabled' : ''}>
                ${product.stock > 0 ? 'Agregar al Carrito' : 'Sin Stock'}
            </button>
        </div>
    `;
    return productCard;
}

// ==================== GESTIÓN DEL CARRITO ====================

function addToCart(productId) {
    const product = findProductById(productId);
    if (!product) return;

    const existingItem = findCartItemById(productId);

    if (existingItem) {
        if (existingItem.quantity < product.stock) {
            existingItem.quantity += 1;
            showAddedToCartAnimation();
        } else {
            showErrorMessage("No hay suficiente stock disponible");
            return;
        }
    } else {
        if (product.stock > 0) {
            cart.push({ ...product, quantity: 1 });
            showAddedToCartAnimation();
        } else {
            showErrorMessage("Producto sin stock");
            return;
        }
    }

    updateCartUI();
    showSuccessMessage("Producto agregado al carrito");
}

function removeFromCart(productId) {
    cart = cart.filter(item => item.id !== productId);
    updateCartUI();
}

function updateQuantity(productId, change) {
    const item = findCartItemById(productId);
    if (!item) return;

    const product = findProductById(productId);
    const newQuantity = item.quantity + change;

    if (newQuantity <= 0) {
        removeFromCart(productId);
    } else if (newQuantity <= product.stock) {
        item.quantity = newQuantity;
        updateCartUI();
    } else {
        showErrorMessage("Cantidad excede el stock disponible");
    }
}

function updateCartUI() {
    updateCartCount();
    updateCartItems();
    updateCartTotals();
}

function updateCartCount() {
    const cartCount = document.getElementById('cartCount');
    if (!cartCount) return;

    const totalItems = calculateTotalItems();
    cartCount.textContent = totalItems;
    
    // Animación del contador
    if (totalItems > 0) {
        cartCount.style.display = 'flex';
    } else {
        cartCount.style.display = 'none';
    }
}

function updateCartItems() {
    const cartItems = document.getElementById('cartItems');
    if (!cartItems) return;

    if (cart.length === 0) {
        cartItems.innerHTML = `
            <div class="empty-cart">
                <i class="fas fa-shopping-cart" style="font-size: 3rem; color: #ccc; margin-bottom: 1rem;"></i>
                <p>Tu carrito está vacío</p>
                <p style="font-size: 0.9rem; color: #666;">Agrega algunos productos para comenzar</p>
            </div>
        `;
    } else {
        cartItems.innerHTML = cart.map(item => createCartItemHTML(item)).join('');
    }
}

function createCartItemHTML(item) {
    const itemSubtotal = item.price * item.quantity;
    const itemTax = itemSubtotal * item.taxRate;
    const itemTotal = itemSubtotal + itemTax;

    return `
        <div class="cart-item">
            <div class="cart-item-image">
                ${item.image ? 
                    `<img src="${item.image}" alt="${item.name}" class="cart-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                     <div class="cart-emoji-fallback" style="display:none;">📱</div>` :
                    `<div class="cart-emoji-fallback">📱</div>`
                }
            </div>
            <div class="cart-item-info">
                <div class="cart-item-name">${item.name}</div>
                <div class="cart-item-price">$${formatPrice(item.price)} c/u</div>
                <div class="cart-item-subtotal">Subtotal: $${formatPrice(itemSubtotal)}</div>
                <div class="cart-item-tax">IVA (${(item.taxRate * 100)}%): $${formatPrice(itemTax)}</div>
                <div class="cart-item-total">Total: $${formatPrice(itemTotal)}</div>
                <div class="quantity-controls">
                    <button class="quantity-btn" onclick="updateQuantity(${item.id}, -1)" title="Disminuir cantidad">
                        <i class="fas fa-minus"></i>
                    </button>
                    <span class="quantity-display">${item.quantity}</span>
                    <button class="quantity-btn" onclick="updateQuantity(${item.id}, 1)" title="Aumentar cantidad">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
            </div>
            <button class="remove-item" onclick="removeFromCart(${item.id})" title="Eliminar producto">
                <i class="fas fa-trash-alt"></i>
            </button>
        </div>
    `;
}

function updateCartTotals() {
    const totals = calculateCartTotals();
    
    // Actualizar totales en el modal del carrito
    updateElementText('cartSubtotal', formatPrice(totals.subtotal));
    updateElementText('cartTax', formatPrice(totals.tax));
    updateElementText('cartTotal', formatPrice(totals.total));
    
    // Actualizar totales en el checkout
    updateElementText('checkoutSubtotal', formatPrice(totals.subtotal));
    updateElementText('checkoutTax', formatPrice(totals.tax));
    updateElementText('shippingCost', formatPrice(SHIPPING_COST));
    updateElementText('checkoutTotal', formatPrice(totals.total + SHIPPING_COST));
}

function calculateCartTotals() {
    const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    const tax = cart.reduce((sum, item) => sum + (item.price * item.quantity * item.taxRate), 0);
    const total = subtotal + tax;

    return {
        subtotal: subtotal,
        discounts: 0, // Por ahora sin descuentos
        tax: tax,
        total: total
    };
}

// ==================== GESTIÓN DE MODALES ====================

function toggleCart() {
    const cartModal = document.getElementById('cartModal');
    if (!cartModal) return;

    if (cartModal.style.display === 'flex') {
        cartModal.style.display = 'none';
    } else {
        updateCartUI(); // Actualizar antes de mostrar
        cartModal.style.display = 'flex';
    }
}

function toggleCheckout() {
    const checkoutModal = document.getElementById('checkoutModal');
    if (!checkoutModal) return;

    checkoutModal.style.display = checkoutModal.style.display === 'flex' ? 'none' : 'flex';
}

function showCheckoutForm() {
    if (cart.length === 0) {
        showErrorMessage('Tu carrito está vacío');
        return;
    }

    updateCartTotals();
    prefillUserData();
    toggleCheckout();
    toggleCart(); // Cerrar el carrito
}

// ==================== CHECKOUT Y PROCESAMIENTO ====================

function prefillUserData() {
    // Prellenar datos del usuario logueado
    const userName = sessionStorage.getItem('nombre');
    const userEmail = sessionStorage.getItem('correo');
    
    if (userName) {
        const nameInput = document.getElementById('fullName');
        if (nameInput) nameInput.value = userName;
    }
    
    if (userEmail) {
        const emailInput = document.getElementById('email');
        if (emailInput) emailInput.value = userEmail;
    }
}

async function processCheckout(formData) {
    try {
        setSubmitButtonLoading(document.querySelector('#checkoutForm button[type="submit"]'), true);
        
        const totals = calculateCartTotals();
        const userId = sessionStorage.getItem('idUsuario');
        
        // Preparar los items del carrito para el detalle del pedido
        const items = cart.map(item => ({
            idProducto: item.id,
            cantidad: item.quantity,
            precio_unitario: item.price,
            descuento_unitario: 0, // Sin descuentos por ahora
            impuesto_unitario: item.price * item.taxRate,
            total_linea: (item.price * item.quantity) + (item.price * item.quantity * item.taxRate)
        }));
        
        // Crear el pedido
        const orderData = {
            estado: 'pendiente',
            infopersona: `${formData.fullName} - CC: ${sessionStorage.getItem('cedula') || 'N/A'}`,
            correo_electronico: formData.email,
            Direccion: formData.address,
            nombresProductos: generateProductsString(),
            subtotal: totals.subtotal,
            descuentos_totales: totals.discounts,
            impuestos_totales: totals.tax,
            total: totals.total + SHIPPING_COST,
            idUsuario: parseInt(userId),
            items: items, // Agregar los items para el detalle del pedido
            datosPago: { // Agregar datos del pago
                paymentMethod: formData.paymentMethod,
                cardNumber: formData.cardNumber,
                telefono: formData.telefono || null
            }
        };

        console.log('Enviando pedido:', orderData);
        
        // Llamar a la API para crear el pedido
        const resultado = await crearPedido(orderData);
        
        if (resultado && resultado.success) {
            completeCheckout();
            showSuccessMessage(`¡Pedido #${resultado.idPedido} realizado exitosamente!${resultado.idPago ? ` Pago #${resultado.idPago} registrado.` : ''} Recibirás un correo de confirmación.`);
            loadProducts();
        } else {
            throw new Error(resultado.message || 'Error al procesar el pedido');
        }
        
    } catch (error) {
        console.error('Error al procesar el checkout:', error);
        showErrorMessage('Error al procesar el pedido. Por favor, intenta nuevamente.');
        setSubmitButtonLoading(document.querySelector('#checkoutForm button[type="submit"]'), false);
    }
}

function generateProductsString() {
    return cart.map(item => `${item.name} (${item.quantity})`).join(', ');
}

function completeCheckout() {
    // Limpiar carrito y cerrar modales
    cart = [];
    updateCartUI();
    toggleCheckout();
    
    // Resetear formulario
    const checkoutForm = document.getElementById('checkoutForm');
    if (checkoutForm) {
        checkoutForm.reset();
        hideCardDetails();
    }
    
    setSubmitButtonLoading(document.querySelector('#checkoutForm button[type="submit"]'), false);
}

// ==================== VALIDACIÓN Y FORMATEO ====================

function validateCheckoutForm(formData) {
    const errors = [];
    
    if (!formData.fullName?.trim()) {
        errors.push('El nombre completo es requerido');
    }

    if (!isValidEmail(formData.email)) {
        errors.push('Ingresa un correo electrónico válido');
    }

    if (!formData.address?.trim()) {
        errors.push('La dirección de envío es requerida');
    }

    if (!formData.paymentMethod) {
        errors.push('Selecciona un método de pago');
    }

    if (formData.paymentMethod === 'creditCard') {
        validateCreditCardFields(formData, errors);
    }

    return errors;
}

function validateCreditCardFields(formData, errors) {
    if (!formData.cardNumber || !/^\d{4}\s\d{4}\s\d{4}\s\d{4}$/.test(formData.cardNumber)) {
        errors.push('El número de tarjeta debe tener 16 dígitos');
    }

    if (!formData.expiryDate || !/^(0[1-9]|1[0-2])\/\d{2}$/.test(formData.expiryDate)) {
        errors.push('Fecha de vencimiento inválida (MM/YY)');
    }

    if (!formData.cvv || !/^\d{3,4}$/.test(formData.cvv)) {
        errors.push('CVV debe tener 3 o 4 dígitos');
    }
}

// Funciones de formateo (reutilizando del script.js original)
function formatCardNumber(input) {
    let value = input.value.replace(/\s/g, '').replace(/[^0-9]/gi, '');
    value = value.substring(0, 16);
    
    const formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
    input.value = formattedValue;
}

function formatExpiryDate(input) {
    let value = input.value.replace(/\D/g, '');
    
    if (value.length >= 2) {
        let month = value.substring(0, 2);
        let year = value.substring(2, 4);
        
        if (parseInt(month) > 12) month = '12';
        if (parseInt(month) < 1 && month.length === 2) month = '01';
        
        input.value = month + (year ? '/' + year : '');
    } else {
        input.value = value;
    }
}

function formatCVV(input) {
    const value = input.value.replace(/[^0-9]/g, '');
    input.value = value.substring(0, 4);
}

function formatName(input) {
    input.value = input.value.replace(/[^a-zA-ZÀ-ÿ\s]/g, '');
}

// ==================== UTILIDADES Y HELPERS ====================

function findProductById(id) {
    return products.find(p => p.id === id);
}

function findCartItemById(id) {
    return cart.find(item => item.id === id);
}

function calculateTotalItems() {
    return cart.reduce((sum, item) => sum + item.quantity, 0);
}

function isValidEmail(email) {
    return email?.trim() && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function updateElementText(id, text) {
    const element = document.getElementById(id);
    if (element) {
        element.textContent = text;
    }
}

function formatPrice(price) {
    return new Intl.NumberFormat('es-CO').format(Math.round(price));
}

function showAddedToCartAnimation() {
    const cartIcon = document.querySelector('.cart-icon');
    if (!cartIcon) return;

    cartIcon.style.transform = 'scale(1.2)';
    cartIcon.style.background = 'rgba(40, 167, 69, 0.3)';

    setTimeout(() => {
        cartIcon.style.transform = 'scale(1)';
        cartIcon.style.background = 'rgba(255,255,255,0.2)';
    }, 300);
}

function scrollToProducts() {
    const productsSection = document.getElementById('products');
    if (productsSection) {
        productsSection.scrollIntoView({ behavior: 'smooth' });
    }
}

function showSuccessMessage(message) {
    // Crear y mostrar mensaje de éxito
    const alertDiv = document.createElement('div');
    alertDiv.className = 'success-message';
    alertDiv.innerHTML = `<i class="fas fa-check-circle"></i> ${message}`;
    
    document.body.appendChild(alertDiv);
    
    setTimeout(() => {
        document.body.removeChild(alertDiv);
    }, 3000);
}

function showErrorMessage(message) {
    // Crear y mostrar mensaje de error
    const alertDiv = document.createElement('div');
    alertDiv.className = 'error-message';
    alertDiv.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${message}`;
    
    document.body.appendChild(alertDiv);
    
    setTimeout(() => {
        if (document.body.contains(alertDiv)) {
            document.body.removeChild(alertDiv);
        }
    }, 3000);
}

// ==================== EVENT LISTENERS ====================

function setupEventListeners() {
    setupModalClickEvents();
    setupKeyboardEvents();
    setupPaymentMethodToggle();
    setupInputFormatting();
    setupFormSubmission();
}

function setupModalClickEvents() {
    document.addEventListener('click', function(e) {
        const cartModal = document.getElementById('cartModal');
        const checkoutModal = document.getElementById('checkoutModal');
        
        if (e.target === cartModal) toggleCart();
        if (e.target === checkoutModal) toggleCheckout();
    });
}

function setupKeyboardEvents() {
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            const cartModal = document.getElementById('cartModal');
            const checkoutModal = document.getElementById('checkoutModal');
            
            if (cartModal?.style.display === 'flex') {
                toggleCart();
            } else if (checkoutModal?.style.display === 'flex') {
                toggleCheckout();
            }
        }
    });
}

function setupPaymentMethodToggle() {
    const paymentMethods = document.querySelectorAll('input[name="paymentMethod"]');
    paymentMethods.forEach(method => {
        method.addEventListener('change', function() {
            const cardDetails = document.getElementById('cardDetails');
            if (cardDetails) {
                if (this.value === 'creditCard') {
                    cardDetails.style.display = 'block';
                } else {
                    cardDetails.style.display = 'none';
                    hideCardDetails();
                }
            }
        });
    });
}

function hideCardDetails() {
    const cardDetails = document.getElementById('cardDetails');
    if (cardDetails) {
        cardDetails.style.display = 'none';
    }
}

function setupInputFormatting() {
    const inputs = {
        fullName: formatName,
        cardNumber: formatCardNumber,
        expiryDate: formatExpiryDate,
        cvv: formatCVV
    };

    Object.entries(inputs).forEach(([id, formatter]) => {
        const input = document.getElementById(id);
        if (input) {
            input.addEventListener('input', () => formatter(input));
        }
    });
}

function setupFormSubmission() {
    const checkoutForm = document.getElementById('checkoutForm');
    if (!checkoutForm) return;

    checkoutForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const formData = collectFormData();
        const errors = validateCheckoutForm(formData);
        
        if (errors.length > 0) {
            showErrorMessage('Por favor corrige los siguientes errores:\n\n• ' + errors.join('\n• '));
            return;
        }

        processCheckout(formData);
    });
}

function collectFormData() {
    return {
        fullName: document.getElementById('fullName')?.value,
        email: document.getElementById('email')?.value,
        telefono: document.getElementById('telefono')?.value,
        address: document.getElementById('address')?.value,
        paymentMethod: document.querySelector('input[name="paymentMethod"]:checked')?.value,
        cardNumber: document.getElementById('cardNumber')?.value,
        expiryDate: document.getElementById('expiryDate')?.value,
        cvv: document.getElementById('cvv')?.value
    };
}

function setSubmitButtonLoading(button, isLoading) {
    if (!button) return;

    if (isLoading) {
        button.dataset.originalText = button.innerHTML;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Procesando...';
        button.disabled = true;
    } else {
        button.innerHTML = button.dataset.originalText || '<i class="fas fa-lock"></i> Confirmar Pedido';
        button.disabled = false;
    }
}

// ==================== FUNCIONES GLOBALES ====================
// Estas funciones deben estar disponibles globalmente para los onclick en HTML

window.addToCart = addToCart;
window.removeFromCart = removeFromCart;
window.updateQuantity = updateQuantity;
window.toggleCart = toggleCart;
window.toggleCheckout = toggleCheckout;
window.showCheckoutForm = showCheckoutForm;
window.scrollToProducts = scrollToProducts;