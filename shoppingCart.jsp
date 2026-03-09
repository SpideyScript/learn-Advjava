<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.text.DecimalFormat" %>
<%
    DecimalFormat df = new DecimalFormat("0.00");

    // Product data as simple arrays
    int[]    ids    = {1, 2, 3, 4, 5, 6};
    String[] names  = {"Wireless Headphones", "Running Shoes", "Coffee Maker", "Backpack", "Sunglasses", "Smartwatch"};
    String[] cats   = {"Electronics", "Footwear", "Appliances", "Accessories", "Accessories", "Electronics"};
    double[] prices = {79.99, 59.99, 49.99, 39.99, 29.99, 199.99};
    String[] icons  = {"🎧", "👟", "☕", "🎒", "🕶️", "⌚"};

    // Cart stored as two arrays in session (ids + quantities)
    int[] cartIds = (int[]) session.getAttribute("cartIds");
    int[] cartQty = (int[]) session.getAttribute("cartQty");
    int   cartLen = 0;

    if (cartIds == null) {
        cartIds = new int[20];
        cartQty = new int[20];
        cartLen = 0;
    } else {
        cartLen = (int) session.getAttribute("cartLen");
    }

    // Handle actions
    String action = request.getParameter("action");
    String pidStr = request.getParameter("pid");

    if (action != null && pidStr != null) {
        int pid = Integer.parseInt(pidStr);

        if (action.equals("add")) {
            boolean found = false;
            for (int i = 0; i < cartLen; i++) {
                if (cartIds[i] == pid) { cartQty[i]++; found = true; break; }
            }
            if (!found && cartLen < 20) {
                cartIds[cartLen] = pid;
                cartQty[cartLen] = 1;
                cartLen++;
            }
        } else if (action.equals("inc")) {
            for (int i = 0; i < cartLen; i++) {
                if (cartIds[i] == pid) { cartQty[i]++; break; }
            }
        } else if (action.equals("dec")) {
            for (int i = 0; i < cartLen; i++) {
                if (cartIds[i] == pid) {
                    cartQty[i]--;
                    if (cartQty[i] == 0) {
                        for (int j = i; j < cartLen - 1; j++) {
                            cartIds[j] = cartIds[j+1];
                            cartQty[j] = cartQty[j+1];
                        }
                        cartLen--;
                    }
                    break;
                }
            }
        } else if (action.equals("remove")) {
            for (int i = 0; i < cartLen; i++) {
                if (cartIds[i] == pid) {
                    for (int j = i; j < cartLen - 1; j++) {
                        cartIds[j] = cartIds[j+1];
                        cartQty[j] = cartQty[j+1];
                    }
                    cartLen--;
                    break;
                }
            }
        } else if (action.equals("clear")) {
            cartLen = 0;
        }

        session.setAttribute("cartIds", cartIds);
        session.setAttribute("cartQty", cartQty);
        session.setAttribute("cartLen", cartLen);
        response.sendRedirect("shoppingCart.jsp");
        return;
    }

    // Calculate totals
    double subtotal = 0;
    for (int i = 0; i < cartLen; i++) {
        int pid = cartIds[i];
        for (int j = 0; j < ids.length; j++) {
            if (ids[j] == pid) { subtotal += prices[j] * cartQty[i]; break; }
        }
    }
    double tax      = subtotal * 0.08;
    double shipping = subtotal > 100 ? 0 : (subtotal > 0 ? 9.99 : 0);
    double total    = subtotal + tax + shipping;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f2f5; }

        header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; padding: 16px 32px;
            display: flex; justify-content: space-between; align-items: center;
        }
        header h1 { font-size: 1.4rem; }
        .badge {
            background: #ff4757; color: white;
            border-radius: 50%; padding: 2px 8px; font-size: 0.8rem; margin-left: 6px;
        }

        .container { max-width: 1100px; margin: 28px auto; padding: 0 20px; display: grid; grid-template-columns: 1fr 1fr; gap: 28px; }

        h2 { font-size: 1.1rem; color: #555; margin-bottom: 14px; }

        /* Products */
        .grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
        .card {
            background: white; border-radius: 10px; padding: 16px;
            text-align: center; box-shadow: 0 2px 6px rgba(0,0,0,0.07);
            transition: transform 0.2s;
        }
        .card:hover { transform: translateY(-3px); }
        .card .icon  { font-size: 2.2rem; margin-bottom: 8px; }
        .card .name  { font-weight: 600; font-size: 0.82rem; margin-bottom: 3px; }
        .card .cat   { font-size: 0.7rem; color: #aaa; margin-bottom: 6px; }
        .card .price { font-size: 0.95rem; font-weight: 700; color: #667eea; margin-bottom: 10px; }
        .btn-add {
            width: 100%; padding: 7px; border: none; border-radius: 18px; cursor: pointer;
            background: linear-gradient(135deg, #667eea, #764ba2); color: white;
            font-size: 0.78rem; transition: opacity 0.2s;
        }
        .btn-add:hover { opacity: 0.85; }

        /* Cart */
        .cart-side { display: flex; flex-direction: column; gap: 14px; }
        .cart-box { background: white; border-radius: 10px; box-shadow: 0 2px 6px rgba(0,0,0,0.07); overflow: hidden; }
        .empty { text-align: center; padding: 36px; color: #ccc; }
        .empty div { font-size: 2.5rem; margin-bottom: 8px; }

        .cart-row {
            display: flex; align-items: center; gap: 10px;
            padding: 12px 16px; border-bottom: 1px solid #f5f5f5;
        }
        .cart-row:last-child { border-bottom: none; }
        .row-icon { font-size: 1.6rem; }
        .row-info { flex: 1; }
        .row-info .n { font-weight: 600; font-size: 0.85rem; }
        .row-info .p { font-size: 0.75rem; color: #aaa; }
        .qty { display: flex; align-items: center; gap: 6px; }
        .qbtn {
            width: 24px; height: 24px; border-radius: 50%; border: none;
            background: #f0f2f5; cursor: pointer; font-size: 0.95rem; font-weight: bold;
        }
        .qbtn:hover { background: #ddd; }
        .qnum { font-weight: 600; min-width: 18px; text-align: center; font-size: 0.9rem; }
        .row-total { font-weight: 700; font-size: 0.9rem; min-width: 52px; text-align: right; }
        .del { background: none; border: none; color: #ff4757; cursor: pointer; font-size: 1rem; }

        /* Summary */
        .summary { background: white; border-radius: 10px; padding: 20px; box-shadow: 0 2px 6px rgba(0,0,0,0.07); }
        .summary h3 { font-size: 0.95rem; color: #666; margin-bottom: 14px; }
        .srow { display: flex; justify-content: space-between; font-size: 0.88rem; margin-bottom: 8px; }
        .srow.total { font-weight: 700; font-size: 1rem; color: #667eea; border-top: 1px solid #eee; padding-top: 10px; margin-top: 4px; }
        .free { color: #2ed573; font-weight: 600; }
        .note { font-size: 0.72rem; color: #bbb; margin-bottom: 12px; }
        .btn-checkout {
            width: 100%; padding: 12px; border: none; border-radius: 8px; cursor: pointer;
            background: linear-gradient(135deg, #667eea, #764ba2); color: white;
            font-size: 0.95rem; font-weight: 600; margin-top: 8px; transition: opacity 0.2s;
        }
        .btn-checkout:hover    { opacity: 0.88; }
        .btn-checkout:disabled { background: #ccc; cursor: not-allowed; }
        .btn-clear {
            width: 100%; padding: 9px; border: 2px solid #ff4757; background: none;
            color: #ff4757; border-radius: 8px; cursor: pointer; font-size: 0.82rem; margin-top: 6px;
        }
        .btn-clear:hover { background: #ff4757; color: white; }

        @media(max-width: 800px) { .container { grid-template-columns: 1fr; } }
        @media(max-width: 480px) { .grid { grid-template-columns: 1fr 1fr; } }
    </style>
</head>
<body>



<div class="container">

    <!-- PRODUCTS -->
    <div>
        <h2>📦 Products</h2>
        <div class="grid">
            <% for (int i = 0; i < ids.length; i++) { %>
            <div class="card">
                <div class="icon"><%= icons[i] %></div>
                <div class="name"><%= names[i] %></div>
                <div class="cat"><%= cats[i] %></div>
                <div class="price"><%= df.format(prices[i]) %></div>
                <a href="shoppingCart.jsp?action=add&pid=<%= ids[i] %>">
                    <button class="btn-add">+ Add to Cart</button>
                </a>
            </div>
            <% } %>
        </div>
    </div>

    <!-- CART -->
    <div class="cart-side">
        <h2>🛒 Your Cart</h2>
        <div class="cart-box">
            <% if (cartLen == 0) { %>
            <div class="empty">
                <div>🛒</div>
                <p>Your cart is empty</p>
            </div>
            <% } else {
                for (int i = 0; i < cartLen; i++) {
                    int pid = cartIds[i];
                    int qty = cartQty[i];
                    String iname = ""; String iicon = ""; double iprice = 0;
                    for (int j = 0; j < ids.length; j++) {
                        if (ids[j] == pid) { iname = names[j]; iicon = icons[j]; iprice = prices[j]; break; }
                    }
            %>
            <div class="cart-row">
                <div class="row-icon"><%= iicon %></div>
                <div class="row-info">
                    <div class="n"><%= iname %></div>
                    <div class="p"><%= df.format(iprice) %> each</div>
                </div>
                <div class="qty">
                    <a href="shoppingCart.jsp?action=dec&pid=<%= pid %>"><button class="qbtn">−</button></a>
                    <span class="qnum"><%= qty %></span>
                    <a href="shoppingCart.jsp?action=inc&pid=<%= pid %>"><button class="qbtn">+</button></a>
                </div>
                <div class="row-total"><%= df.format(iprice * qty) %></div>
                <a href="shoppingCart.jsp?action=remove&pid=<%= pid %>"><button class="del">🗑</button></a>
            </div>
            <% } } %>
        </div>

        <!-- SUMMARY -->
        <div class="summary">
            <h3>Order Summary</h3>
            <div class="srow"><span>Subtotal</span><span><%= df.format(subtotal) %></span></div>
            <div class="srow">
                <span>Shipping</span>
                <% if (shipping == 0 && subtotal > 0) { %><span class="free">FREE</span>
                <% } else { %><span><%= df.format(shipping) %></span><% } %>
            </div>
            <% if (subtotal > 0 && subtotal <= 100) { %>
            <p class="note">Add $<%= df.format(100 - subtotal) %> more for free shipping!</p>
            <% } %>
            <div class="srow total"><span>Total</span><span><%= df.format(total) %></span></div>
            <button class="btn-checkout" <%= cartLen == 0 ? "disabled" : "" %>>Proceed to Checkout →</button>
            <% if (cartLen > 0) { %>
            <a href="shoppingCart.jsp?action=clear&pid=0"><button class="btn-clear">Clear Cart</button></a>
            <% } %>
        </div>
    </div>

</div>
</body>
</html>