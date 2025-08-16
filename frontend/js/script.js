// ==================== CONFIGURACIÓN Y DATOS ====================

const SHIPPING_COST = 15.00;

const products = [
    {
        id: 1,
        name: "iPhone 15 Pro",
        description: "El smartphone más avanzado con chip A17 Pro y cámara profesional",
        price: 999,
        image: "img/iPhone.jpg"
    },
    {
        id: 2,
        name: "MacBook Air M2",
        description: "Laptop ultradelgada con chip M2 y batería de larga duración",
        price: 1199,
        image: "img/Macbook-air-m2.jpeg"
    },
    {
        id: 3,
        name: "iPad Pro 12.9",
        description: "Tablet profesional con pantalla Liquid Retina XDR",
        price: 1099,
        image: "img/iPad Pro 12.9.webp"
    },
    {
        id: 4,
        name: "Apple Watch Ultra",
        description: "Reloj inteligente resistente para deportes extremos",
        price: 799,
        image: "img/Apple_Watch_Ultra.webp"
    },
    {
        id: 5,
        name: "AirPods Pro",
        description: "Auriculares con cancelación activa de ruido",
        price: 249,
        image: "img/AirPods_Pro.png"
    },
    {
        id: 6,
        name: "Samsung Galaxy S24",
        description: "Smartphone con IA integrada y cámara de 200MP",
        price: 899,
        image: "img/Samsung_Galaxy_S24.jpg"
    }
];

let cart = [];

// ==================== GESTIÓN DE PRODUCTOS ====================

function loadProducts() {
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
            <img src="${product.image}" alt="${product.name}" class="product-img">
        </div>
        <div class="product-info">
            <div class="product-name">${product.name}</div>
            <div class="product-description">${product.description}</div>
            <div class="product-price">$${product.price}</div>
            <button class="add-to-cart-btn" onclick="addToCart(${product.id})">
                Agregar al Carrito
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
        existingItem.quantity += 1;
    } else {
        cart.push({ ...product, quantity: 1 });
    }

    updateCartUI();
    showAddedToCartAnimation();
}

function removeFromCart(productId) {
    cart = cart.filter(item => item.id !== productId);
    updateCartUI();
}

function updateQuantity(productId, change) {
    const item = findCartItemById(productId);
    if (!item) return;

    item.quantity += change;

    if (item.quantity <= 0) {
        removeFromCart(productId);
    } else {
        updateCartUI();
    }
}

function updateCartUI() {
    updateCartCount();
    updateCartItems();
    updateCartTotal();
}

function updateCartCount() {
    const cartCount = document.getElementById('cartCount');
    if (!cartCount) return;

    const totalItems = calculateTotalItems();
    cartCount.textContent = totalItems;
}

function updateCartItems() {
    const cartItems = document.getElementById('cartItems');
    if (!cartItems) return;

    if (cart.length === 0) {
        cartItems.innerHTML = `
            <div class="empty-cart">
                <p>Tu carrito está vacío</p>
            </div>
        `;
    } else {
        cartItems.innerHTML = cart.map(item => createCartItemHTML(item)).join('');
    }
}

function updateCartTotal() {
    const cartTotal = document.getElementById('cartTotal');
    if (!cartTotal) return;

    const total = calculateSubtotal();
    cartTotal.textContent = total.toFixed(2);
}

function createCartItemHTML(item) {
    return `
        <div class="cart-item">
            <div class="cart-item-image">
                <img src="${item.image}" alt="${item.name}" class="cart-img">
            </div>
            <div class="cart-item-info">
                <div class="cart-item-name">${item.name}</div>
                <div class="cart-item-price">$${item.price}</div>
                <div class="quantity-controls">
                    <button class="quantity-btn" onclick="updateQuantity(${item.id}, -1)">-</button>
                    <span>${item.quantity}</span>
                    <button class="quantity-btn" onclick="updateQuantity(${item.id}, 1)">+</button>
                </div>
            </div>
            <button class="remove-item" onclick="removeFromCart(${item.id})">
                Eliminar
            </button>
        </div>
    `;
}

// ==================== GESTIÓN DE MODALES ====================

function toggleCart() {
    const cartModal = document.getElementById('cartModal');
    if (!cartModal) return;

    cartModal.style.display = cartModal.style.display === 'flex' ? 'none' : 'flex';
}

function toggleCheckout() {
    const checkoutModal = document.getElementById('checkoutModal');
    if (!checkoutModal) return;

    checkoutModal.style.display = checkoutModal.style.display === 'flex' ? 'none' : 'flex';
}

function showCheckoutForm() {
    if (cart.length === 0) {
        alert('Tu carrito está vacío');
        return;
    }

    updateCheckoutTotals();
    const checkoutModal = document.getElementById('checkoutModal');
    if (checkoutModal) {
        checkoutModal.style.display = 'flex';
    }
    toggleCart();
}

// ==================== CHECKOUT Y PAGO ====================

function updateCheckoutTotals() {
    const subtotal = calculateSubtotal();
    const total = subtotal + SHIPPING_COST;

    updateElementText('checkoutSubtotal', subtotal.toFixed(2));
    updateElementText('shippingCost', SHIPPING_COST.toFixed(2));
    updateElementText('checkoutTotal', total.toFixed(2));
}

function processCheckout(formData) {
    const order = createOrder(formData);
    
    // Simular procesamiento
    setTimeout(() => {
        completeCheckout();
    }, 1000);
}

function createOrder(formData) {
    return {
        id: Date.now(),
        date: new Date().toISOString(),
        customer: {
            name: formData.fullName,
            email: formData.email,
            address: formData.address
        },
        items: [...cart],
        paymentMethod: formData.paymentMethod,
        subtotal: calculateSubtotal(),
        shipping: SHIPPING_COST,
        total: calculateSubtotal() + SHIPPING_COST
    };
}

function completeCheckout() {
    // Limpiar carrito y formulario
    cart = [];
    updateCartUI();
    toggleCheckout();
    
    const checkoutForm = document.getElementById('checkoutForm');
    if (checkoutForm) {
        checkoutForm.reset();
    }
    
    const cardDetails = document.getElementById('cardDetails');
    if (cardDetails) {
        cardDetails.style.display = 'none';
    }
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
        
        // Validar mes
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

function calculateSubtotal() {
    return cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
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
                cardDetails.style.display = this.value === 'creditCard' ? 'block' : 'none';
            }
        });
    });
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
            alert('Por favor corrige los siguientes errores:\n\n• ' + errors.join('\n• '));
            return;
        }

        const submitBtn = this.querySelector('button[type="submit"]');
        setSubmitButtonLoading(submitBtn, true);

        processCheckout(formData);

        setTimeout(() => {
            setSubmitButtonLoading(submitBtn, false);
        }, 1500);
    });
}

function collectFormData() {
    return {
        fullName: document.getElementById('fullName')?.value,
        email: document.getElementById('email')?.value,
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
        button.innerHTML = 'Procesando...';
        button.disabled = true;
    } else {
        button.innerHTML = button.dataset.originalText || 'Confirmar Pedido';
        button.disabled = false;
    }
}

// ==================== INICIALIZACIÓN ====================

document.addEventListener('DOMContentLoaded', function() {
    loadProducts();
    updateCartUI();
    setupEventListeners();
});